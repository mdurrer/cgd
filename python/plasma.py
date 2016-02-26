import os,sys
import pygame

pygame.init()
screen = pygame.display.set_mode((640,480))
screen.fill((0,0,0))

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
 
