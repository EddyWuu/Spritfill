# Spritfill Server
# - Pixelation service for Recreate feature
# - Submission review dashboard for community catalog
# - usage: python3 app.py, to kill: Ctrl+C, or "kill $(lsof -t -i:5001)"

from flask import Flask, request, send_file, render_template, redirect, url_for, jsonify
from PIL import Image, ImageOps
import os
import base64
from datetime import datetime, timezone

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

    if tab == "approved":
        # Approved items live in community_sprites (deleted from submissions on approve)
        docs = db.collection("community_sprites").stream()
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            data["projectName"] = data.get("projectName") or data.get("name", "Untitled")
            data["artistName"] = data.get("artistName") or data.get("artist", "Anonymous")
            if data.get("approvedAt"):
                try:
                    data["submittedAtFormatted"] = data["approvedAt"].strftime("%B %d, %Y at %I:%M %p")
                except Exception:
                    data["submittedAtFormatted"] = "Unknown"
            elif data.get("submittedAt"):
                try:
                    data["submittedAtFormatted"] = data["submittedAt"].strftime("%B %d, %Y at %I:%M %p")
                except Exception:
                    data["submittedAtFormatted"] = "Unknown"
            else:
                data["submittedAtFormatted"] = "Unknown"
            if data.get("imageBase64"):
                data["imageDataURL"] = f"data:image/png;base64,{data['imageBase64']}"
            else:
                data["imageDataURL"] = None
            submissions.append(data)
    else:
        # Pending and rejected live in submissions
        docs = db.collection("submissions").where("status", "==", tab).stream()
        for doc in docs:
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
            submissions.append(data)

    # Sort by date (newest first)
    # Use datetime.min as fallback for items without dates (comparable to DatetimeWithNanoseconds)
    min_datetime = datetime.min.replace(tzinfo=timezone.utc)
    submissions.sort(key=lambda s: s.get("submittedAt") or s.get("approvedAt") or min_datetime, reverse=True)

    # Count docs per status
    counts = {}
    for status in ["pending_review", "rejected"]:
        count_docs = db.collection("submissions").where("status", "==", status).stream()
        counts[status] = sum(1 for _ in count_docs)
    counts["approved"] = sum(1 for _ in db.collection("community_sprites").stream())

    return render_template("review.html", submissions=submissions, tab=tab, counts=counts)


@app.route("/review/<doc_id>/approve", methods=["POST"])
def approve_submission(doc_id):
    """Approve a submission — moves to community_sprites, deletes from submissions."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("submissions").document(doc_id).get()
    if not doc.exists:
        return "Submission not found", 404

    data = doc.to_dict()

    community_data = {
        "name": data.get("projectName", "Untitled"),
        "artist": data.get("artistName", "Anonymous"),
        "canvasWidth": data.get("canvasWidth", 0),
        "canvasHeight": data.get("canvasHeight", 0),
        "pixelGrid": data.get("pixelGrid", []),
        "imageBase64": data.get("imageBase64", ""),
        "approvedAt": firestore.SERVER_TIMESTAMP,
        "submissionId": doc_id,
        # Preserve original fields for unapprove restore
        "projectName": data.get("projectName", "Untitled"),
        "artistName": data.get("artistName", "Anonymous"),
        "submittedAt": data.get("submittedAt"),
        "id": data.get("id", doc_id),
    }
    db.collection("community_sprites").document(doc_id).set(community_data)

    # Remove from submissions — data now lives only in community_sprites
    db.collection("submissions").document(doc_id).delete()
    return redirect(url_for("review_dashboard", tab="pending_review"))


@app.route("/review/<doc_id>/unapprove", methods=["POST"])
def unapprove_submission(doc_id):
    """Unapprove — restores to submissions, removes from community_sprites."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("community_sprites").document(doc_id).get()
    if not doc.exists:
        return "Community sprite not found", 404

    data = doc.to_dict()

    submission_data = {
        "id": data.get("id", doc_id),
        "artistName": data.get("artistName") or data.get("artist", "Anonymous"),
        "projectName": data.get("projectName") or data.get("name", "Untitled"),
        "canvasWidth": data.get("canvasWidth", 0),
        "canvasHeight": data.get("canvasHeight", 0),
        "pixelGrid": data.get("pixelGrid", []),
        "imageBase64": data.get("imageBase64", ""),
        "submittedAt": data.get("submittedAt"),
        "status": "pending_review",
    }
    db.collection("submissions").document(doc_id).set(submission_data)
    db.collection("community_sprites").document(doc_id).delete()
    return redirect(url_for("review_dashboard", tab="approved"))


@app.route("/review/<doc_id>/reject", methods=["POST"])
def reject_submission(doc_id):
    """Reject a submission — removes from both collections."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    db.collection("community_sprites").document(doc_id).delete()
    db.collection("submissions").document(doc_id).delete()
    return redirect(url_for("review_dashboard", tab="pending_review"))


@app.route("/review/<doc_id>/delete", methods=["POST"])
def delete_submission(doc_id):
    """Permanently delete a submission from both collections."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    db.collection("submissions").document(doc_id).delete()
    db.collection("community_sprites").document(doc_id).delete()
    tab = request.args.get("tab", "pending_review")
    return redirect(url_for("review_dashboard", tab=tab))


# Helper: find a document in submissions or community_sprites
def _find_doc(doc_id):
    doc = db.collection("submissions").document(doc_id).get()
    if doc.exists:
        return doc
    doc = db.collection("community_sprites").document(doc_id).get()
    if doc.exists:
        return doc
    return None


@app.route("/review/<doc_id>/details")
def submission_details(doc_id):
    """View full details of a submission."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = _find_doc(doc_id)
    if not doc:
        return "Submission not found", 404

    data = doc.to_dict()
    data["id"] = doc.id
    data["projectName"] = data.get("projectName") or data.get("name", "Untitled")
    data["artistName"] = data.get("artistName") or data.get("artist", "Anonymous")

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
    """Export the pixel grid JSON."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = _find_doc(doc_id)
    if not doc:
        return "Submission not found", 404

    data = doc.to_dict()

    export = {
        "name": data.get("projectName") or data.get("name", "Untitled"),
        "artist": data.get("artistName") or data.get("artist", "Anonymous"),
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

    doc = _find_doc(doc_id)
    if not doc:
        return "Submission not found", 404

    data = doc.to_dict()
    image_b64 = data.get("imageBase64")
    if not image_b64:
        return "No image data", 404

    import io
    image_bytes = base64.b64decode(image_b64)
    name = (data.get("projectName") or data.get("name", "submission")).replace(" ", "_")

    return send_file(
        io.BytesIO(image_bytes),
        mimetype="image/png",
        as_attachment=True,
        download_name=f"{name}.png"
    )


if __name__ == "__main__":
    app.run(debug=True, port=5001)