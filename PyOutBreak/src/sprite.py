#!/usr/bin/env    python
import os,sys,pygame
from pygame.locals import * 

class Sprite(object):
    def __init__(self):
        print "Created Sprite."
        print "Initializing Coordinates:"
        self.X = None
        self.Y = None
        self.SpeedX = None
        self.SpeedY = None
        self.Surface = None
        print "X = " + str(self.X)
        print "Y = " + str(self.Y)
        print "SpeedX = " + str(self.SpeedX)
        print "SpeedY = " + str(self.SpeedY)
        print "Surface = " + str(self.Surface)
        
        
        