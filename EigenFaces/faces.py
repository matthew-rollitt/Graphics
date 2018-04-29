from scipy import special, optimize, linalg, signal 
from PIL import Image 
from numpy import linalg as LA
import numpy as n_
import os
import math 
import matplotlib.pyplot as plt

xres = yres = 100
imageArray = []
numberOfImages = 15 
xs = range(0, numberOfImages)
facesArray = []

path = 'DATA/'

# load all the files in the data folder 
for filename in os.listdir(path):
	imageArray += [path+filename]

def img2vec(im):
	# grayscales image 
	im.convert("L") 
 	im = im.resize((xres, yres), Image.BICUBIC)
	v = n_.reshape(im, (xres * yres * 1))
 	v = n_.double(v) / 255 
	return v


for i in range(0,len(imageArray)):
	column = n_.array(img2vec(Image.open(imageArray[i])))
	facesArray += [column]

facesArray = n_.matrix(facesArray)
facesArray = facesArray.T

mean =  n_.mean(facesArray, 1)
print mean
subMatrix = n_.subtract(facesArray, mean)

U, S, V = n_.linalg.svd(subMatrix, full_matrices=True)

print U
def vec2img(v):
	v = v.reshape((yres, xres))
	v = n_.fix(255.*v)
	v8 = n_.zeros((yres, xres), n_.uint8)
	v8[:,:] = v[:,:] # python magic 
	
	return Image.fromarray(v8)

def vec2img2(e):
	scale = 1. / (n_.max(e) - n_.min(e))
	e = e - n_.min(e)
	e = e * scale
	return vec2img(e)

# draw our diagram
ylines = []
for i in range(len(imageArray)):
	ylines.append(vec2img2(U[:,i]))

fig = plt.figure()
for i in range(numberOfImages):
	plt.subplot(5, 3, i)
	img = ylines[i].convert("L")
	plt.imshow(img, plt.gray())

	frame1 = plt.gca()
	frame1.axes.get_xaxis().set_visible(False)
	frame1.axes.get_yaxis().set_visible(False)

plt.show()

