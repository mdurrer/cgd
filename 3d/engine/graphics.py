#!/usr/bin/env python
# -*- coding: utf-8 -*-
from math import *
import numpy as np
import pygame,pygame.gfxdraw
debug = True
class Vector2(object):
	def __init__(self,x=0.0,y=0.0,z=0.0):
		self.x = float(x)
		self.y = float(y)
	def getX(self):
		return self.x
	def getY(self):
		return self.y
	def setX(self,val):
		self.x = val
	def setY(self,val):
		self.y = val
	def add(self,vector):
		x = self.getX()
		y = self.getY()
		return Vector2(x + vector.getX(),y + vector.getY())
	def sub(self,vector):
		x = self.getX()
		y = self.getY()
		return Vector2(x - vector.getX(),y - vector.getY())
	def mul(self,vector):
		x = self.getX()
		y = self.getY()
		return Vector2(x * vector.getX(),y * vector.getY())
	def div(self, vector):
		x = self.getX()
		y = self.getY()
		return Vector2(x / vector.getX(),y / vector.getY())
	def length(self):
		return sqrt(self.x**2 + self.y**2)
	def rotate(self,angle):
		radAngle = radians(angle)
		cosAngle = cos(radAngle)
		sinAngle = sin(radAngle)
		return Vector2((self.x * cos) - (y * sinAngle),(self.x * sinAngle ) + (self.y * cosAngle))
	"""
	def vectorToQuat(self,vector,degAngle):
		radAngle = radians(degAngle)
		c1=float(cos(vector.x/2)
		s1=float(sin(
	
		result = Quaternion()
		n = vector.normalize() # normalized  Vector = n (n with above it, unit vector)
		degAngle = float(radAngle)/2.0
		sinAngle = float(sin(radAngle))
		result.w = cos(radAngle)
		result.x = n.x* sinAngle
		result.y = n.y* sinAngle
		result.z = n.z* sinAngle
		return result	
	"""
	def dot(va,vb):
		dotProduct = (va.getX() * vb.getX())+(va.getY() * vb.getY())
		return dotProduct
	
	@staticmethod
	def getAngle(va,vb):
		dotProduct = Vector2.dot(va,vb)
		print "Skalarprodukt",dotProduct
		lva = va.length()
		lvb = vb.length()
		print "Betraege va u. vb",lva,lvb
		cosf = (dotProduct/(lva*lvb))
		print "COS F",cosf
		print degrees(acos(cosf))
		return acos(dotProduct/(lva*lvb))
	def normalize(self):
		length = length()
		x = self.x/self.length
		y = self.y/self.length
		z = self.z/self.length
		if length!=0:
			x = self.x/self.length
			y = self.y/self.length
			z = self.z/self.length
		return Vector2(x,y)
	def getCoordinates(self):
		return [self.x,self.y]
	def setCoordinates(self,x,y):
		self.x = x
		self.y = y
		return [self.x,self.y]
	def getX(self):
		return self.x
	def getY(self):
		return self.y
	def setX(self,val):
		self.x = val
	def setY(self,val):
		self.y = val

class Vector3(Vector2):
	def __init__(self,x=0.0,y=0.0,z=0.0):
		self.x = float(x)
		self.y = float(y)
		self.z = float(z)
	def getZ(self):
		return self.z
	def setZ(self,val):
		self.z = val
	def add(self,vector):
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		return Vector3(x + vector.getX(),y + vector.getY(),z + vector.getZ())
	def sub(self,vector):
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		return Vector3(x - vector.getX(),y - vector.getY(),z + vector.getZ())
	def mul(self,vector):
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		return Vector3(x * vector.getX(),y * vector.getY(),z + vector.getZ())
	def div(self, vector):
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		return Vector3(x / vector.getX(),y / vector.getY(),z + vector.getZ())
	def length(self):
		length = sqrt(self.x**2 + self.y**2 + self.z**2)
		return length
	def quatToMatrix(self,quat):
		pass

	@staticmethod
	def cross(self,vector):
		xCross = self.y * vector.getZ() - self.z * vector.getY()
		yCross = self.z * vector.getX() - self.x * vector.getZ()
		zCross = self.x * vector.getY() - self.y * vector.getX()
		return Vector3(xCross,yCross,zCross)
	@staticmethod
	def dot(self,va,vb):
		dotProduct = (va.x * vb.x)+(va.y * vb.y)+(va.z * vb.z)
		return dotProduct
	
	@staticmethod
	def getAngle(self,va,vb):
		dotProduct = Vector3.dot(va,vb)
		print "Skalarprodukt",dotProduct
		lva = va.length()
		lvb = vb.length()
		print "Betraege va u. vb",lva,lvb
		cosf = (dotProduct/(lva*lvb))
		print "COS F",cosf
		print degrees(acos(cosf))
		return acos(dotProduct/(lva*lvb))
	def normalize(self):
		self.length = self.length()
		x = self.x/self.length
		y = self.y/self.length
		z = self.z/self.length
		
		if self.length!=0:
			x = self.x/self.length
			y = self.y/self.length
			z = self.z/self.length
		return Vector3(x,y,z)
	def getCoordinates(self):
		return [self.x,self.y,self.z]
	def setCoordinates(self,x,y,z):
		self.x = x
		self.y = y
		self.z = z
		return [self.x,self.y,self.z]

class Vector4(Vector3):
	def __init__(self,x=0.0,y=0.0,z=0.0,w=0.0):
		self.x = float(x)
		self.y = float(y)
		self.z = float(z)
		self.w = float(w)
		#self.deg = float(degrees)
	def getX(self):
		return self.x
	def setX(self,val):
		self.x = val
	def getY(self):
		return self.y
	def setY(self,val):
		self.y = val
	def getZ(self):
		return self.z
	def setZ(self,val):
		self.z = val
	def getW(self):
		return self.w
	def setW(self,val):
		self.w = val
	def conjugate(self):
		return Vector4(-self.x,-self.y,-self.z,self.w)
	def mulQuat(self,vector):
		w = self.getW()
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		wm = w * vector.getW() - x * vector.getX() - y * vector.getY() - z * vector.getZ()
		xm = x * vector.getW() + w * vector.getX() + y * vector.getZ() - z * vector.getY()
		ym = y * vector.getW() + w * vector.getY() + z * vector.getX() - x * vector.getZ()
		zm = z * vector.getW() + w * vector.getZ() + x * vector.getY() - y * vector.getX()
		return Vector4(xm,ym,zm,wm)
	def mulVec(self,vector):
		w = self.getW()
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		wm = -x  * vector.getX() - y * vector.getY() - z * vector.getZ()
		xm = w * vector.getX() + y * vector.getZ() - z * vector.getY()
		ym = w * vector.getY() + z * vector.getX() - x * vector.getZ()
		zm = w * vector.getZ() + x * vector.getY() - y * vector.getX()
		return Vector4(xm,ym,zm,wm)
		
	def length(self):
		return sqrt(self.x**2 + self.y**2 + self.z**2+self.w**2)
	def normalize(self):
		length = self.length()
		w = self.w / length
		x = self.x / length
		y = self.y / length
		z = self.z / length
		return (self.x,self.y,self.z,self.w)

class Quaternion(object):
	def __init__(self,x=0.0,y=0.0,z=0.0):#,degrees=0.0):
		self.w = float(w)
		self.x = float(x)
		self.y = float(y)
		self.z = float(z)
		#self.deg = float(degrees)
	def getW(self):
		return self.w
	def setW(self,val):
		self.w = val
	def getX(self):
		return self.x
	def setX(self,val):
		self.x = val
	def getY(self):
		return self.y
	def setY(self,val):
		self.y = val
	def getZ(self):
		return self.z
	def setZ(self,val):
		self.z = val

	def mulQuat(self,quat):
		w = self.getW()
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		wm = w * quat.getW() - x * quat.getX() - y * quat.getY() - z * quat.getZ()
		xm = x * quat.getW() + w * quat.getX() + y * quat.getZ() - z * quat.getY()
		ym = y * quat.getW() + w * quat.getY() + z * quat.getX() - x * quat.getZ()
		zm = z * quat.getW() + w * quat.getZ() + x * quat.getY() - y * quat.getX()
		return Quaternion(xm,ym,zm,wm)
	def mulVec(self,quat):
		w = self.getW()
		x = self.getX()
		y = self.getY()
		z = self.getZ()
		wm = -x  * quat.getX() - y * quat.getY() - z * quat.getZ()
		xm = w * quat.getX() + y * quat.getZ() - z * quat.getY()
		ym = w * quat.getY() + z * quat.getX() - x * quat.getZ()
		zm = w * quat.getZ() + x * quat.getY() - y * quat.getX()
		return Quaternion(wm,xm,ym,zm)
		
	def length(self):
		return sqrt(self.w**2 + self.x**2 + self.y**2 + self.z**2)
	def normalize(self):
		length = self.length()
		w = self.w / length
		x = self.x / length
		y = self.y / length
		z = self.z / length
		return (self.w,self.x,self.y,self.z)
	def conjugate(self):
		return Quaternion(-self.x,-self.y,-self.z,self.w)
	def rotateVector(q,v):
		qw, qx, qy, qz = q[0], q[1], q[2], q[3]
		x, y, z = v[0], v[1], v[2]
		
		ww = qw*qw
		xx = qx*qx
		yy = qy*qy
		zz = qz*qz
		wx = qw*qx
		wy = qw*qy
		wz = qw*qz
		xy = qx*qy
		xz = qx*qz
		yz = qy*qz
		
		return (ww*x + xx*x - yy*x - zz*x + 2*((xy-wz)*y + (xz+wy)*z),
				ww*y - xx*y + yy*y - zz*y + 2*((xy+wz)*x + (yz-wx)*z),
				ww*z - xx*z - yy*z + zz*z + 2*((xz-wy)*x + (yz+wx)*y))

class Mat4(object):
	def __init__(self,matrix=None):
		self.matrix = np.zeros((4,4),np.dtype(float)) # to be removed!
		self.matrix = matrix
	def getMatrix(self):
		return self.matrix
	def getValue(self,x,y):
		return self.matrix[x,y]
	def setValue(self,x,y,value):
		self.matrix[x,y] = value
	def setMatrix(self,matrix):
		self.matrix = matrix
	def initIdentity(self): 
		self.matrix = np.zeros(4,4,dtype=np.float)
		self.matrix[0,0] = 1
		self.matrix[1,1] = 1
		self.matrix[2,2] = 1
		self.matrix[3,3] = 1
		return Mat4(self.matrix)
	def initScreenSpaceTransform(self,halfHeight,halfWidth): 
		self.matrix = np.zeros(4,4,dtype=np.float)
		self.matrix[0,0] = halfWidth
		self.matrix[1,1] = -halfHeight
		self.matrix[1,3] = halfHeight
		self.matrix[0,3] = halfWidth
		self.matrix[2,2] = 1
		self.matrix[3,3] = 1
		return Mat4(self.matrix)
	def initTranslation(self,x,y,z):
		self.matrix = np.zeros(4,4,dtype=np.float)
		self.matrix[0,0] = 1
		self.matrix[0,3] = x
		self.matrix[1,3] = y
		self.matrix[2,3] = z
		self.matrix[1,1] = 1
		self.matrix[2,2] = 1
		self.matrix[3,3] = 1
	def initRotation(self,x,y,z,angle=None):
		if angle == None:
			rx = Mat4()
			ry = Mat4()
			rz = Mat4()
			rz.matrix[0,0] = cos(z)
			rz.matrix[0,1] = -sin(z)
			rz.matrix[1,0] = sin(z)
			rz.matrix[1,1] = cos(z)
			rz.matrix[2,2] = 1
			rz.matrix[3,3] = 1
			
			rx.matrix[0,0] = 1
			rx.matrix[1,1] = cos(x)
			rx.matrix[1,2] = -sin(x)
			rx.matrix[2,1] = sin(x)
			rx.matrix[2,2] = cos(x)
			rx.matrix[3,3] = 1
			
			ry.matrix[0,0] = cos(y)
			ry.matrix[0,2] = -sin(y)
			ry.matrix[1,1] = 1
			ry.matrix[2,0] = sin(y) 
			ry.matrix[2,2] = cos(y)
			ry.matrix[3,3] = 1
			return Mat4(rz.mul(ry.mul(rx)).getMatrix())
		else:
			sinAngle = float(sin(angle))
			cosAngle = float(cos(angle))
			self.matrix = np.zeros(4,4,dtype=np.float)
			self.matrix[0,0] = cosAngle + x**2(1-cosAngle)
			self.matrix[0,1] = x*y*(1-cosAngle)-z*sinAngle
			self.matrix[0,2] = x*z*(1-cosAngle)+y*sinAngle
			self.matrix[0,3] = 0
			
			self.matrix[1,0] = y*x*(1-cosAngle)+z*sinAngle
			self.matrix[1,1] = cosAngle+y**2*(1-cosAngle)
			self.matrix[1,2] = y*z*(1-cosAngle)-x*sinAngle
			self.matrix[1,3] = 0
			self.matrix[2,0] = z*x*(1-cosAngle)-y*sinAngle
			self.matrix[2,1] = z*y*(1-cosAngle)+x*sinAngle
			self.matrix[2,2] = cosAngle+z**2(1-cosAngle)
			self.matrix[2,3] = 0
			self.matrix[3,0] = 0 
			self.matrix[3,3] = 1
		
	def add(self,matrix):
		self.matrix = self.matrix + matrix.matrix
		return self.matrix
	def sub(self,matrix):
		self.matrix = self.matrix - matrix.matrix
		return self.matrix
	def mul(self,matrix):
		self.matrix = self.matrix * matrix.matrix
		return self.matrix
	def div(self,matrix):
		self.matrix = self.matrix / matrix.matrix
		return self.matrix
	def transform (self, mat):
		return Vector4(\
		self.getValue(0,0) * mat.getX() + self.getValue(0,1) * mat.getY() + self.getValue(0,2) * mat.getZ() + self.getValue(0,3) * mat.getW(),\
		self.getValue(1,0) * mat.getX() + self.getValue(1,1) * mat.getY() + self.getValue(1,2) * mat.getZ() + self.getValue(1,3) * mat.getW(),\
		self.getValue(2,0) * mat.getX() + self.getValue(2,1) * mat.getY() + self.getValue(2,2) * mat.getZ() + self.getValue(2,3) * mat.getW(),\
		self.getValue(3,0) * mat.getX() + self.getValue(3,1) * mat.getY() + self.getValue(3,2) * mat.getZ() + self.getValue(3,3) * mat.getW())
	def zero(self):
		self.matrix = np.zeros((4,4)).reshape(4,4)
	def scale(self, f):
		print np.multiply(np.array(self.matrix),3)
		result = np.multiply(np.array(self.matrix),f)
		result[-1][-1] = 1 # Last line is always 0 0 0 1 (for Vector transformation)
		# Correct numpy calculation
		return result
class Vertex(object):
	x = float()
	y = float()
	def __init__(self,x,y):
		"""self.x = float(x)
		self.y = float(y)"""
		self.position = Vector4(x,y,1,1)
		self.x = x # tbr
		self.y = y # to be removed
		self.color = list()
	def getX(self):
		return self.x
	def getY(self):
		return self.y
	def setX(self,val):
		self.x = val
	def setY(self,val):
		self.y = val
	def transform(self,mat):
		return mat.transform(self.position)
	def triangleArea(self,v2,v3):
		x1 = float(v2.getX() - self.position.getX())
		y1 = float(v2.getY() - self.position.getY())
		
		x2 = float(v3.getX() - self.position.getX())
		y2 = float(v3.getY() - self.position.getY())
		return (x1*y2-x2*y1)/2.0
	def perspectiveDivide(self):
		return Vector4(self.position.getX()/self.position.getW(),self.position.getY()/self.position.getW(),self.position.getZ()/self.position.getW(),self.position.getW())
class Camera: # All values in degrees
	def __init__(self,x,y,z,angle):
		self.x = x
		self.y = y
		self.z = z
		self.w = 1.0
		self.radAngle = radians(angle)
		self.degAngle = degrees(self.radAngle)
	def getCoordinates(self):
		if debug:
			print "Camera Coordinates: X:",self.x,"Y:",self.y,"Z:",self.z,"W:",self.w,"Angle in Degrees:",self.degAngle,"Degrees"
			print "Global Debug:", debug
		return [self.x,self.y,self.z,self.w,self.radAngle,self.degAngle]
	def setCoordinates(self,x,y,z,w=1.0):
		self.w = w
		self.x = x
		self.y = y
		self.z = z
		self.degAngle = degAngle
		self.radAngle = radians(self.degAngle)
class World:
	def __init__(self):
		self.sectors= np.empty([0])
		self.cam = Camera(0,0,0,angle=180)
class Sector:
	def __init__(self):
		self.polygons = np.empty([0])
		self.objects = np.empty([0])
class Object:
	def __init__(self):
		self.polygons = np.empty([0])
		self.childObjects = np.empty([0])
		self.matrix = np.empty([0])
		self.matrix.reshape(4,4)
		self.color = (0,0,0)
		self.transparency = (0,0,0)
class Polygon:
	def __init__(self):
		self.vertices = np.empty([0])
		self.texture = Texture()
		self.sector = Sector()
		self.plane = Plane()
class Texture:
	def __init__(self):
		pass
class Plane:
	def __init__(self):
		pass

