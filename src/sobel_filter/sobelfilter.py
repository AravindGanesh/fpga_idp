import numpy as np
from PIL import Image

filename = 'img_137.jpg'

img = np.array(Image.open(filename)) // 8
Gx = np.array([-1, -2, -1, 0, 0, 0, 1, 2, 1]).reshape((3,3))

def conv2d(a, b):
	out = np.array([[np.dot(a[i:i+3, j:j+3], b) for j in range(26)] for i in range(26)])
	return out
	
outx = conv2d(img, Gx)
 
im = Image.fromarray(outx.astype())
