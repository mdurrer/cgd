import os
import random

import pygame
from pygame.locals import *

from pgu import engine

import states

#SW,SH = 320,200
#TW,TH = 8,8
SW,SH = 640,400
TW,TH = 12,12 #16,16
W,H = (SW/TW,SH/TH)
IX,IY = (SW-(W*TW))/2,(SH-(H*TH))/2
INIT = 12
EXT = 12
WIN = INIT+EXT*5

COLORS = [(0,0,0),(0x55,0xff,0x55),(0xff,0xff,0x55),(0x55,0x55,0xff)]

class Nibbles(engine.State):
    def __init__(self,game,cur,next,score=0):
        self.game,self.cur,self.next = game,cur,next
        self.score = score
        
    def init(self):
        l = self.layer = [[0 for x in xrange(W)] for y in xrange(0,H)]
        for x in xrange(0,W):
            l[0][x] = 1
            l[H-1][x] = 1
        for y in xrange(0,H):
            l[y][0] = 1
            l[y][W-1] = 1
            
        if self.cur == 2:
            for x in xrange(W*1/4,W*3/4):
                l[H/2][x] = 1
        elif self.cur == 3:
            for y in xrange(0,H*2/3):
                l[y][x*1/3] = 1
                l[H-(y+1)][x*2/3] = 1
        elif self.cur == 4:
            for y in xrange(H*1/4,H*3/4):
                l[y][W*1/4] = 1
                l[y][W*3/4] = 1
            for x in xrange(W*1/4,W*3/4):
                l[H/2][x] = 1
        elif self.cur == 5:
            for x in xrange(0,W*2/5):
                l[H/2][x] = 1
                l[H/2][W-(x+1)] = 1
            for y in xrange(0,H*1/3):
                l[y][W/2] = 1
                l[H-(y+1)][W/2] = 1
            
        x,y = self.find()
        l[y][x] = 2
        
        x,y = self.pos = self.find(8)
        l[y][x] = 3
        self.tail = [(x,y)]
        self.length = INIT
        self.facing = self.getfacing((x,y))
        
        self.frame = 0
        self.q = []
        
    def getfacing(self,pos):
        l = self.layer
        x,y = pos
        score = []
        for dx,dy in [(-1,0),(1,0),(0,-1),(0,1)]:
            d = 0
            while l[y+d*dy][x+d*dx] != 1: d += 1
            score.append((d,dx,dy))
        score.sort()
        d,dx,dy = score.pop()
        return dx,dy
        
    def find(self,b=2):
        l = self.layer
        v = 1
        while v != 0:
            x,y = random.randrange(b,W-b*2),random.randrange(b,H-b*2)
            v = l[y][x]
        return x,y
        
    def paint(self,screen):
        s1 = screen
        #s2 = screen.subsurface(160-4,100-4,SW+8,SH+8)
        #s2.fill((0,0,0))
        #screen = screen.subsurface(160,100,SW,SH)
        screen.fill((0,0,0))
        l = self.layer
        for y in xrange(0,H):
            for x in xrange(0,W):
                v = l[y][x]
                if v:
                    screen.fill(COLORS[v],(IX+x*TW,IY+y*TH,TW,TH))
        
        s1.fill((0,0,0),(0,400,640,80))
        fnt = self.game.font
        
        img = fnt.render("SCORE: %05d"%(self.score),1,(255,255,255))
        sw = 640
        s1.blit(img,((sw-img.get_width())/2,400+(80-img.get_height())/2))
        
        if self.cur != 0:
            img = fnt.render("press W to wimp out",1,(0xaa,0xaa,0xaa))
            s1.blit(img,((sw-img.get_width())/2,480-img.get_height()))

        pygame.display.flip()
        
        if self.frame == 0:
            return states.Pause(self.game,'GET READY!',self)
        

        
    def event(self,e):
        if e.type is KEYDOWN and e.key == K_UP: self.q.append((0,-1))
        if e.type is KEYDOWN and e.key == K_RIGHT: self.q.append((1,0))
        if e.type is KEYDOWN and e.key == K_DOWN: self.q.append((0,1))
        if e.type is KEYDOWN and e.key == K_LEFT: self.q.append((-1,0))
        if self.cur != 0 and e.type is KEYDOWN and e.key == K_w:
            return self.win()
    def win(self):
        self.next.value = 'winner'
        return states.Pause(self.game,'WINNER!',self.next)
        
    def loop(self):
        
        if self.cur == 0 and self.frame > 40:
            self.next.value = 'crash'
            return states.Pause(self.game,'SEGMENTATION FAULT',self.next)
        
        if self.frame % 2 == 0:
            if len(self.q):
                f = self.q.pop(0)
                if (-f[0],-f[1]) != self.facing:
                    self.facing = f
            l = self.layer
            x,y = self.pos = self.pos[0]+self.facing[0],self.pos[1]+self.facing[1]
            v = l[y][x]
            if v in (1,3):
                self.game.sfx('nibbles-wall')
                self.next.value = 'loser'
                return states.Pause(self.game,'GAME OVER!',self.next)
            
            l[y][x] = 3
            tail = self.tail
            tail.append((x,y))
            
            if v == 2:
                self.game.sfx('nibbles-nibble')
                x,y = self.find()
                l[y][x] = 2
                self.score += self.length
                self.length += EXT
                
                if self.cur < 3 and self.length >= WIN:
                    g = Nibbles(self.game,self.cur+1,self.next,self.score)
                    return g
                
                if self.cur == 3 and self.length >= WIN:
                    return self.win()

            if len(tail) > self.length:
                x,y = tail.pop(0)
                l[y][x] = 0
            self.repaint()
        self.frame += 1

if __name__ == '__main__':
#     g = engine.Game()
#     from pgu import timer
#     import cnst
#     g.timer = timer.Timer(cnst.FPS)
#     g.tick = g.timer.tick
#     pygame.font.init()
#     g.font = pygame.font.Font(os.path.join('data','teen.ttf'),20)
#     g.screen = pygame.display.set_mode((640,480))
    import main
    g = main.Game()
    class O: pass
    obj = O()
    obj.value = None
    g.run(Nibbles(g,1,obj))
    
