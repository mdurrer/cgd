import numpy as np
from math import *
import os,sys
import pygame
from enum import Enum
from pygame.locals import *
import graphics

if __name__ == "__main__":
	debug = True
	if debug:
		print "Creating World..."
	world = grahics.World()
	if debug:
		print "Starting Display..."
	display = grahics.Display()
	pygame.display.set_caption("3D Engine Example")
	display.surface.fill((255,255,255))
	a=grahics.Vector3(1.0,2.0,3.0)
	b=grahics.Vector3(3.0,2.0,1.0)
	c=a.normalize()
	print "Winkel von a und b:", grahics.Vector3.getAngle(a,b)
	skalar = grahics.Vector3.dot(a,b)
	print "Skalarprodukt:",skalar

	while True:
		for event in pygame.event.get():
			if event.type == QUIT:
				pygame.quit()
				sys.exit()
			if event.type == KEYDOWN:
				if event.key == pygame.K_ESCAPE:
					pygame.quit()
					sys.exit()
		pygame.display.flip()
