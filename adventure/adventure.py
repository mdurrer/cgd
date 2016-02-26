#!/usr/bin/env python2.7
from math import *
import os,sys,pygame
from display import *
from sprite import *
from pygame import locals
import sqlite3 as sql
name = "FakeIndy"
class Adventure:
	name = str()
	version = float()
	mouseX = float()
	mouseY = float()
	mouse = Sprite('data/stern.png')
	def __init__(self,name="Default",version=0.1):
		self.name = name
		self.version = version
		print "Initializing ",self.name,"instance",version
		print "Initializing Pygame Display"
		pygame.display.init()
		self.display = Display((1280,720))
		self.mouseX = float()
		self.mouseY = float()
		self.mouse = Sprite('data/stern.png')
		self.mouse.image = self.mouse.image.convert_alpha()
	def updateMouse(self):
		self.mouseX = pygame.mouse.get_pos()[0]
		self.mouseY = pygame.mouse.get_pos()[1]
	def init(self):
		pass
	def getName(self):
		return name
	def setName(self,name):
		self.name = name
	def getVersion(self):
		return self.version
	def setVersion(self,version):
		self.version = version
class Chapter:
	name = str()
	scenes = list()
	currentScene = str()
	def __init__(self,sceneName=None):
		if sceneName != None:
			self.currentScene=sceneName
		else:
			self.sceneName = None
	def loadScene(self,image):
		pygame.image.load(image)
class Scene:
	name = str()
	rooms = list()
	charachters = list()
	firstRoom = str()
	def __init__(self,room=None):
		self.currentRoom = rooms.append(room)
	def loadFirstRoom(self,room=None):
		if self.firstRoom == None:
			self.firstRoom = room
	def loadDatabase(self,scene):
		pass
class Character:
	name = str()
	position = list()
	curChapter = str()
	curRoom = int()
	state = int ()
	def __init__(self,name="Default",image=None):
		if image==None:
			self.name = name
	def loadDatabase(self,name):
		con = sql.connect('data/sample.sqlite3')
		cursor = con.cursor()
		cursor.execute('SELECT name,position,state,room FROM character WHERE name="Hero"')
		con.commit()
		fields = cursor.fetchone()
		self.name = fields[0]
		self.position = fields[1]
		self.state = fields[2]
		self.curRoom = fields[3]
		print self.name,self.position,self.state,self.curRoom
	def isOnChapter(self):
		return self.curChapter()
	def isOnWalkmap(self):
		pass
