from math3D import *
from Drawable import *

class Actor:
	drawable = None
	velocity = (0,0,0)
	rvAxis = (1,0,0)
	rvMagnitude = 0
	friction = 3
	rFriction = 3
	
	def __init__(self):
		self.drawable = Drawable()
	
	def push(self,v):
		self.velocity = add3(self.velocity,v)
	
	def spin(self,mag,axis):
		newRV = add3(scale3(self.rvAxis,self.rvMagnitude),scale3(axis,mag))
		self.rvMagnitude = length3(newRV)
		self.rvAxis = normalize3(newRV)
	
	def update(self,t):
		self.drawable.draw()
		self.drawable.move(scale3(self.velocity,t))
		if lengthSq3(self.rvAxis)==0:
			self.rvAxis = (1,0,0)
		rvInstant = fromAngleAxisQ(self.rvMagnitude*t,self.rvAxis[0],self.rvAxis[1],self.rvAxis[2])
		self.drawable.rotate(rvInstant)
		self.velocity = scale3(self.velocity,1.0-t*self.friction)
		self.rvMagnitude = self.rvMagnitude*(1.0-t*self.rFriction)
