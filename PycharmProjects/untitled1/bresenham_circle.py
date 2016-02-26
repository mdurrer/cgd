import os,sys
import pygame
from pygame.locals import *
width, height = 800,600
def drawCircle(surface,xpos,ypos,radius,color):
    x = int(radius)
    y = 0
    decisionOver2 = 1-x
    while y <= x:
        surface.set_at((x + xpos,y + ypos),color)
        surface.set_at((y + xpos,x + ypos),color)
        surface.set_at((-x + xpos,y + ypos),color)
        surface.set_at((-y + xpos,x + ypos),color)
        surface.set_at((-x + xpos, -y + ypos),color)
        surface.set_at((-y + xpos, -x + ypos),color)
        surface.set_at((x + xpos, -y + ypos),color)
        surface.set_at((y + xpos, -x + ypos),color)
        y += 1
        if decisionOver2<=0:
            decisionOver2 += 2*y + 1
        else:
            x -= 1
            decisionOver2 += 2*(y-x) + 1
if __name__ == "__main__":
    pygame.init()
    screen = pygame.display.set_mode((width,height),DOUBLEBUF,0)
    white = (255,255,255)
    while True:
        for event in pygame.event.get():
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    pygame.quit()
                    sys.exit("Yay, Escape!")
                elif event.key == K_f:
                    pygame.display.toggle_fullscreen()
                elif event.key != K_ESCAPE:
                    print("No Escape key pressed")
            if event.type == QUIT:
                pygame.quit()
                sys.exit("QUIT event")
        screen.fill(white)
        for i in range(500):
            screen.set_at((i,i),(255,0,0))
            screen.set_at((200,10+i),(0,0,0))
        drawCircle(screen,220,200,50,(0,0,255))

        pygame.display.flip()
