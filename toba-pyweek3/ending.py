import random
import os

import pygame
from pygame.locals import *

from pgu import engine

from cnst import *

FRAMES = 8

class Ending(engine.State):
    def __init__(self,game):
        self.game = game
        
    def init(self):
        self.game.sfx('lair-explode')
        self.blast = [pygame.image.load(os.path.join("data","ending","ani%04d.png"%n)).convert_alpha() for n in xrange(2,11)]
        
        self.blasts = []
        
        self.bkgr = pygame.image.load(os.path.join("data","lair","bkgr.jpg")).convert()
        
        self.frame = 0
        self.black = pygame.Surface((SW,SH)).convert()
        self.done = 0
        
    def update(self,screen):
        self.paint(screen)
        
    def paint(self,screen):
        screen.blit(self.bkgr,(0,0))
        for data in self.blasts[:]:
            x,y,f = data
            
            img = self.blast[f]
            screen.blit(img,(x-img.get_width()/2,y-img.get_height()/2))
            
            f += 1
            data[2] = f
            if f == FRAMES:
                pygame.draw.circle(self.bkgr,(0,0,0),(x,y),48)
                self.blasts.remove(data)
        end = int(FPS*1.5)
        if self.frame > end:
            d = min(255,((self.frame-end)*255/FPS))
            if d == 255: self.done = 1
            self.black.set_alpha(d)
            screen.blit(self.black,(0,0))
        pygame.display.flip()
                
        
    def loop(self):
        if self.frame%(FPS/10) == 0:
            x,y = 0,0
            r = pygame.Rect(213,31,191,260)
            while not r.collidepoint((x,y)):
                x,y = random.randrange(0,SW),random.randrange(0,SH)
            self.blasts.append([x,y,0])
            
        if self.done:
            return TheEnd(self.game)
            
        self.frame += 1
        
        
THEEND = [
    "The End",
    ]
class TheEnd(engine.State):
    def __init__(self,game):
        self.game = game
        
    def init(self):
        self.game.music('outside')
        self.frame = 0
        self.next = Credits(self.game)
        
    def paint(self,screen):
        lines = THEEND
        screen.fill((0,0,0))
        x,y = 0,200-15*len(lines)
        fnt = self.game.font
        for line in lines:
            img = fnt.render(line,1,(255,255,255))
            screen.blit(img,((SW-img.get_width())/2,y))
            y += 30
        pygame.display.flip()
        
    def loop(self):
        if self.frame == FPS*2:
            return self.next
        self.frame += 1
        
        
    def event(self,e):
        if e.type is KEYDOWN or e.type is MOUSEBUTTONDOWN:
            return self.next

CREDITS = [
    "Colonel Wiljafjord and the Tarbukas Tyranny",
    "",
    "Phil Hassey",
    "- code, backgrounds, sfx -",
    "",
    "Tim Inge",
    "- music, sfx, testing -",
    "",
    "Nan Hassey",
    "- characters, animation -",
    "",
    "(c) 2006 - The Olde Battle Axe",
    ]
    
class Credits(engine.State):
    def __init__(self,game):
        self.game = game
        
    def init(self):
        self.game.music('outside')
        
    def paint(self,screen):
        lines = CREDITS
        screen.fill((0,0,0))
        x,y = 0,200-15*len(lines)
        fnt = self.game.font
        for line in lines:
            img = fnt.render(line,1,(255,255,255))
            screen.blit(img,((SW-img.get_width())/2,y))
            y += 30
        pygame.display.flip()
        
        
    def event(self,e):
        if e.type is KEYDOWN or e.type is MOUSEBUTTONDOWN:
            self.game.reset()
            import title
            return title.Title(self.game)
        
if __name__ == '__main__':
    g = engine.Game()
    from pgu import timer
    import cnst
    g.timer = timer.Timer(cnst.FPS)
    g.tick = g.timer.tick
    pygame.font.init()
    g.font = pygame.font.Font(os.path.join('data','teen.ttf'),20)
    g.screen = pygame.display.set_mode((640,480))
    g.run(Ending(g))
    
