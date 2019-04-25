import serial
import numpy as np
from PIL import Image


ser = serial.Serial(port='/dev/ttyACM0', baudrate=115200)


a = ser.read(676)


temp = [ord(i) for i in a]

print(temp)
temp = list(a)

img = np.array(a).reshape(26,26)
print(img.shape)
img = 255*(img-img.min())/(img.max()-img.min())
im = Image.fromarray(img.astype(np.uint8))
im.save('out.jpg')

