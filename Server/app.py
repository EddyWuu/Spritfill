# server for Spritfill

from flask import Flask, request, send_file
from PIL import Image, ImageOps
import os

app = Flask(__name__)

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

if __name__ == "__main__":
    app.run(debug=True)
