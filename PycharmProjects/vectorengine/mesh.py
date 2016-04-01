from math import *
import numpy as np
from vectors import *
from objmodel import *
class Mesh(object):
	vertices = []
	indices = []
	def __init__(self,file):
		self.x = float()
		self.y = float()
		self.z = float()
		self.w = float()
	def getX(self):
		return self.position.x
	def getY(self):
		return self.position.y
	def getZ(self):
		return self.position.z
	def getW(self):
		return self.position.w
