# Spritfill Server
# - Pixelation service for Recreate feature
# - Submission review dashboard for community catalog
# - usage: python3 app.py, to kill: Ctrl+C, or "kill $(lsof -t -i:5001)"

from flask import Flask, request, send_file, render_template, redirect, url_for, jsonify
from PIL import Image, ImageOps
import os
import base64

import firebase_admin
from firebase_admin import credentials, firestore

SERVICE_ACCOUNT_PATH = os.path.join(os.path.dirname(__file__), "serviceAccountKey.json")

if os.path.exists(SERVICE_ACCOUNT_PATH):
    cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    FIREBASE_ENABLED = True
    print("✅ Firebase connected")
else:
    db = None
    FIREBASE_ENABLED = False
    print("⚠️  serviceAccountKey.json not found — review dashboard disabled")
    print(f"   Expected at: {SERVICE_ACCOUNT_PATH}")
    print("   Download from: Firebase Console → Project Settings → Service Accounts → Generate New Private Key")

app = Flask(__name__)


# ── Pixelation Service (existing) ────────────────────────────────────

def pixelate_image(input_path, output_path, tile_size):
    img = Image.open(input_path)
    img = ImageOps.exif_transpose(img)
    width, height = img.size

    small_size = (width // tile_size, height // tile_size)
    img_small = img.resize(small_size, resample=Image.BILINEAR)
    result = img_small.resize((width, height), resample=Image.NEAREST)

    result.save(output_path)


@app.route("/pixelate", methods=["POST"])
def handle_pixelate():
    if 'image' not in request.files:
        return "No image file uploaded", 400

    image_file = request.files['image']
    tile_size = int(request.form.get('tile_size', 16))

    os.makedirs("temp", exist_ok=True)
    input_path = "temp/input.jpg"
    output_path = "temp/output.png"

    image_file.save(input_path)
    pixelate_image(input_path, output_path, tile_size)

    return send_file(output_path, mimetype='image/png')


@app.route("/")
def index():
    """Redirect to the review dashboard."""
    return redirect(url_for("review_dashboard"))


@app.route("/review")
def review_dashboard():
    """Main review dashboard — shows submissions by status."""
    if not FIREBASE_ENABLED:
        return "<h1>Firebase not configured</h1><p>Place serviceAccountKey.json in the Server/ folder.</p>", 503

    tab = request.args.get("tab", "pending_review")

    submissions = []
    docs = db.collection("submissions").where("status", "==", tab).stream()

    for doc in docs:
        data = doc.to_dict()
        data["id"] = doc.id

        # Format the timestamp
        if data.get("submittedAt"):
            data["submittedAtFormatted"] = data["submittedAt"].strftime("%B %d, %Y at %I:%M %p")
        else:
            data["submittedAtFormatted"] = "Unknown"

        # Build a data URL from the base64 PNG for display
        if data.get("imageBase64"):
            data["imageDataURL"] = f"data:image/png;base64,{data['imageBase64']}"
        else:
            data["imageDataURL"] = None

        submissions.append(data)

    # Sort by date (newest first) — done in Python to avoid needing a Firestore composite index
    submissions.sort(key=lambda s: s.get("submittedAt") or "", reverse=True)

    counts = {}
    for status in ["pending_review", "approved", "rejected"]:
        count_docs = db.collection("submissions").where("status", "==", status).stream()
        counts[status] = sum(1 for _ in count_docs)

    return render_template("review.html", submissions=submissions, tab=tab, counts=counts)


@app.route("/review/<doc_id>/approve", methods=["POST"])
def approve_submission(doc_id):
    """Approve a submission — copies to community_sprites collection and marks as approved."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("submissions").document(doc_id).get()
    if not doc.exists:
        return "Submission not found", 404

    data = doc.to_dict()

    # Copy to community_sprites collection (what the iOS app reads)
    community_data = {
        "name": data.get("projectName", "Untitled"),
        "artist": data.get("artistName", "Anonymous"),
        "canvasWidth": data.get("canvasWidth", 0),
        "canvasHeight": data.get("canvasHeight", 0),
        "pixelGrid": data.get("pixelGrid", []),
        "imageBase64": data.get("imageBase64", ""),
        "approvedAt": firestore.SERVER_TIMESTAMP,
        "submissionId": doc_id,
    }
    db.collection("community_sprites").document(doc_id).set(community_data)

    # Mark the original submission as approved
    db.collection("submissions").document(doc_id).update({"status": "approved"})
    return redirect(url_for("review_dashboard", tab="pending_review"))


@app.route("/review/<doc_id>/unapprove", methods=["POST"])
def unapprove_submission(doc_id):
    """Unapprove a submission — removes from community_sprites and sets back to pending."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    db.collection("community_sprites").document(doc_id).delete()
    db.collection("submissions").document(doc_id).update({"status": "pending_review"})
    return redirect(url_for("review_dashboard", tab="approved"))


@app.route("/review/<doc_id>/reject", methods=["POST"])
def reject_submission(doc_id):
    """Reject a submission — removes from community_sprites and deletes from submissions."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    db.collection("community_sprites").document(doc_id).delete()
    db.collection("submissions").document(doc_id).delete()
    return redirect(url_for("review_dashboard", tab="pending_review"))


@app.route("/review/<doc_id>/delete", methods=["POST"])
def delete_submission(doc_id):
    """Permanently delete a submission."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    db.collection("submissions").document(doc_id).delete()
    tab = request.args.get("tab", "pending_review")
    return redirect(url_for("review_dashboard", tab=tab))


@app.route("/review/<doc_id>/details")
def submission_details(doc_id):
    """View full details of a submission — including pixel grid data for export."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("submissions").document(doc_id).get()
    if not doc.exists:
        return "Submission not found", 404

    data = doc.to_dict()
    data["id"] = doc.id

    if data.get("submittedAt"):
        data["submittedAtFormatted"] = data["submittedAt"].strftime("%B %d, %Y at %I:%M %p")
    else:
        data["submittedAtFormatted"] = "Unknown"

    if data.get("imageBase64"):
        data["imageDataURL"] = f"data:image/png;base64,{data['imageBase64']}"
    else:
        data["imageDataURL"] = None

    return render_template("details.html", submission=data)


@app.route("/review/<doc_id>/export")
def export_submission(doc_id):
    """Export the pixel grid JSON — for adding to PremadeSprites catalog."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("submissions").document(doc_id).get()
    if not doc.exists:
        return "Submission not found", 404

    data = doc.to_dict()

    export = {
        "name": data.get("projectName", "Untitled"),
        "artist": data.get("artistName", "Anonymous"),
        "canvasWidth": data.get("canvasWidth", 0),
        "canvasHeight": data.get("canvasHeight", 0),
        "pixelGrid": data.get("pixelGrid", [])
    }

    return jsonify(export)


@app.route("/review/<doc_id>/download-png")
def download_png(doc_id):
    """Download the submission as a PNG file."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("submissions").document(doc_id).get()
    if not doc.exists:
        return "Submission not found", 404

    data = doc.to_dict()
    image_b64 = data.get("imageBase64")
    if not image_b64:
        return "No image data", 404

    import io
    image_bytes = base64.b64decode(image_b64)
    name = data.get("projectName", "submission").replace(" ", "_")

    return send_file(
        io.BytesIO(image_bytes),
        mimetype="image/png",
        as_attachment=True,
        download_name=f"{name}.png"
    )


if __name__ == "__main__":
    app.run(debug=True, port=5001)
