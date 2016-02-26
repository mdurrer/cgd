#!/usr/bin/env python2.7
from math import *
import os,sys,pygame
from pygame import locals
from sprite import *
class Scene(Sprite):
	image = None
	characters = []
	data = None
	background = None
	def __init__(self,scene=None):
		self.dataDir = "data"
		if Scene == None:
			self.scene = scene
			self.backgroundSurface = None
			self.characters = []
			self.walkableSurface = None
			self.coveredSurface = None
			self.dataDir = "data"
		else:
			self.scene = scene
			self.backgroundSurface = None
			self.characters = []
			self.mainCharacter = None
			self.walkableSurface = None
			self.coveredSurface = None
			self.loadBackground("scene1")
			self.loadWalkmap("scene1")



	def loadDatabase(self,name):
		con = sql.connect('data/sample.sqlite3')
		cursor = con.cursor()
		cursor.execute('SELECT * from scene WHERE name =' + name)
		con.commit()
		fields = cursor.fetchone()
	def loadBackground(self,background):
		filename = background + "_bg.png"
		#self.background = pygame.image.load(os.path.join(os.path.sep,self.dataDir,filename))
		self.backgroundSurface = pygame.image.load(self.dataDir + "/" + filename)
	def loadWalkmap(self,walkmap):
		filename = walkmap + "_walk.png"
		self.walkableSurface = pygame.image.load(self.dataDir + "/" + filename)
