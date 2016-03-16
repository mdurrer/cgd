from math import *
import numpy as np
from PIL import Image
import pygame
class Bitmap(object):
	width, height = float(),float()
	display = np.array([],dtype=int)
	def __init__(self,*args):
		if len(args) == 2:
			self.width, self.height = args[0],args[1]
			self.display = np.zeros([self.width * self.height * 4],dtype=int)
			self.display = Image.fromarray(self.display)
		else:
			img = Image.open(args[0])
			img =  img.convert("RGBA")
			self.width,self.height = img.size
				#self.display = np.array([self.width * self.height * 4], dtype=int)
			self.display = np.array(img)
			self.display  = Image.fromarray(self.display)


	def getWidth(self):
		return self.width
	def setWidth(self,value):
		self.width = value
	def getHeight(self):
		return self.height
	def setHeight(self,value):
		self.height = value
