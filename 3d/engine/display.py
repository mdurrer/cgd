#!/usr/bin/env python
# -*- coding: utf-8 -*-
from math import *
import numpy as np
import pygame,pygame.gfxdraw
class Display:
	def __init__(self,x=800,y=600,bpp=0,flags=pygame.DOUBLEBUF	):
		if not pygame.display.get_init():
			pygame.init()
			self.surface = pygame.display.set_mode((x,y),flags,bpp)
		self.height = int(y)
		self.width = int(x)
		self.scanBuffer = np.zeros(self.height*2,dtype=int)
	def getWidth(self):
		return self.width
	def setWidth(self,val):
		self.width = val
	def getHeight(self):
		return self.height
	def setHeight(self,val):
		self.height = val
	def drawScanBuffer(self,yCoord,xMin,xMax):
		self.scanBuffer[yCoord * 2] = xMin
		self.scanBuffer[yCoord * 2 + 1] = xMax
	def scanConvertTriangle(self,minYVert,midYVert,maxYVert, handedness):
		self.scanConvertLine(minYVert,maxYVert,0+handedness)
		self.scanConvertLine(minYVert,midYVert,1-handedness)
		self.scanConvertLine(midYVert,maxYVert,1-handedness)

	def scanConvertLine(self,minYVert,maxYVert, handedness):
		yStart = minYVert.getY()
		yEnd = maxYVert.getY()
		xStart = minYVert.getX()
		xEnd = maxYVert.getX()
		yDist = yEnd - yStart
		xDist = xEnd -  xStart
		
		if yDist <= 0:
			return
		xStep = float(xDist)/float(yDist)
		curX = float(xStart)
		for i in range(yStart,yEnd):
			self.scanBuffer[i * 2 + handedness] = curX
			curX = curX + xStep
		
	def fillShape(self,yMin,yMax):
		for y in range(yMin,yMax):
			xMin = self.scanBuffer[y*2]
			xMax = self.scanBuffer[y*2+1]
			for x in range (xMin,xMax):
				self.drawPixel((x,y),(255,255,255))
	def fillTriangle(self,v1,v2,b3):
		screenSpaceTransform = Mat4(InitScreenTransform(screenSpaceIdentity(getWidth()/2,GetHeight()/2)))
		minYvertex = v1.PerspectiveDivide().transform(screenSpaceTransform);
		midYvertex = v2.PerspectiveDivide().transform(screenSpaceTransform);
		maxYvertex = v3.PerspectiveDivide().transform(screenSpaceTransform);
	
		
	def drawPixel(self,coord,col=(255,255,255)):
		pygame.gfxdraw.pixel(self.surface,coord[0],coord[1],(col[0],col[1],col[2]))
