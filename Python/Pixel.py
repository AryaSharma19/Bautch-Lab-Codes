from PIL import Image
import math

class Pixel:
    x: int
    y: int
    liver: bool
    threshold: int
    image: Image.Image


    def __init__(self, x: int, y: int, image: Image.Image, threshold: int):
        self.x: int = x
        self.y: int = y
        self.image = image
        self.threshold = threshold
        self.liver = False
        if self.image.getpixel((self.x,self.y)) >= threshold:
            self.liver = True
        
    
    def get_coordinates(self):
        return (self.x, self.y)

    def is_liver(self) -> bool:
        return self.liver

    