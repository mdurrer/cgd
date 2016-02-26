#! /usr/bin/env python

import os, sys
import pygame
import level001
import basicSprite
from pygame.locals import *
from helpers import *
from snakeSprite import *
from basicMonster import Monster

if not pygame.font: print 'Warning, fonts disabled'
if not pygame.mixer: print 'Warning, sound disabled'

BLOCK_SIZE = 24

class PyManMain:
    """The Main PyMan Class - This class handles the main 
    initialization and creating of the Game."""
    
    def __init__(self, width=640,height=480):
        """Initialize"""
        """Initialize PyGame"""
        pygame.init()
        """Set the window Size"""
        self.width = width
        self.height = height
        """Create the Screen"""
        self.screen = pygame.display.set_mode((self.width
                                               , self.height))
                                                          
    def MainLoop(self):
        """This is the Main Loop of the Game"""
        
        """Load All of our Sprites"""
        self.LoadSprites();
        
        """Create the background"""
        self.background = pygame.Surface(self.screen.get_size())
        self.background = self.background.convert()
        self.background.fill((0,0,0))
        """Draw the blocks onto the background, since they only need to be 
        drawn once"""
        self.block_sprites.draw(self.screen)
        self.block_sprites.draw(self.background)
        #self.pellet_sprites.draw(self.screen)
        #self.pellet_sprites.draw(self.background)
        
        pygame.display.flip()
        while 1:
            
            self.snake_sprites.clear(self.screen,self.background)
            self.monster_sprites.clear(self.screen,self.background)
            
            for event in pygame.event.get():
                if event.type == pygame.QUIT: 
                    sys.exit()
                elif event.type == KEYDOWN:
                    if ((event.key == K_RIGHT)
                    or (event.key == K_LEFT)
                    or (event.key == K_UP)
                    or (event.key == K_DOWN)):
                        self.snake.MoveKeyDown(event.key)
                elif event.type == KEYUP:
                    if ((event.key == K_RIGHT)
                    or (event.key == K_LEFT)
                    or (event.key == K_UP)
                    or (event.key == K_DOWN)):
                        self.snake.MoveKeyUp(event.key)
                elif event.type == SUPER_STATE_OVER:
                    self.snake.superState = False
                    """Stop the timer"""
                    pygame.time.set_timer(SUPER_STATE_OVER,0)
                    for monster in self.monster_sprites.sprites():
                        monster.SetScared(False)
                elif event.type == SUPER_STATE_START:
                    for monster in self.monster_sprites.sprites():
                        monster.SetScared(True)
                elif event.type == SNAKE_EATEN:
                    """The snake is dead!"""
                    """For now kist quit"""
                    sys.exit()
                    
            """Update the snake sprite"""        
            self.snake_sprites.update(self.block_sprites
                                       , self.pellet_sprites
                                       , self.super_pellet_sprites
                                       , self.monster_sprites)
            self.monster_sprites.update(self.block_sprites)
                        
            
                        
            """Do the Drawging"""     
            textpos = 0          
            self.screen.blit(self.background, (0, 0))     
            if pygame.font:
                font = pygame.font.Font(None, 36)
                text = font.render("Pellets %s" % self.snake.pellets
                                    , 1, (255, 0, 0))
                textpos = text.get_rect(centerx=self.background.get_width()/2)
                self.screen.blit(text, textpos)
            
            reclist = [textpos]  
            reclist += self.pellet_sprites.draw(self.screen)
            reclist += self.super_pellet_sprites.draw(self.screen)
            reclist += self.snake_sprites.draw(self.screen)
            reclist +=  self.monster_sprites.draw(self.screen)
            #reclist += (self.block_sprites.draw(self.screen))
            
            pygame.display.update(reclist)
           # pygame.display.flip()
                    
    def LoadSprites(self):
        """Load all of the sprites that we need"""
        """calculate the center point offset"""
        x_offset = (BLOCK_SIZE/2)
        y_offset = (BLOCK_SIZE/2)
        """Load the level"""        
        level1 = level001.level()
        layout = level1.getLayout()
        img_list = level1.getSprites()
        
        """Create the Pellet group"""
        self.pellet_sprites = pygame.sprite.RenderUpdates()
        self.super_pellet_sprites = pygame.sprite.RenderUpdates()
        """Create the block group"""
        self.block_sprites = pygame.sprite.RenderUpdates()
        self.monster_sprites = pygame.sprite.RenderUpdates()
        
        for y in xrange(len(layout)):
            for x in xrange(len(layout[y])):
                """Get the center point for the rects"""
                centerPoint = [(x*BLOCK_SIZE)+x_offset,(y*BLOCK_SIZE+y_offset)]
                if layout[y][x]==level1.BLOCK:
                    block = basicSprite.Sprite(centerPoint, img_list[level1.BLOCK])
                    self.block_sprites.add(block)
                elif layout[y][x]==level1.SNAKE:
                    self.snake = Snake(centerPoint,img_list[level1.SNAKE])
                elif layout[y][x]==level1.PELLET:
                    pellet = basicSprite.Sprite(centerPoint, img_list[level1.PELLET])
                    self.pellet_sprites.add(pellet) 
                elif layout[y][x]==level1.MONSTER:
                    monster = Monster(centerPoint, img_list[level1.MONSTER]
                                       , img_list[level1.SCARED_MONSTER])
                    self.monster_sprites.add(monster) 
                    """We also need pellets where the monsters are"""
                    pellet = basicSprite.Sprite(centerPoint, img_list[level1.PELLET])
                    self.pellet_sprites.add(pellet) 
                elif layout[y][x]==level1.SUPER_PELLET:
                    super_pellet = basicSprite.Sprite(centerPoint, img_list[level1.SUPER_PELLET])
                    self.super_pellet_sprites.add(super_pellet) 
                     
        """Create the Snake group"""            
        self.snake_sprites = pygame.sprite.RenderUpdates(self.snake)                                  

if __name__ == "__main__":
    MainWindow = PyManMain(500,575)
    MainWindow.MainLoop()
       