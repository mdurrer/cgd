import os,sys
import pygame
from pygame.locals import *
from maths import *
from vectors import *
from matrix4f import *
from quaternion import *

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
    a = Vector2f(3.8,3)
    b = Vector2f(3.5,4)
    c = a+b
    d = a-b
    e = a*b
    f = a/b
    print("C => X: %i Y: %i" %(c.x,c.y))
    print("D => X: %i Y: %i" %(d.x,d.y))
    print("E => X: %i Y: %i" %(e.x,e.y))
    print("F => X: %f Y: %f" %(f.x,f.y))
    ab = Vector3f(3,6,4)
    cd = Vector3f(5,2,3)
    ef = Vector4f(2,3,4,1)
    fn = ef.normalize()
    mat = Matrix4f(2,3,4)
    print(mat.matrix)
    mat.initIdentity()
    print("Matrix: ",mat.matrix)

    print("Matrix selection",mat.matrix[0][0])
    print(ef)
    print("Normalized ef=fn %s" % fn)

    print ("Dot product %f" % ab.dot(cd))
    ini = mat.initScreenSpaceTransform(width/2,height/2)
    print(ini)
    q = Quaternion(1,1,1,1)
    print (q)
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
        screen.fill((0,0,0))
        pygame.display.flip()
