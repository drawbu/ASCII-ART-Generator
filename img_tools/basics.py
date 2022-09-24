import io
import sys
import glob
import base64
from os.path import exists

import cv2
from numpy import ndarray


def image_selector() -> str:
    images = sorted(glob.glob("../assets/*.png") + glob.glob("../assets/*.jpeg"))
    return images[
        int(input("\n".join(f"{i}: {img}" for i, img in enumerate(images)) + "\n> "))
    ]


def open_image(img_path: str) -> ndarray:
    if not exists(img_path):
        print("The file you tried to open does not exists.")
        sys.exit()
    img = cv2.imread(img_path, cv2.IMREAD_COLOR)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    return img


def resize_img(img: ndarray, size: int = 100) -> ndarray:
    height, width, _ = img.shape
    if height > width:
        return cv2.resize(img, (round(width / height * size), size))
    return cv2.resize(img, (size, round(height / width * size)))


def encode_img(img):
    img_bytes = io.BytesIO()
    img.save(img_bytes, format="PNG")
    img_bytes = img_bytes.getvalue()
    return base64.b64encode(img_bytes)

