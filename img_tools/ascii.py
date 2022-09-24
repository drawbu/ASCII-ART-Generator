from typing import List

from PIL import Image, ImageFont, ImageDraw
from numpy import ndarray

from img_tools import open_image, resize_img


def img_to_ascii(img: ndarray) -> List[List[str]]:
    height, width, _ = img.shape
    return [
        [ascii_machina(img[row, col]) for col in range(width)]
        for row in range(height)
    ]


def ascii_machina(pixel: List[int]) -> str:
    character_ramp = " .:-=+*#%@"
    index = round(max(pixel) / 255 * (len(character_ramp) - 1))
    return character_ramp[index]


def show_ascii(ascii_img: List[List[str]]) -> None:
    print("\n".join(" ".join(row) for row in ascii_img))


def ascii_to_img(ascii_img: List[List[str]], img: ndarray) -> Image:
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


if __name__ == "__main__":
    IMG_SIZE = 100

    img = resize_img(open_image("../assets/original_image.jpg"), 100)
    img = ascii_to_img(img_to_ascii(img), img)
    img.show()
