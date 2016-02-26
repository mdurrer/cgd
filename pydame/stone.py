#!/usr/bin/env python
import os,sys,pygame
from pygame.locals import *
class Stone(pygame.sprite.Sprite):
	StoneGroup = None
	def __init__(self,color=None,state=None,player=None):
		'''
		color = 0,1 (beige/wood, red)
		state = 0,1 (man, king)
		player = 0,1
		'''
		if not Stone.StoneGroup:
			print "No Stone Group found - Creating one."
			Stone.StoneGroup = pygame.sprite.Group()

		if not Stone.StoneGroup == None:
			if color == None or state == None or player == None:
				pygame.sprite.Sprite.__init__(self)
				print "Stone Added"
			if color >= 0 and color <= 1 and state >= 0 and state <= 1:
				pygame.sprite.Sprite.__init__(self)
				self.State = state
				self.Color = color
				self.Player = player

				if self.Color == 0:
					col = "beige"
				elif self.Color == 1:
					col = "red"
				if self.State == 0:
					st = "man"
				elif self.State == 1:
					st = "king"

				self.image = pygame.image.load("images/"+col+"_"+st+"_stone.png")
				self.image = pygame.transform.scale(self.image,(70,70))
				self.rect = self.image.get_rect()
				Stone.StoneGroup.add(self)
