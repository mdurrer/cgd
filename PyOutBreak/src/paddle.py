#!/usr/bin/env    python
import os,sys,pygame
from pygame.locals import *
class Paddle(pygame.sprite.Sprite):
    PaddleGroup = None
    def __init__(self, filename=None):
        self.Image = None
        self.NewX = None
        self.NewY = None
        self.VelX = None
        self.VelY = None
        self.SpriteNumber = None
        self.Direction = 0
        if self.PaddleGroup == None:
            print "Paddle Group doesn't exist yet, creating one."
            Paddle.PaddleGroup = pygame.sprite.Group()
            print "Creating a PaddleGroup instance"
        if not filename == None:
            self.addPaddle(filename)
        else:
            pygame.sprite.Sprite.__init__(self)
            Paddle.PaddleGroup.add(self)
        

    def addPaddle(self,filename = None, xcoord=0, ycoord=0):
        if not self.PaddleGroup == None: 
            pygame.sprite.Sprite.__init__(self)
            if not filename == None:
                self.image = pygame.image.load(filename).convert()
                print "Rectangle data: " + str(self.image.get_rect())
                self.rect = self.image.get_rect()
                self.rect.x = xcoord
                self.rect.y = ycoord
                self.horzW = self.image.get_width()
                self.horzH = self.image.get_height()
                self.Image = self.image
                self.SpriteNumber = len(Paddle.PaddleGroup.sprites()) + 1
                print "Adding a Paddle with the Sprite Number " + str(self.SpriteNumber) + " to the PaddleGroup"
                Paddle.PaddleGroup.add(self)
    def setXY(self,xcoord,ycoord):
        self.NewX,self.NewY = xcoord,ycoord
    def getXY(self):
        return self.NewX, self.NewY
    def setDirection(self, dir):
        if not dir in ("DOWN", "LEFT", "UP","RIGHT",0,1,2,3):
            print "Wrong Direction given!"  
        else:
            if dir=="DOWN" or dir==0:
                self.Direction = 0
            if dir=="RIGHT" or dir==1:
                self.Direction = 1
            if dir=="UP" or dir==2:
                self.Direction = 2
            if dir=="LEFT" or dir==3:
                self.Direction = 3
                
            
         
                
