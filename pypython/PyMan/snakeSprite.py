#! /usr/bin/env python
import pygame
import basicSprite
from helpers import *

SUPER_STATE_START = pygame.USEREVENT + 1
SUPER_STATE_OVER = SUPER_STATE_START + 1
SNAKE_EATEN = SUPER_STATE_OVER + 1

class Snake(basicSprite.Sprite):
    """This is our snake that will move around the screen"""
    
    def __init__(self, centerPoint, image):
        
        basicSprite.Sprite.__init__(self, centerPoint, image)
        """Initialize the number of pellets eaten"""
        self.pellets = 0
        
        """Set the number of Pixels to move each time"""
        self.x_dist = 4
        self.y_dist = 4 
        """Initialize how much we are moving"""
        self.xMove = 0
        self.yMove = 0
        """By default we are not in the "super" state"""
        self.superState = False
        
    def MoveKeyDown(self, key):
        """This function sets the xMove or yMove variables that will
        then move the snake when update() function is called.  The
        xMove and yMove values will be returned to normal when this 
        keys MoveKeyUp function is called."""
        
        if (key == K_RIGHT):
            self.xMove += self.x_dist
        elif (key == K_LEFT):
            self.xMove += -self.x_dist
        elif (key == K_UP):
            self.yMove += -self.y_dist
        elif (key == K_DOWN):
            self.yMove += self.y_dist
        
    def MoveKeyUp(self, key):
        """This function resets the xMove or yMove variables that will
        then move the snake when update() function is called.  The
        xMove and yMove values will be returned to normal when this 
        keys MoveKeyUp function is called."""
        
        if (key == K_RIGHT):
            self.xMove += -self.x_dist
        elif (key == K_LEFT):
            self.xMove += self.x_dist
        elif (key == K_UP):
            self.yMove += self.y_dist
        elif (key == K_DOWN):
            self.yMove += -self.y_dist
            
    def update(self,block_group,pellet_group,super_pellet_group,monster_group):
        """Called when the Snake sprit should update itself"""
        
        if (self.xMove==0)and(self.yMove==0):
            """If we arn'te moveing just get out of here"""
            return
        """All right we must be moving!"""
        self.rect.move_ip(self.xMove,self.yMove)
        
        if pygame.sprite.spritecollideany(self, block_group):
            """IF we hit a block, don't move - reverse the movement"""
            self.rect.move_ip(-self.xMove,-self.yMove)
        
        """Check to see if we hit a Monster!"""
        lst_monsters =pygame.sprite.spritecollide(self, monster_group, False)
        if (len(lst_monsters)>0):
            """Allright we have hit a Monster!"""
            self.MonsterCollide(lst_monsters)
        else:
            """Alright we did move, so check collisions"""
            """Check for a snake collision/pellet collision"""
            lstCols = pygame.sprite.spritecollide(self
                                                 , pellet_group
                                                 , True)
            if (len(lstCols)>0):
                """Update the amount of pellets eaten"""
                self.pellets += len(lstCols)
                """if we didn't hit a pellet, maybe we hit a SUper Pellet?"""
            elif (len(pygame.sprite.spritecollide(self, super_pellet_group, True))>0):
                """We have collided with a super pellet! Time to become Super!"""
                self.superState = True
                pygame.event.post(pygame.event.Event(SUPER_STATE_START,{}))
                """Start a timer to figure out when the super state ends"""
                pygame.time.set_timer(SUPER_STATE_OVER,0)
                pygame.time.set_timer(SUPER_STATE_OVER,3000)
                
    def MonsterCollide(self, lstMonsters):
        """This Function is called when the snake collides with the a Monster
        lstMonstes is a list of Monster sprites that it has hit."""
        
        if (len(lstMonsters)<=0):
            """If the list is empty, just get out of here"""
            return
    
        """Loop through the monsters and see what should happen"""
        for monster in lstMonsters:
            if (monster.scared):
                monster.Eaten()
            else:
                """Looks like we're dead"""
                pygame.event.post(pygame.event.Event(SNAKE_EATEN,{}))
                
        
        