from math import *
import numpy as np

class OBJModel(object):
	class OBJIndex(object):
		vertexIndex = int()
		texCoordIndex = int()
		normalIndex = int()
		def __init__(self):
			self.vertexIndex = int()
			self.texCoordIndex = int()
			self.normalIndex = int()
		def getVertexIndex(self):
			return self.vertexIndex
		def getTexCoordIndex(self):
			return self.texCoordIndex
		def getNormalindex(self):
			return self.normalIndex
		def setVertexIndex(self,val):
			self.vertexIndex = val
		def setTexCoordIndex(self,val):
			self.texCoordIndex = val
		def setNormalIndex(self,val):
			self.normalIndex = val
		def equals(self,obj):
			OBJIndex index =  obj
			return self.vertexIndex == index.vertexIndex && self.texCoordIndex == index.texCoordIndex && self.normalIndex ==  index.normalIndex
		def hashCode(self):
			pass