import base64
import glob
import io

import cv2
from PIL import Image, ImageFont, ImageDraw
from numpy import ndarray

IMG_SIZE = 100


def main():
    # img = open_image(image_selector())
    img = resize_img(open_image("images/urss.jpg"))
    img = ascii_to_img(img_to_ascii(img), img)
    img.show()
    print(encode_img(img))


def img_to_ascii(img: ndarray) -> list[list[str]]:
    height, width, _ = img.shape
    return [
        [ascii_machina(img[row, col]) for col in range(width)]
        for row in range(height)
    ]


def image_selector() -> str:
    images = sorted(glob.glob("images/*.png") + glob.glob("images/*.jpeg"))
    return images[
        int(
            input(
                "\n".join(f"{i}: {img}" for i, img in enumerate(images))
                + "\n> "
            )
        )
    ]


def open_image(img_path: str) -> ndarray:
    img = cv2.imread(img_path, cv2.IMREAD_COLOR)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    return img


def resize_img(img: ndarray) -> ndarray:
    height, width, _ = img.shape
    if height > width:
        return cv2.resize(img, (round(width / height * IMG_SIZE), IMG_SIZE))
    return cv2.resize(img, (IMG_SIZE, round(height / width * IMG_SIZE)))


def ascii_machina(pixel: list[int, int, int]) -> str:
    character_ramp = " .:-=+*#%@"
    index = round(max(pixel) / 255 * (len(character_ramp) - 1))
    return character_ramp[index]


def show_ascii(ascii_img: list[list[str]]) -> None:
    print("\n".join(" ".join(row) for row in ascii_img))


def ascii_to_img(ascii_img: list[list[str]], img: ndarray) -> Image:
    height, width, _ = img.shape
    result_img = Image.new("RGB", (width * 10, height * 10), (0, 0, 0))
    font = ImageFont.load_default()
    draw = ImageDraw.Draw(result_img)
    for i, row in enumerate(ascii_img):
        for j, pixel in enumerate(row):
            draw.text(
                (0 + 10 * j, 0 + 10 * i),
                pixel,
                fill=tuple(img[i, j]),
                font=font,
            )
    return result_img


def encode_img(img):
    img_bytes = io.BytesIO()
    img.save(img_bytes, format="PNG")
    img_bytes = img_bytes.getvalue()
    return base64.b64encode(img_bytes)


if __name__ == "__main__":
    main()
