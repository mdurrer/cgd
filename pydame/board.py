#!/usr/bin/env python
import os,sys,pygame,stone
from pygame.locals import *
class Board(pygame.sprite.Sprite):
	Running = None
	Stones = None
	StoneList = list()
	XPlus = 0
	YPlus = 0
	Initialized = 0
	def __init__(self, filename=None,size=10):
		if not filename == None:
			self.image = pygame.image.load(filename).convert()
			self.BoardSize = size
	def initStones(self, a,b):
		'''
		playerone = 0,1
		playertwo = 0,1
		'''
		if (a and b == 1 and a == 1) or (a and b == 0 and a == 0):
			print "Incorrect parameters"
		else:
			print "Initializing Stones"
			self.Initialized = 0 
			self.XPlus += 20
			StoneCount = 10 **2
			while not StoneCount == 0:
				self.XPlus += 1
				Instance = stone.Stone(0,0,0)
				Instance.x = 15 + self.XPlus
				print Instance.x
				Instance.y = 10
				self.StoneList.append(Instance)
				StoneCount -= 1
			self.StoneList[0].x = 100
			self.StoneList[1].x = 50
			self.StoneList[2].x = 100
			self.StoneList[1].image = self.StoneList[0].image
			for CurStone in self.StoneList:
				stone.Stone.StoneGroup.add(CurStone)
			self.Stones = stone.Stone.StoneGroup