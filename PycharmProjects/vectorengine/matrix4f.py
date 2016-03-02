from math import *
import numpy as np
class Matrix4f(object):
	matrix = np.matrix([],dtype=float)
	def __init__(self, m00=0.0,m01=0.0,m02=0.0,m03=0.0,m10=0.0,m11=0.0,m12=0.0,m13=0.0,m20=0.0,m21=0.0,m22=0.0,m23=0.0,m30=0.0,m31=0.0,m32=0.0,m33=0.0):
		self.matrix = np.array([m00,m01,m02,m03,\
		                         m10,m11,m12,m13,\
		                         m20,m21,m22,m23,\
		                         m30,m31,m32,m33],dtype=float).reshape(4,4)
	def initIdentity(self,m00=1.0,m01=0.0,m02=0.0,m03=0.0,m10=0.0,m11=1.0,m12=0.0,m13=0.0,m20=0.0,m21=0.0,m22=1.0,m23=0.0,m30=0.0,m31=0.0,m32=0.0,m33=1.0):
		self.matrix = np.array([m00, m01, m02, m03,\
		                         m10, m11, m12, m13,\
		                         m20, m21, m22, m23,\
		                         m30, m31, m32, m33], dtype=float).reshape(4, 4)
		return self
	def initScreenSpaceTransform(self,halfWidth,halfHeight):
		self.matrix = np.array([1.0, 0.0, 0.0, halfWidth - 0.5,\
		                         0.0, 1.0, 0.0, halfHeight - 0.5,\
		                         0.0, 0.0, 1.0, 0.0,\
		                         0.0, 0.0, 0.0, 1.0], dtype=float).reshape(4, 4)
		return self
	def initTranslation(self,x,y,z):
		self.matrix = np.array([1.0,0.0,0.0,x,\
		                         0.0,1.0,0.0,y,\
		                         0.0,0.0,1.0,z,\
		                         0.0,0.0,0.0,1],dtype=float).reshape(4,4)
		return self
	def initRotation(self,*args):
		sinAngle = sin(angle)
		cosAngle = cos(angle)
		if len(args) < 4:
			self.matrix = np.array([cosAngle+args[0]*args[0]*(1-cosAngle),args[0]*args[1]*(1-cosAngle)-args[2]*sinAngle,args[0]*args[2]*(1-cosAngle)+args[1]*sinAngle, 0.0,\
			                        args[1] * args[0] * (1 - cosAngle)+args[2]*sinAngle,cosAngle+args[1] * args[1] * (1 - cosAngle),args[1] * args[2] * (1 - cosAngle) - args[0]*sinAngle , 0.0,\
			                         args[2]*args[0]*(1-cosAngle)-args[1]*sinAngle,args[2]*args[1]*(1-cosAngle)+x*sinAngle,cosAngle+args[2]*args[2]*(1-cosAngle),0.0,\
			                         0.0,0.0,0.0,1.0],dtype=float).reshape(4,4)
			return self
		else:
			rx = Matrix4f()
			ry = Matrix4f()
			rz = matrix4f()
			rz = np.array(cos(args[2]),-sin(args[2]),0.0,0.0,\
                         sin(args[2]),cos(args[2]),0.0,0.0,\
                         0.0,0.0,1.0,0.0,\
                         0.0,0.0,0.0,1.0,dtype=float).reshape(4,4)
			rx = np.array(1.0,0.0,0.0,0.0,\
                         0.0,cos(args[0]),-sin(args[0]),0.0,\
                         0.0,sin(args[0]),cos(args[0]),0.0,\
                         0.0,0.0,0.0,1.0,dtype=float).reshape(4,4)
			ry = np.array(cos(args[1]), 0.0, -sin(args[1]), 0.0, \
			              0.0, 1.0, 0.0, 0.0, \
			              sin(args[1]), 0.0, cos(args[1]), 0.0, \
			              0.0, 0.0, 0.0, 1.0, dtype = float).reshape(4, 4)
			m = rz.mul(ry.mul(rx)).getMatrix()
			return self
	def getMatrix(self):
		return self.matrix
	def setMatrix(self,matrix):
		self.matrix = matrix
	def getMatrixElement(self,x,y):
		return self.matrix[x][y]
	def setMatrixElement(self,x,y,value):
		self.matrix[x][y] = value
	def mul(self, matrix):
		res = Matrix4f()
		for x in range (0,4):
			for y in range(0,4):
				res.setMatrixElement(x,y,self.matrix[x][0] * res.getMatrixElement(0,y) + \
				                     self.matrix[x][1] * res.getMatrixElement(1, y) + \
				                     self.matrix[x][2] * res.getMatrixElement(2, y) + \
				                     self.matrix[x][3] * res.getMatrixElement(3, y))

