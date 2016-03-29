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
	def __mul__(self, other):
		w = self.w * other.getW(self) - self.x * other.getX(self) - self.y * other.getY(self) - self.z  * other.getZ(self)
		x = self.x * other.getW(self) + self.w * other.getX(self) + self.y * other.getZ(self) - self.z * other.getY(self)
		y = self.y * other.getW(self) + self.w * other.getY(self) + self.z * self.getX(self) - self.x * other.getZ(self)
		z = self.z * other.getW(self) + self.w * other.getZ(self) + self.x * other.getY(self) - self.y * other.getX(self)
	def __repr__(self):
		return "X=%f,Y=%f,Z=%f,W=%f" % (self.x, self.y, self.z, self.w)
	def conjugate(self):
		return Quaternion(-self.x,-self.y,-self.z,-self.w)
	def getW(self):
		return self.w
	def getX(self):
		return self.x
	def getY(self):
		return self.y
	def getZ(self):
		return self.z