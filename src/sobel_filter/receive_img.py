import serial
import numpy as np
from PIL import Image

ser = serial.Serial(port='/dev/ttyUSB0', baudrate=115200)

a = ser.read(676)

temp = [ord(i) for i in a]

print(temp)
print(len(temp))

img_list = temp[-16:] + temp[:-16]
print(img_list)

img = np.array(img_list).reshape((26,26))
print(img.shape)
img = 255*(img-img.min())/(img.max()-img.min())
im = Image.fromarray(img.astype(np.uint8))
im.save('output.jpg')
