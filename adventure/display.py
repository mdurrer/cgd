#!/usr/bin/env python2.7
from math import *
import os,sys,pygame
from pygame import locals

class Display:
	def __init__(self,display):
		pygame.init()
		self.surface = self.setMode((display[0],display[1]))
		
	def setMode(self,display,flags=pygame.DOUBLEBUF|pygame.HWSURFACE,depth=0):
		return pygame.display.set_mode(display,flags,depth)
