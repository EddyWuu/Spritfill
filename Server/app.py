# Spritfill Server
# - Pixelation service for Recreate feature
# - Submission review dashboard for community catalog
# - Premade arts upload, pixelation, and review
# - usage: python3 app.py, to kill: Ctrl+C, or "kill $(lsof -t -i:5001)"

from flask import Flask, request, send_file, render_template, redirect, url_for, jsonify
from PIL import Image, ImageOps, ImageFilter, ImageEnhance

import os
import io
import base64
import math
from datetime import datetime, timezone

import numpy as np
import cv2

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


# ── Landing Page ─────────────────────────────────────────────────────

@app.route("/")
def index():
    """Landing page with links to both dashboards."""
    return '''
    <html>
    <head><style>
        body { font-family: -apple-system, sans-serif; background: #0d1117; color: #e6edf3;
               display: flex; flex-direction: column; align-items: center; justify-content: center;
               min-height: 100vh; gap: 24px; }
        a { display: inline-block; padding: 16px 32px; background: #161b22; border: 1px solid #30363d;
            border-radius: 12px; color: #e6edf3; text-decoration: none; font-size: 18px; font-weight: 600;
            transition: all 0.15s; }
        a:hover { border-color: #7c5CFC; background: #1c2128; }
        h1 span { color: #7c5CFC; }
    </style></head>
    <body>
        <h1>🎨 <span>Spritfill</span> Server</h1>
        <a href="/review">📋 Submission Review Dashboard</a>
        <a href="/arts">🖼️ Premade Arts Upload</a>
        <a href="/arts/review">🖼️ Premade Arts Review</a>
    </body></html>
    '''


# ── Submission Review Dashboard ──────────────────────────────────────

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
        "projectName": data.get("projectName", "Untitled"),
        "artistName": data.get("artistName", "Anonymous"),
        "submittedAt": data.get("submittedAt"),
        "id": data.get("id", doc_id),
    }

    # Include personal link if provided
    if data.get("personalLink"):
        community_data["personalLink"] = data["personalLink"]

    db.collection("community_sprites").document(doc_id).set(community_data)
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

    # Preserve personal link if present
    if data.get("personalLink"):
        submission_data["personalLink"] = data["personalLink"]

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

    image_bytes = base64.b64decode(image_b64)
    name = (data.get("projectName") or data.get("name", "submission")).replace(" ", "_")

    return send_file(
        io.BytesIO(image_bytes),
        mimetype="image/png",
        as_attachment=True,
        download_name=f"{name}.png"
    )


# ── Premade Arts workflow ─────────────────────────────────────────────
# Upload an image -> pixelate to 64x64 or 128x128 -> review -> approve to premade_arts collection

# ── Refinement methods ────────────────────────────────────────────────

def _pil_to_cv(img):
    """PIL RGBA image -> OpenCV BGRA numpy array."""
    return cv2.cvtColor(np.array(img), cv2.COLOR_RGBA2BGRA)


def _cv_to_pil(arr):
    """OpenCV BGRA numpy array -> PIL RGBA image."""
    return Image.fromarray(cv2.cvtColor(arr, cv2.COLOR_BGRA2RGBA))


def _quantize_colors(img, num_colors=48):
    """Reduce colours using median-cut quantisation (no dithering)."""
    alpha = img.getchannel("A") if img.mode == "RGBA" else None
    rgb = img.convert("RGB")
    quantized = rgb.quantize(colors=num_colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    result = quantized.convert("RGB")
    if alpha is not None:
        result = result.convert("RGBA")
        result.putalpha(alpha)
    return result


def refine_none(img, target_size):
    """Baseline: simple LANCZOS downscale -- no refinement."""
    return img.resize((target_size, target_size), resample=Image.LANCZOS)


def refine_edge_aware(img, target_size):
    """
    Edge-detection + blending.
    1. Detect edges at original resolution using Canny.
    2. Dilate edges slightly so they survive downscale.
    3. Downscale both image and edge mask.
    4. Where edges exist, use sharpened pixels to counteract averaging blur.
    5. Quantise to a limited palette for a clean pixel-art feel.
    """
    cv_img = _pil_to_cv(img)

    # Canny on the luminance channel
    gray = cv2.cvtColor(cv_img, cv2.COLOR_BGRA2GRAY)
    edges = cv2.Canny(gray, 80, 200)

    # Dilate so thin edges survive downscale
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
    edges = cv2.dilate(edges, kernel, iterations=1)

    # Downscale both image and edge mask
    small_cv = cv2.resize(cv_img, (target_size, target_size), interpolation=cv2.INTER_AREA)
    small_edges = cv2.resize(edges, (target_size, target_size), interpolation=cv2.INTER_AREA)

    # Normalise edge mask to 0-1 float
    edge_mask = (small_edges.astype(np.float32) / 255.0)

    # Create a sharpened version of the downscaled image
    blur = cv2.GaussianBlur(small_cv, (0, 0), 1.0)
    sharpened = cv2.addWeighted(small_cv, 1.8, blur, -0.8, 0)
    sharpened = np.clip(sharpened, 0, 255).astype(np.uint8)

    # Blend: use sharpened pixels where edges exist, original elsewhere
    mask_4ch = np.stack([edge_mask] * 4, axis=-1)
    blended = (mask_4ch * sharpened.astype(np.float32) +
               (1 - mask_4ch) * small_cv.astype(np.float32))
    blended = np.clip(blended, 0, 255).astype(np.uint8)

    result = _cv_to_pil(blended)
    result = _quantize_colors(result, num_colors=64)
    return result


def refine_supersample(img, target_size):
    """
    Higher-resolution downsampling (super-sample).
    1. Upscale the original to 4x the target using LANCZOS.
    2. Apply a sharpening pass at high resolution.
    3. Downscale in two steps: first to 2x target, sharpen again, then to target.
    4. Final colour quantisation for a clean palette.
    """
    intermediate = target_size * 4
    big = img.resize((intermediate, intermediate), resample=Image.LANCZOS)

    # Sharpen at high res
    big = big.filter(ImageFilter.UnsharpMask(radius=2, percent=120, threshold=2))

    # Downscale to 2x target
    mid_size = target_size * 2
    mid = big.resize((mid_size, mid_size), resample=Image.LANCZOS)
    mid = mid.filter(ImageFilter.UnsharpMask(radius=1, percent=100, threshold=2))

    # Final downscale to target
    small = mid.resize((target_size, target_size), resample=Image.LANCZOS)

    small = _quantize_colors(small, num_colors=64)
    return small


def refine_unsharp_mask(img, target_size):
    """
    Unsharp mask refinement.
    1. Downscale to target with LANCZOS.
    2. Apply a strong unsharp mask to boost edge contrast.
    3. Slightly increase colour saturation and contrast.
    4. Quantise to a limited palette.
    """
    small = img.resize((target_size, target_size), resample=Image.LANCZOS)

    # Strong unsharp mask
    small = small.filter(ImageFilter.UnsharpMask(radius=1, percent=200, threshold=1))

    # Boost saturation slightly
    enhancer = ImageEnhance.Color(small)
    small = enhancer.enhance(1.3)

    # Boost contrast slightly
    enhancer = ImageEnhance.Contrast(small)
    small = enhancer.enhance(1.15)

    small = _quantize_colors(small, num_colors=64)
    return small


REFINE_METHODS = {
    "none": refine_none,
    "edge_aware": refine_edge_aware,
    "supersample": refine_supersample,
    "unsharp": refine_unsharp_mask,
}

REFINE_LABELS = {
    "none": "None (baseline)",
    "edge_aware": "Edge Detection + Blending",
    "supersample": "Super-sample (multi-step downscale)",
    "unsharp": "Unsharp Mask",
}


def _grid_and_b64(img_small, target_size):
    """From a target_size x target_size RGBA image, return (grid_string, preview_base64)."""
    pixels = list(img_small.getdata())
    grid = []
    for r, g, b, a in pixels:
        if a < 10:
            grid.append("clear")
        else:
            grid.append("#{:02X}{:02X}{:02X}".format(r, g, b))

    preview = img_small.resize((target_size * 4, target_size * 4), resample=Image.NEAREST)
    buf = io.BytesIO()
    preview.save(buf, format="PNG")
    image_b64 = base64.b64encode(buf.getvalue()).decode("utf-8")

    return ",".join(grid), image_b64


def pixelate_to_grid(input_path, target_size, method="none"):
    """
    Down-sample an image to target_size x target_size using the specified
    refinement method and return (pixel_grid_string, image_base64).
    """
    img = Image.open(input_path).convert("RGBA")
    img = ImageOps.exif_transpose(img)

    refine_fn = REFINE_METHODS.get(method, refine_none)
    img_small = refine_fn(img, target_size)

    # Make sure we are RGBA for grid extraction
    if img_small.mode != "RGBA":
        img_small = img_small.convert("RGBA")

    return _grid_and_b64(img_small, target_size)


@app.route("/arts")
def arts_upload_page():
    """Upload page for premade arts."""
    return render_template("arts_upload.html")


@app.route("/arts/preview", methods=["POST"])
def arts_preview():
    """Generate previews for ALL refinement methods so the user can compare."""
    if "image" not in request.files:
        return jsonify({"error": "No image file uploaded"}), 400

    image_file = request.files["image"]
    target_size = int(request.form.get("size", 128))
    if target_size not in (64, 128):
        return jsonify({"error": "Size must be 64 or 128"}), 400

    os.makedirs("temp", exist_ok=True)
    input_path = "temp/art_preview.png"
    image_file.save(input_path)

    img = Image.open(input_path).convert("RGBA")
    img = ImageOps.exif_transpose(img)

    results = {}
    for method_key, refine_fn in REFINE_METHODS.items():
        img_small = refine_fn(img, target_size)
        if img_small.mode != "RGBA":
            img_small = img_small.convert("RGBA")
        preview = img_small.resize((target_size * 4, target_size * 4), resample=Image.NEAREST)
        buf = io.BytesIO()
        preview.save(buf, format="PNG")
        b64 = base64.b64encode(buf.getvalue()).decode("utf-8")
        results[method_key] = {
            "label": REFINE_LABELS[method_key],
            "image": f"data:image/png;base64,{b64}",
        }

    return jsonify(results)


@app.route("/arts/upload", methods=["POST"])
def arts_upload():
    """Receive an uploaded image, pixelate it, and store in pending_arts for review."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    if "image" not in request.files:
        return "No image file uploaded", 400

    image_file = request.files["image"]
    art_name = request.form.get("name", "Untitled Art").strip() or "Untitled Art"
    target_size = int(request.form.get("size", 128))
    if target_size not in (64, 128):
        return "Size must be 64 or 128", 400
    method = request.form.get("method", "none")
    if method not in REFINE_METHODS:
        method = "none"

    os.makedirs("temp", exist_ok=True)
    input_path = "temp/art_input.png"
    image_file.save(input_path)

    grid, image_b64 = pixelate_to_grid(input_path, target_size, method=method)

    doc_data = {
        "name": art_name,
        "canvasWidth": target_size,
        "canvasHeight": target_size,
        "pixelGridString": grid,
        "imageBase64": image_b64,
        "status": "pending_review",
        "uploadedAt": firestore.SERVER_TIMESTAMP,
        "method": method,
    }

    db.collection("pending_arts").add(doc_data)
    return redirect(url_for("arts_review_dashboard", tab="pending_review"))


@app.route("/arts/review")
def arts_review_dashboard():
    """Review dashboard for premade arts."""
    if not FIREBASE_ENABLED:
        return "<h1>Firebase not configured</h1>", 503

    tab = request.args.get("tab", "pending_review")
    items = []

    if tab == "approved":
        docs = db.collection("premade_arts").stream()
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            if data.get("approvedAt"):
                try:
                    data["dateFormatted"] = data["approvedAt"].strftime("%B %d, %Y at %I:%M %p")
                except Exception:
                    data["dateFormatted"] = "Unknown"
            else:
                data["dateFormatted"] = "Unknown"
            if data.get("imageBase64"):
                data["imageDataURL"] = f"data:image/png;base64,{data['imageBase64']}"
            else:
                data["imageDataURL"] = None
            items.append(data)
    else:
        docs = db.collection("pending_arts").where("status", "==", tab).stream()
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            if data.get("uploadedAt"):
                try:
                    data["dateFormatted"] = data["uploadedAt"].strftime("%B %d, %Y at %I:%M %p")
                except Exception:
                    data["dateFormatted"] = "Unknown"
            else:
                data["dateFormatted"] = "Unknown"
            if data.get("imageBase64"):
                data["imageDataURL"] = f"data:image/png;base64,{data['imageBase64']}"
            else:
                data["imageDataURL"] = None
            items.append(data)

    min_datetime = datetime.min.replace(tzinfo=timezone.utc)
    items.sort(key=lambda s: s.get("uploadedAt") or s.get("approvedAt") or min_datetime, reverse=True)

    counts = {}
    for status in ["pending_review", "rejected"]:
        count_docs = db.collection("pending_arts").where("status", "==", status).stream()
        counts[status] = sum(1 for _ in count_docs)
    counts["approved"] = sum(1 for _ in db.collection("premade_arts").stream())

    return render_template("arts_review.html", items=items, tab=tab, counts=counts)


@app.route("/arts/<doc_id>/approve", methods=["POST"])
def arts_approve(doc_id):
    """Approve a pending art — move to premade_arts collection."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("pending_arts").document(doc_id).get()
    if not doc.exists:
        return "Not found", 404

    data = doc.to_dict()

    # Carry pixelGridString; also handle legacy docs that used pixelGrid array
    grid_str = data.get("pixelGridString") or ""
    if not grid_str:
        legacy = data.get("pixelGrid")
        if isinstance(legacy, list):
            grid_str = ",".join(legacy)

    approved_data = {
        "name": data.get("name", "Untitled Art"),
        "canvasWidth": data.get("canvasWidth", 128),
        "canvasHeight": data.get("canvasHeight", 128),
        "pixelGridString": grid_str,
        "imageBase64": data.get("imageBase64", ""),
        "approvedAt": firestore.SERVER_TIMESTAMP,
    }

    db.collection("premade_arts").document(doc_id).set(approved_data)
    db.collection("pending_arts").document(doc_id).delete()
    return redirect(url_for("arts_review_dashboard", tab="pending_review"))


@app.route("/arts/<doc_id>/reject", methods=["POST"])
def arts_reject(doc_id):
    """Reject a pending art."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    ref = db.collection("pending_arts").document(doc_id)
    if ref.get().exists:
        ref.update({"status": "rejected"})
    return redirect(url_for("arts_review_dashboard", tab="pending_review"))


@app.route("/arts/<doc_id>/delete", methods=["POST"])
def arts_delete(doc_id):
    """Delete from both collections."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    db.collection("pending_arts").document(doc_id).delete()
    db.collection("premade_arts").document(doc_id).delete()
    tab = request.args.get("tab", "pending_review")
    return redirect(url_for("arts_review_dashboard", tab=tab))


@app.route("/arts/<doc_id>/unapprove", methods=["POST"])
def arts_unapprove(doc_id):
    """Move approved art back to pending."""
    if not FIREBASE_ENABLED:
        return "Firebase not configured", 503

    doc = db.collection("premade_arts").document(doc_id).get()
    if not doc.exists:
        return "Not found", 404

    data = doc.to_dict()
    pending_data = {
        "name": data.get("name", "Untitled Art"),
        "canvasWidth": data.get("canvasWidth", 128),
        "canvasHeight": data.get("canvasHeight", 128),
        "pixelGridString": data.get("pixelGridString", ""),
        "imageBase64": data.get("imageBase64", ""),
        "status": "pending_review",
        "uploadedAt": data.get("approvedAt") or firestore.SERVER_TIMESTAMP,
    }

    db.collection("pending_arts").document(doc_id).set(pending_data)
    db.collection("premade_arts").document(doc_id).delete()
    return redirect(url_for("arts_review_dashboard", tab="approved"))


if __name__ == "__main__":
    app.run(debug=True, port=5001)
