from math import *
import numpy as np
from vectors import *

class Mesh(object):
	position = Vector4f()
	texCoords = Vector4f()
	normal = Vector4f()

	def getX(self):
		return self.position.x
	def getY(self):
		return self.position.y
	def getZ(self):
		return self.position.z
	def getW(self):
		return self.position.w
