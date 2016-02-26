#!/usr/bin/env python
import numpy as np
from math import *
import os,sys
import pygame
#from enum import Enum
from pygame.locals import *
from graphics import *
from display import *
if __name__ == "__main__":
	debug = True
	if debug:
		print "Creating World..."
	world = World()
	mainCam = world.cam
	mainCam.getCoordinates()
	if debug:
		print "Starting Display..."
	display = Display()
	pygame.display.set_caption("3D Engine Example")
	display.surface.fill((0,0,0))
	a2 = Vector2(1.0,3.0)
	print a2.div(Vector2(2.3,3.0)).x
	a=Vector3(1.0,2.0,3.0)
	b=Vector3(3.0,2.0,1.0)
	c=a.normalize()
	d = Vector4(3.4,2.3,20.4,1.0)
	#e = Mat4x4(1,4,5,6,4,7,6,5,4,45,5,5)
	

	print "Vector3 d (Davor)",d
	print d.x,d.y,d.z,d.w
	#xy = d.vectorToQuat(Vector4(3.4,2.3,20.4),1)
	#print "Quaternion d (Danach)",xy
	#print xy.w,xy.x,xy.y,xy.z
	#h=d.rotateXYZ(30,0,0)			
	#print h.x,h.y,h.z,h.w
	minY = Vertex(100,100)
	midY = Vertex(150,150)
	maxY = Vertex(50,300)
	#projection = 
	bla = False
	while True:
		for event in pygame.event.get():
			if event.type == QUIT:
				pygame.quit()
				sys.exit()
			if event.type == KEYDOWN:
				if event.key == pygame.K_ESCAPE:
					pygame.quit()
					sys.exit()
		display.surface.fill((0,0,0))
		area = minY.triangleArea(maxY,midY)
		handedness = 1 if area >= 0 else 0

		display.scanConvertTriangle(minY,midY,maxY,handedness)
		display.fillShape(100,300)
		pygame.display.flip()
f
