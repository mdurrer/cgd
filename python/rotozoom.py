import os,sys,pygame
import numpy as np
from pygame.locals import *
pygame.init()
surface = pygame.display.set_mode((640,480),0)
flameguy = pygame.image.load(os.path.join('flameguy.png'))
surface.blit(flameguy,(0,0))
startRotozoom = False
angle = np.arange(360,dtype=float)
rangle = list(reversed(np.arange(360,dtype=float)))
print angle
print rangle
angles = angle + rangle
currentPos = 1.0
while 1:
	for event in pygame.event.get():
		if event.type == QUIT:
			pygame.quit()
			sys.exit()
		elif event.type ==KEYDOWN:
			if event.key == K_ESCAPE:
				pygame.quit()
				sys.exit()
			if event.key == K_SPACE:
				if startRotozoom:
					startRotozoom = False
				if not startRotozoom:
					startRotozoom = True
	currentPos = currentPos + 2
	newguy = pygame.transform.rotozoom(flameguy,currentPos,1.0)
	if currentPos == 360.0:
		currentPos = 1.0
	surface.blit(newguy,(0,0))
	pygame.display.flip()
	
