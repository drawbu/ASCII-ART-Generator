import base64
import io

import numpy
from PIL import Image
from flask import Flask, send_from_directory, request, jsonify

from img_to_ascii import (
    ascii_to_img,
    img_to_ascii,
    encode_img,
    resize_img,
)

app = Flask(__name__)


# Path for our main Svelte page
@app.route("/")
def home():
    return send_from_directory("client/public", "index.html")


# Path for all the static files (compiled JS/CSS, etc.)
@app.route("/<path:path>")
def static_files(path):
    return send_from_directory("client/public", path)


@app.route("/img", methods=["POST"])
def test():
    img = base64.b64decode(request.json["image"].split(",")[1])
    img = Image.open(io.BytesIO(img)).convert("RGB")
    img = resize_img(numpy.array(img))
    img = ascii_to_img(img_to_ascii(img), img)
    img = "data:image/png;base64," + encode_img(img).decode("utf-8")

    return jsonify({"image": img})


if __name__ == "__main__":
    app.run()
