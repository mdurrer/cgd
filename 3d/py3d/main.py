#!/usr/bin/python

from OpenGL.GL import *
from OpenGL.GLU import *
from OpenGL.GLUT import *

from Drawable import *
from Actor import *

import time

print "== Controls ===================="
print "Heading: w,a,d,s,q,e"
print "Thrust: i,j,l,k,u,m"
print "================================"

window = 0
screenSize = [640,480]

previousTime = time.time()

frameCounter = 0
frameCounterTimer = time.time()

def display():
	global previousTime,frameCounter,frameCounterTimer,envlist
	
	currentTime = time.time()
	deltaTime = (currentTime-previousTime)
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	glPushMatrix()
	glMultMatrixf(toMatrixQ(inverseQ(actor.drawable.rotation)))
	camera = inverse3(actor.drawable.position)
	camera = add3(camera,scale3(actor.drawable.forward,-3))
	camera = add3(camera,scale3(actor.drawable.up,-0.6))
	glTranslatef(camera[0],camera[1],camera[2])
	glLightfv(GL_LIGHT0, GL_POSITION,[-2.0, 3.0, 3.0, 0.0])
	glCallList(envlist)
	#for flora in scenery:
	#	flora.draw()
	actor.update(deltaTime)
	glPopMatrix()
	glutSwapBuffers()
	previousTime = currentTime
	
	frameCounter += 1
	if currentTime-frameCounterTimer > 1:
		print "FPS:",frameCounter
		frameCounter = 0
		frameCounterTimer = currentTime

def resize(width, height):
	if(height==0): height = 1
	screenSize = [width, height]
	glViewport(0, 0, width, height)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gluPerspective(90.0, float(width)/float(height), 0.1, 1000.0)
	glMatrixMode(GL_MODELVIEW)

def key(*args):
	if args[0] == 's': # rotation
		actor.spin(1.5,actor.drawable.left)
	elif args[0] == 'w':
		actor.spin(-1.5,actor.drawable.left)
	elif args[0] == 'a':
		actor.spin(2.5,actor.drawable.forward)
	elif args[0] == 'd':
		actor.spin(-2.5,actor.drawable.forward)
	elif args[0] == 'e':
		actor.spin(1.5,actor.drawable.up)
	elif args[0] == 'q': 
		actor.spin(-1.5,actor.drawable.up)
	elif args[0] == 'k': # movement
		actor.push(scale3(actor.drawable.forward,10.0))
	elif args[0] == 'i':
		actor.push(scale3(actor.drawable.forward,-10.0))
	elif args[0] == 'l':
		actor.push(scale3(actor.drawable.left,3.0))
	elif args[0] == 'j':
		actor.push(scale3(actor.drawable.left,-3.0))
	elif args[0] == 'u':
		actor.push(scale3(actor.drawable.up,3.0))
	elif args[0] == 'm':
		actor.push(scale3(actor.drawable.up,-3.0))
	elif args[0] == '\033': #escape
		glutDestroyWindow(window)
		sys.exit()

glutInit('')
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH)
glutInitWindowSize(640,480)
window = glutCreateWindow('PolarisGP')
resize(640,480)
glutDisplayFunc(display)
glutIdleFunc(display)
glutReshapeFunc(resize)
glutIgnoreKeyRepeat(1)
glutKeyboardFunc(key)

glClearColor(1,1,1,1)
glClearDepth(1)

glEnable(GL_LIGHTING)
glEnable(GL_LIGHT0)
glLightfv(GL_LIGHT0, GL_AMBIENT,[0.2, 0.1, 0.1, 1.0])
glLightfv(GL_LIGHT0, GL_DIFFUSE,[1.0, 1.0, 1.0, 1.0])
glLightModelfv(GL_LIGHT_MODEL_AMBIENT,[0.2, 0.2, 0.2, 1.0])

glEnable(GL_DEPTH_TEST)
glDepthFunc(GL_LESS)

glShadeModel(GL_FLAT)

glCullFace(GL_BACK);
glEnable(GL_CULL_FACE);

actor = Actor()

b = -6
r = 12

scenery = []
for x in range(b,b+r):
	for y in range(b,b+r):
		for z in range(b,b+r):
			flora = Drawable()
			flora.position = (x*20,y*20,z*20)
			scenery.append(flora)

envlist = glGenLists(1)
glNewList(envlist,GL_COMPILE)
for flora in scenery:
		flora.draw()
glEndList()

glutMainLoop()
