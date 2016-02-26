import os
import sys
from pygame.locals import *
import pygame
class Video(object):
	def __init__(self, xres=None,yres=None,bpp=None):
		if (type (xres) == type(1) and type(yres) == type(1) and type(bpp) == type(1)):
			print "Creating Video devic with the video mode " + str(xres) + "x" + str(yres) + "x" +str(bpp)
			self.XRes, self.YRes, self.bpp = xres, yres, bpp
			setVideo(xres,yres,bpp)
		else:
			print "Creating a Video device; please set a video mode!"
	def setVideo(self,xres=None,yres=None,bpp=None):
		if (type(xres) == type(2)):
			if (type(yres) == type(2)):
				if (type(bpp) == type(2)):
					self.MainSurface = pygame.display.set_mode((xres,yres),0)
					self.XRes, self.YRes, self.bpp = xres, yres, bpp
					return self.MainSurface