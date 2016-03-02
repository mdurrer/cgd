from math import *
import numpy as np
class Quaternion(object):
	x, y, z, w = float(), float(), float(), float()

	def __init__(self, *args):
		if len(args) == 2:
			sinHalfAngle = float(sin(args[1]) / 2)
			coshalfAngle = float(cos(args[1]) / 2)
			self.x = float(args[0].getX() * sinHalfAngle)
			self.y = float(args[0].getY() * sinHalfAngle)
			self.z = float(args[0].getZ() * sinHalfAngle)
			self.w = coshalfAngle
		if len(args) == 4:
			self.x = args[0]
			self.y = args[1]
			self.z = args[2]
			self.w = args[3]

		if len(args) <= 1:
			self.x = float()
			self.y = float()
			self.z = float()
			self.w = float()
	def __repr__(self):
		return "X=%f,Y=%f,Z=%f,W=%f" % (self.x, self.y, self.z, self.w)
