from math import *
import numpy as np
class Vector2f(object):
	x, y = float(), float()

	def __init__(self, *args):
		print("New Vector2f")
		if len(args) > 0:
			self.x = float(args[0])
			self.y = float(args[1])

	def dot(self, vector):
		dx = self.x * vector.x
		dy = self.y * vector.y
		return (dx + dy)

	def normalize(self):
		length = self.length()
		return Vector2f(self.x / length, self.y / length)

	def length(self):
		return float(sqrt(self.x * self.x + self.y * self.y))
	def getX(self):
		return self.x
	def setX(self,value):
		self.x = value
	def getY(self):
		return self.y
	def setY(self, value):
		self.y = value

	def __add__(self, other):
		return Vector2f(self.x + other.x, self.y + other.y)

	def __sub__(self, other):
		return Vector2f(self.x - other.x, self.y - other.y)

	def __mul__(self, other):
		return Vector2f(self.x * other.x, self.y * other.y)

	def __truediv__(self, other):
		return Vector2f(self.x / float(other.x), self.y / float(other.y))


class Vector3f(object):
	x, y, z = float(), float(), float()

	def __init__(self, *args):
		print("New Vector3f")
		if len(args) > 0:
			self.x = float(args[0])
			self.y = float(args[1])
			self.z = float(args[2])

	def dot(self, vector):
		dx = self.x * vector.x
		dy = self.y * vector.y
		dz = self.z * vector.z
		return (dx + dy + dz)

	def length(self):
		return float(sqrt(self.x * self.x + self.y * self.y + self.z * self.z))

	def normalize(self):
		length = self.length()
		return Vector3f(self.x / length, self.y / length, self.z / length)
	def getZ(self):
		return self.z
	def setZ(self,value):
		self.z = value
def __add__(self, other):
	return Vector3f(self.x + other.x, self.y + other.y, self.z + other.z)


def __sub__(self, other):
	return Vector3f(self.x - other.x, self.y - other.y, self.z - other.z)


def __mul__(self, other):
	return Vector3f(self.x * other.x, self.y * other.y, self.z * other.z)


def __truediv__(self, other):
	return Vector3f(self.x / other.x, self.y / other.y, self.z / other.z)


class Vector4f(object):
	x, y, z, w = float(), float(), float(), float()

	def __init__(self, *args):
		print("New Vector4f")
		if len(args) > 0 and len(args) < 4:
			self.x = float(args[0])
			self.y = float(args[1])
			self.z = float(args[2])
			self.w = float(1.0)

		if len(args) > 0:
			self.x = float(args[0])
			self.y = float(args[1])
			self.z = float(args[2])
			self.w = float(args[3])

		if len(args) == 0:
			self.x = float(0)
			self.y = float(0)
			self.z = float(0)
			self.w = float(0)

	def length(self):
		return float(sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w))

	def normalize(self):
		length = self.length()
		return Vector4f(self.x / length, self.y / length, self.z / length, self.w / length)
	def getW(self):
		return self.w
	def setW(self,value):
		self.w = value

	def __add__(self, other):
		return Vector4f(self.x + other.x, self.y + other.y, self.z + other.z, self.w + other.w)

	def __sub__(self, other):
		return Vector4f(self.x - other.x, self.y - other.y, self.z - other.z, self.w - other.w)

	def __mul__(self, other):
		return Vector4f(self.x * other.x, self.y * other.y, self.z * other.z, self.w * other.w)

	def __truediv__(self, other):
		return Vector4f(self.x / other.x, self.y / other.y, self.z / other.z, self.w / other.w)

	def __repr__(self):
		return "X=%f,Y=%f,Z=%f,W=%f" % (self.x, self.y, self.z, self.w)

