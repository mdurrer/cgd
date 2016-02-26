from math import *
import numpy as np
import pygame
class Display:
	def __init__(self,x=800,y=600,bpp=0,flags=pygame.DOUBLEBUF	):
		if not pygame.display.get_init():
			pygame.init()
			self.surface = pygame.display.set_mode((x,y),flags,bpp)	
class Vector3:
	def __init__(self,x=0.0,y=0.0,z=0.0):
		self.x = float(x)
		self.y = float(y)
		self.z = float(z)
		self.length = float(0.0)
	def calcLength(self):
		length = sqrt(self.x**2 + self.y**2 + self.z**2)
		return length
	@staticmethod
	def dot(va,vb):
		dotProduct = (va.x * vb.x)+(va.y * vb.y)+(va.z * vb.z)
		return dotProduct
	@staticmethod
	def getAngle(va,vb):
		dotProduct = Vector3.dot(va,vb)
		print "Skalarprodukt",dotProduct
		lva = va.calcLength()
		lvb = vb.calcLength()
		print "Betraege va u. vb",lva,lvb
		cosf = (dotProduct/(lva*lvb))
		print "COS F",cosf
		print degrees(acos(cosf))
		return acos(dotProduct/(lva*lvb))
	def normalize(self):
		self.calcLength()
		if self.length!=0:
			self.x = self.x/self.length
			self.y = self.y/self.length
			self.z = self.z/self.length
	def getCoordinates(self):
		return [self.x,self.y,self.z]
	def setCoordinates(self,x,y,z):
		self.x = x
		self.y = y
		self.z = z
		return [self.x,self.y,self.z]
		
class World:
	def __init__(self):
		self.sectors= np.empty([0])
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

