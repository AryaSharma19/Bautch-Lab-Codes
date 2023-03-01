from PIL import ImageDraw
from PIL import Image
from tkinter.filedialog import askopenfilename
import time
from Pixel import Pixel
from typing import List, Optional
import math

# image = Image.open(askopenfilename(title='Select File')) #needs a full path
#opens Image
#print(image.format, image.size, image.mode)

#converts Image to Luminence mode from RGB

threshold: int = 100
pixels: List[Pixel] = []
image: Image.Image
image1: Image.Image

def main() -> None: 
    global image 
    image = processing("D:/Test/E464 Control Lyve-AF647 + EMCN-AF488 + aSMA-Cy3 + DAPI x20_Cycle_Cycle/Processed Images/E464 LIV1 Greyscale.tif")
    image.show
    global image1
    image1 = image.convert("RGB")
    partition_image()
    draw_liver()
    image1.show()

def partition_image() -> None:
    print("Started Partition")
    global pixels
    for i in range(0, image.width):
        for j in range (0, image.height):
            pixels.append(Pixel(i,j,image,threshold))
    return

def draw_liver() -> None:
    print("Started Drawing")
    for i in pixels:
        if i.is_liver():
            draw(i.get_coordinates())
            continue
        draw(i.get_coordinates(),"black")
    return

def processing(path: str) -> Image.Image:
    image = Image.open(path)
    img = image.convert("L")
    return img

def draw(coordinates, color: Optional[str] = None):
    if not color == None:
        ImageDraw.Draw(image1).point(coordinates,fill=color)
        return
    ImageDraw.Draw(image1).point(coordinates,fill="#00FFFF")
    return

if __name__ == "__main__":
    main()