import os,sys
import pygame
import random
MAXSTARS = 512
class Star(object):
	plane = None
	x = int()
	y = int()
	def __init__(self):
		pass
pygame.init()
surface = pygame.display.set_mode((640,480))
stars = []
for i in range(MAXSTARS):
	stars.append(i)
	stars[i].x = random.rand # WORK HERE
while True:
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			pygame.quit()
		if event.type == pygame.KEYDOWN:
			if event.key == pygame.K_ESCAPE:
				pygame.quit()
			elif event.key == pygame.K_f:
				pygame.display.toggle_fullscreen()
	pygame.display.flip()
pygame.quit()

	                                                                                                                                                                                                           
