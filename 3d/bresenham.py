import pygame,sys
from pygame.locals import *
import pygame.gfxdraw
import numpy
import math

def DrawLine(surface,sx,sy,ex,ey):
    dx = ex-sx
    dy = ey-sy
    f = 2*dy-dx
    surface.set_at((sx,sy),(255,0,0))
    y = sy
    for x in range(sx+1,ex+1):
        if (f>0):
            y += 1
            surface.set_at((x,y),(255,0,0))
            f += (2*dy-2*dx)
        else:
            surface.set_at((x,y),(255,0,0))
            f += 2*dy
        
        

if __name__ == "__main__":
			
	pygame.init()
	Surface = pygame.display.set_mode((640,480),0,32)
	pygame.display.set_caption("3D Engine Example")
	Surface.fill((255,255,255))
	curAngle = 0
#radius = 50
	circleCenter = (640/2,480/2)
	angleIndex = []
	pointAngle = 2*math.pi/360
	xcoord = 0

	
	while True:
		Surface.fill((255,255,255))
		radius = pygame.mouse.get_pos()[0]
		for point in range(0,360) :
			angleIndex.append(point*pointAngle)		
		for point in angleIndex:
			x=int(math.cos(point)*radius)+ circleCenter[0]
			y=int(math.sin(point)*radius)+ circleCenter[1]
			pygame.gfxdraw.pixel(Surface,x,y,(255,0,0))
			x=int(math.cos(point)*radius)+ circleCenter[0]
			y=int(math.sin(point)*radius)+ circleCenter[1]
			pygame.gfxdraw.pixel(Surface,x,y,(255,0,0))
			
		for event in pygame.event.get():
			if event.type == QUIT:
				pygame.quit()
				sys.exit()
			if event.type == KEYDOWN:
				if event.key == pygame.K_ESCAPE:
					pygame.quit()
					sys.exit()
				if event.key == pygame.K_f:
					pygame.display.toggle_fullscreen()

		pygame.display.flip()

			
