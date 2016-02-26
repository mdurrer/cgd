from OpenGL.GL import *
from Model import *

class Drawable:
	position = (0,0,-3)
	rotation = zeroQ()
	matrix = (1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)
	forward = (0,0,1)
	up = (0,1,0)
	left = (1,0,0)
	color = (0.5,0.4,1,1)
	model = None
	changed = True
	
	def __init__(self):
		self.model = Model("LMP1.obj")
	
	def move(self,v):
		self.position = add3(self.position,v)
	
	def rotate(self,q):
		self.rotation = multiplyQ(self.rotation,q)
		self.changed = True
	
	def draw(self):
		glPushMatrix()
		glTranslatef(self.position[0],self.position[1],self.position[2])
		if self.changed:
			self.matrix = toMatrixQ(self.rotation)
			self.left = (self.matrix[0],self.matrix[1],self.matrix[2])
			self.up = (self.matrix[4],self.matrix[5],self.matrix[6])
			self.forward = (self.matrix[8],self.matrix[9],self.matrix[10])
			self.changed = False
		glMultMatrixf(self.matrix)
		glMaterialfv(GL_FRONT, GL_AMBIENT,[0.2,0.2,0.2,0])
		glMaterialfv(GL_FRONT, GL_DIFFUSE,self.color)
		glMaterialfv(GL_FRONT, GL_SPECULAR,[0.7,0.7,0.7,0])
		glMaterialf(GL_FRONT, GL_SHININESS, 20)
		self.model.draw()
		glPopMatrix()
