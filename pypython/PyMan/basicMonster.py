#! /usr/bin/env python

import pygame
import basicSprite
import random

class Monster(basicSprite.Sprite):
    """This is our sMonster that will move around the screen"""
    
    def __init__(self, centerPoint, image, scared_image=None):
        
        basicSprite.Sprite.__init__(self, centerPoint, image)
        """Save the original rect"""
        self.original_rect = pygame.Rect(self.rect)
        self.normal_image = image
        if scared_image !=None:
            self.scared_image = scared_image
        else:
            self.scared_image = image
        
        self.scared = False
        """Initialize the direction"""
        self.direction = random.randint(1,4)
        self.dist = 3
        self.moves = random.randint(100,200)
        self.moveCount = 0;
            
    def update(self,block_group):
        """Called when the Monster sprit should update itself"""        
        xMove,yMove = 0,0
        
        if self.direction==1:
            xMove = -self.dist
        elif self.direction==2:
            yMove = -self.dist
        elif self.direction==3:
            xMove = self.dist
        elif self.direction==4:
            yMove = self.dist
        
        self.rect.move_ip(xMove,yMove) #Move the Rect
        self.moveCount += 1 #Update the Move count
        
        if pygame.sprite.spritecollideany(self, block_group):
            """IF we hit a block, don't move - reverse the movement"""
            self.rect.move_ip(-xMove,-yMove)
            self.direction = random.randint(1,4)
        elif self.moves == self.moveCount:
            """If we have moved enough, choose a new direction"""
            self.direction = random.randint(1,4)
            self.moves = random.randint(100,200)
            self.moveCount = 0;
        
    
    def SetScared(self, scared):
        """Tell the monster to be scared or not"""
        """Should we update out scared image?"""
        if self.scared != scared:
            self.scared = scared
            if scared:
                self.image = self.scared_image
            else:
                self.image = self.normal_image
    
    def Eaten(self):
        """Well looks like we've been eaten!, reset to the original
        position and stop being scared"""
        self.rect = self.original_rect
        self.scared = False
        self.image = self.normal_image
            