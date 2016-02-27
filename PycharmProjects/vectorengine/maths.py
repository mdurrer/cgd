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

	def normalize(self):
		length = self.length()
		return Vector2f(self.x / length, self.y / length)

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
		return float(sqrt(self.x * self.x + self.y * self.y, self.z * self.z))

	def normalize(self):
		length = self.length()
		return Vector3f(self.x / length, self.y / length, self.z / length)


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


class Matrix4f(object):
	matrix = np.matrix([],dtype=float)

	def __init__(self, m00=0.0,m01=0.0,m02=0.0,m03=0.0,m10=0.0,m11=0.0,m12=0.0,m13=0.0,m20=0.0,m21=0.0,m22=0.0,m23=0.0,m30=0.0,m31=0.0,m32=0.0,m33=0.0):
		self.matrix = np.matrix([m00,m01,m02,m03,m10,m11,m12,m13,m20,m21,m22,m23,m30,m31,m32,m33],dtype=float).reshape(4,4)
	def initIdentity(self,m00=1.0,m01=0.0,m02=0.0,m03=0.0,m10=0.0,m11=1.0,m12=0.0,m13=0.0,m20=0.0,m21=0.0,m22=1.0,m23=0.0,m30=0.0,m31=0.0,m32=0.0,m33=1.0):
		self.matrix = np.matrix([m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33], dtype=float).reshape(4, 4)



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
