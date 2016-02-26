import os
import random

import pygame
from pygame.locals import *

from pgu import engine

import states

from cnst import *

CW,CH = 80,120
PAD = 10

TCARDS = 9


class Cards(engine.State):
    def __init__(self,game,mode,next):
        self.game = game
        self.next = next
        self.mode = mode
        
        
    def init(self):
        self.back = pygame.image.load(os.path.join("data","cards","back.png")).convert()
        self.cards = [pygame.image.load(os.path.join("data","cards","%d.png"%n)).convert() for n in xrange(1,TCARDS+1)]
        self.bkgr = pygame.image.load(os.path.join("data","cards","bkgr.jpg")).convert()

        if self.mode == 0: #normal mode
            self.CARDS = 9
            self.TX,self.TY = 45,0
            self.COLS,self.ROWS = 6,3
            self.STACK = [0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8]
        elif self.mode == 1: #brain-dead mode
            self.CARDS = 6
            self.TX,self.TY = 135,0
            self.COLS,self.ROWS = 4,3
            self.STACK = [0,4,6,7,8,3,0,4,6,7,8,3]

        random.shuffle(self.STACK)
        
        self.layout = [[self.STACK[y*self.COLS+x] for x in xrange(0,self.COLS)] for y in xrange(0,self.ROWS)]
        
        self.over = [[0 for x in xrange(0,self.COLS)] for y in xrange(0,self.ROWS)]
        
        self.timer = 0
        
        self.frames = 0
        self.timeout = 45*FPS
        
    def paint(self,screen):
        screen.blit(self.bkgr,(0,0))
        y = self.TY+PAD
        for ty in xrange(0,self.ROWS):
            x = self.TX+PAD
            for tx in xrange(0,self.COLS):
                img = self.back
                if self.over[ty][tx]: 
                    img = self.cards[self.layout[ty][tx]]
                screen.blit(img,(x,y))
                x += CW+PAD
            y += CH+PAD
        
        screen.fill((0,0,0),(0,400,640,80))
        fnt = self.game.font
        
        img = fnt.render("%d seconds left..."%((self.timeout+FPS/2)/FPS),1,(255,255,255))
        screen.blit(img,((SW-img.get_width())/2,400+(80-img.get_height())/2))
            
        sw,sh = SW,SH
        s1 = screen
        if 1: #self.cur != 0:
            img = fnt.render("press W to wimp out",1,(0xaa,0xaa,0xaa))
            s1.blit(img,((sw-img.get_width())/2,480-img.get_height()))

            
        pygame.display.flip()
        
    def loop(self):
        if self.frames%FPS == 0:
            self.repaint()
        self.timeout -= 1
        
        if self.timeout <= 0 and not self.timer:
            self.next.value = 'loser'
            return self.next

        if self.timer:
            self.timer -= 1
            if self.timer != 0: return
            if self.next.value == 'winner':
                return self.win()
            for ty in xrange(0,self.ROWS):
                for tx in xrange(0,self.COLS):
                    #self.over[ty][tx] = 0
                    if self.stats[self.layout[ty][tx]] == 1:
                        self.over[ty][tx] = 0
            self.game.sfx('cards-flip')
            self.repaint()
                
    def win(self):
        self.next.value = 'winner'
        return self.next
            
    def event(self,e):
        if self.timer: return
        
        if e.type is KEYDOWN and e.key == K_w:
            return self.win()
        
        if e.type is MOUSEBUTTONDOWN:
            x,y = e.pos
            tx,ty = (x-(self.TX+PAD/2))/(CW+PAD),(y-(self.TY+PAD/2))/(CH+PAD)
            #print tx,ty
            if tx >= 0 and tx < self.COLS and ty >= 0 and ty < self.ROWS:
                if self.over[ty][tx] == 0:
                    self.over[ty][tx] = 1
                    self.game.sfx('cards-flip')
                
                stats = [0 for n in xrange(0,TCARDS)]
                for ty in xrange(0,self.ROWS):
                    for tx in xrange(0,self.COLS):
                        if self.over[ty][tx]:
                            stats[self.layout[ty][tx]] += 1
                self.stats = stats
                totals = [0,0,0]
                for n in xrange(0,TCARDS):
                    totals[stats[n]] += 1
                #print stats
                #print totals
                if totals[1] > 1:
                    self.timer = FPS
                    #print 'oops'
                if totals[2] == self.CARDS:
                    self.next.value = 'winner'
                    self.timer = FPS
                    #print 'winner'
                
                self.repaint()
                
if __name__ == '__main__':
#     g = engine.Game()
#     from pgu import timer
#     g.timer = timer.Timer(FPS)
#     g.tick = g.timer.tick
#     pygame.font.init()
#     g.font = pygame.font.Font(os.path.join('data','teen.ttf'),20)
#     g.screen = pygame.display.set_mode((SW,SH))
    import main
    g = main.Game()
    class O: pass
    obj = O()
    obj.value = None
    g.run(Cards(g,0,obj))
    
                
