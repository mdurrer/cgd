from math import *
import numpy as np
class Bitmap(object):
	width, height = float(),float()
	display = np.array([],dtype=int)
	def __init__(self,width,height):
		self.width, self.height = width,height
		self.display = np.zeros([self.width * self.height * 4],dtype=int)
	def getWidth(self):
		return self.width
	def setWidth(self,value):
		self.width = value
	def getHeight(self):
		return self.height
	def setHeight(self,value):
		self.height = value
