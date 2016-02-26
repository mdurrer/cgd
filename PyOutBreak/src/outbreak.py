#!/usr/bin/env python
'''
----------------------------------
    PyOutBreak - The Breakout-Clone written in Python. Wow.
----------------------------------
    Author: Michael Durrer
    E-Mail: michael (dot) durrer (at) gmail (dot) com
    License: GPL
    Programming Language: Python
    Interpreter used/needed: Python 2.5
    Libraries used/needed: PyGame
----------------------------------
'''
import os,sys,pygame, paddle, ball
from pygame.locals import *

class PyOutBreak(object):
    State = None
    BackendsUsed = {}
    Paddles  = None
    Balls = None
    Framerate = 60
    def __init__(self, name="PyOutBreak", backend="PyGame", inputBE=None, audioBE=None, videoBE=None):
        self.Name = name
        self.Screen = None
        self.Status = None
        self.GameClock = pygame.time.Clock()
        self.Font = None
        print "Created an instance of PyOutBreak with the name " + str(name) + ", using the following backends:"
        if backend == "PyGame":
            inputBE, audioBE, videoBE = backend, backend, backend
            self.BackendsUsed['Backend'] = backend
            self.BackendsUsed['Video'] = backend
            self.BackendsUsed['Audio'] = backend
            self.BackendsUsed['Input'] = backend
        print "For "
        print "    Backend: " + str(backend)
        print "    Input: " + str(inputBE)
        print "    Audio: " + str(audioBE)
        print "    Video: " + str(videoBE)
        
    def __repr__(self, backend=None):
        print "This game is called " + str(self.Name) + " and uses the " + self.BackendsUsed['Backend'] + "-backend for input and output."
    def run(self):
        print "Running " + str(self.Name)
        self.Status = 1
    def stop(self):
        print "Stopping " + str(self.Name)
        self.Status = 0
        self.initInput()
    def initBackend(self):
        pygame.init()
    def initDisplay(self,text,xcoord,ycoord):
        self.Screen = pygame.display.set_mode((xcoord,ycoord),HWSURFACE|DOUBLEBUF)
        self.setCaption(text)
    def initInput(self):
        pygame.mouse.set_visible(0)
    def initEvents(self):
        pygame.event.clear()
        print "Cleared/Initialized Events"
    def initPaddles(self):
        self.Paddles =  paddle.Paddle()
        self.Paddles.addPaddle("images/paddle.png",350,((self.Screen.get_width()/20)*13))
        #self.Paddles.addPaddle("images/paddle.png")
    def handleInput(self):
        for event in pygame.event.get():
            if event.type == KEYDOWN:
                print "Event-Key: " +str(event.key)
                if event.key == K_ESCAPE:
                    print "Escape pressed, exitting application."
                    app.stop()
                    self.Status = -1
                elif event.key == K_f:
                    pygame.display.toggle_fullscreen()
                    print "Toggling Fullscreen." 
                    
            if event.type == QUIT:
                print "Closed by the window manager, exitting application."
                app.stop()
                self.Status = -1

                    
    def handleDisplay(self):
        app.Paddles.PaddleGroup.draw(self.Screen)
        pygame.display.flip()
    def handlePaddles(self):
        MousePositions = pygame.mouse.get_pos()
    
        for CurSpr in self.Paddles.PaddleGroup.sprites():
            if CurSpr.SpriteNumber == 1:

                if MousePositions[0] >= (self.Screen.get_width()-CurSpr.image.get_width()) and CurSpr.Direction == 0 and pygame.mouse.get_pressed()[0] == True:
                    MouseXCoord = (self.Screen.get_width()-CurSpr.image.get_width())
                    MouseYCoord = ((self.Screen.get_width()/20)*13)
                    CurSpr.Image = pygame.transform.rotate(CurSpr.image,90)
                    CurSpr.image = CurSpr.Image
                    CurSpr.setDirection("RIGHT")
                    
                elif MousePositions[1] >= (self.Screen.get_height()-CurSpr.image.get_height()) and CurSpr.Direction == 1 and pygame.mouse.get_pressed()[0] == True:
                    #CurSpr.Image = pygame.transform.rotate(CurSpr.image,270)
                    #CurSpr.image = CurSpr.Image
                    MouseXCoord = (self.Screen.get_width()-CurSpr.image.get_width())
                    MouseYCoord = (self.Screen.get_height()-CurSpr.image.get_height())
                else:
                    if CurSpr.Direction == 0:
                        if MousePositions[0] >= (self.Screen.get_width()-CurSpr.image.get_width()):
                            MouseXCoord = (self.Screen.get_width()-CurSpr.image.get_width())
                        else:
                            MouseXCoord = MousePositions[0]
                        MouseYCoord = ((self.Screen.get_width()/20)*13)
                        CurSpr.rect.x, CurSpr.rect.y = MouseXCoord, MouseYCoord
                    if CurSpr.Direction == 1:
                        MouseXCoord = (self.Screen.get_width()-CurSpr.image.get_width())
                        if MousePositions[1] >= (self.Screen.get_height()-CurSpr.image.get_height()):
                            MouseYCoord = (self.Screen.get_height()-CurSpr.image.get_height())
                        else:
                            MouseYCoord = MousePositions[1]
                        CurSpr.rect.x, CurSpr.rect.y = MouseXCoord, MouseYCoord
                #break
    def clearDisplay(self,color):
        self.Screen.fill(color)
        
    def exitBackend(self):
        pygame.quit()
    def setCaption(self, text):
        pygame.display.set_caption(text)
    def setFPS(self,count):
        app.GameClock.tick(count)
    def setFont(self,fontname=None, size=22):
        self.Font = pygame.font.Font(fontname,size)

                        
        
        
if __name__ == "__main__":
    print "Starte eine Applikation, welche PyOutBreak verwendet."
    app = PyOutBreak("PyOutBreak","PyGame")
    app.initBackend()
    app.initDisplay("PyOutBreak",800,600)
    app.initInput()    
    app.initPaddles()
    app.run()
    app.setFont()
    sprlist = app.Paddles.PaddleGroup.sprites()
    print "Sprite-List: " +str(sprlist)
    
    while app.Status == 1:
        app.handleInput()
        app.displayFPS(20,30,(255,0,0))    
        app.handleDisplay()
        app.handlePaddles()
        app.clearDisplay((0,0,128))
        app.setFPS(PyOutBreak.Framerate)

        
    app.stop()
    sys.exit(1) # Applikation normal beenden.            