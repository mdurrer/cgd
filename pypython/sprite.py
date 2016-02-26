import os,sys,pygame
class Sprite(pygame.sprite.Sprite):

	def __init__(self):
		self.width = 0
		self.height = 0
		self.x = 0
		self.y = 0
		self.surface = None
		