from math import *
from pygame.locals import *
import pygame as pg
import sys
if __name__ == '__main__':
	print("Main Program started")
	pg.init()
	display = pg.display.set_mode((800,600),DOUBLEBUF)
	while True:
		for event in pg.event.get():
			if event.type == QUIT:
				pg.quit()
				sys.exit()
			elif event.type == KEYDOWN:
				if event.key == K_ESCAPE:
					pg.quit()
					sys.exit("Yay, Escape")