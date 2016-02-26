#!/usr/bin/env python2.7
from math import *
import os,sys,pygame
from pygame import locals

class Sprite:
	def __init__(self,image=None):
		if image==None:
			self.image = image
		else:
			self.image = pygame.image.load(image)
		self.x = 0
		self.y = 0
	def getX(self):
		return self.x
	def getY(self):
		return self.y
	def setX(self,value):
		self.x = value
	def setY(self,value):
		self.y = value
	def walkToActor(self,actor):
		pass
	def walk(self,posm,delay):
		# Wayfinder
		self.x = pos[0]
		self.y = pos[1]
		
