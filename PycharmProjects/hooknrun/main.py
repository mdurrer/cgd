import pygame
from pygame.locals import *
import sys

print("Hook'n Run started")
pygame.init()
surface = pygame.display.set_mode((800,600))
while True:
	for event in pygame.event.get():
		if event.type==QUIT:
			pygame.quit()
			sys.exit(1)
		if event.type == KEYDOWN:
			if event.key == K_ESCAPE:
				pygame.quit()
				sys.exit(1)
	pygame.display.flip()