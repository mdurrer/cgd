import sys,os
import pygame
from pygame import *
from OpenGL.GL import *
from OpenGL.GLU import *
def reshape((width,height)):
    glViewport(0,0,width,height)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(60,1.0*width/height,0.1,1000.0)
    glMatrixMode(GL_MODELVIEW)

def draw():
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()
    gluLookAt(0, 0, 10, 0, 0, -100, 0, 1 ,0)
    glBegin(GL_QUADS)
    glColor(0, 0, 1.0)
    glVertex2f(-2, 2)  # oben links
    glVertex2f(2, 2)   # oben rechts
    glVertex2f(2, -1)  # unten rechts
    glVertex2f(-2, -1) # unten links
    glEnd()
    pygame.display.flip()
def main():
    screen =(800,600)
    pygame.init()
    maxfps = 100
    clock = pygame.time.Clock()
    surface = pygame.display.set_mode(screen,pygame.OPENGL|pygame.DOUBLEBUF,16)
    pygame.display.set_caption("Y'all need some OpenGL!")
    reshape(screen)
    glClearColor(1.0, 1.0, 1.0, 1.0)
    while True:
        clock.tick(maxfps)
        draw()
        for event in pygame.event.get():
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    sys.exit()
            elif event.type == QUIT:
                sys.exit()

if __name__ == "__main__":
    main()
