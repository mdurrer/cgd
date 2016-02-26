import os

import pygame
from pygame.locals import *

from pgu import engine

from cnst import *

class Title(engine.State):
    def __init__(self,game):
        self.game = game
        
    def init(self):
        self.game.music('outside')
        self.bkgr = pygame.image.load(os.path.join("data","title","bkgr.jpg")).convert()
        self.titles = pygame.image.load(os.path.join("data","title","titles.png")).convert_alpha()
        self.logo = pygame.image.load(os.path.join("data","title","toba.jpg")).convert()
        
        self.frame = 0
        
        import rooms.lair
        self.next = rooms.lair.Room(self.game,'title')

        
    def update(self,screen):
        self.paint(screen)
        
    def paint(self,screen):
        f = self.frame
        n = FPS*3
        if f < (FPS*3):
            screen.blit(self.logo,(0,0))
        else:
            i = f-FPS*3
            x = SW*i/(FPS*5)
            if i > int(FPS*4.5) and f%5 == 0:
                screen.fill((255,255,255),(0,0,SW,400))
            else:
                screen.blit(self.bkgr,(-x,0))
                screen.blit(self.titles,(0,0))
            
        pygame.display.flip()
        
    def event(self,e):
        if e.type is KEYDOWN:
            return self.next
            
        
    def loop(self):
        self.frame += 1
        
        if self.frame > (FPS*8):
            #import rooms.swamp
            #return rooms.swamp.Room(self.game,None)
            return self.next

        
    