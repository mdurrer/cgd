import pygame
from pygame.locals import *

from pgu import engine

from cnst import *

class Pause(engine.State):
    def __init__(self,game,text,next):
        self.game,self.text,self.next = game,text,next
        
    def paint(self,screen):
        fnt = self.game.font
        text = self.text
        
        n = 0
        for line in [text,'press enter']:
        
            img = fnt.render(line,1,(0,0,0))
            sw,sh = 640,400
            x,y = (sw-img.get_width())/2,(sh-img.get_height())/2+n*(img.get_height())
            for dx,dy in [(-1,-1),(-1,1),(1,-1),(1,1)]:
                screen.blit(img,(x+dx,y+dy))
            c = (255,255,255)
            if n == 1:
                c = (0xaa,0xaa,0xaa)
            img = fnt.render(line,1,c)
            screen.blit(img,(x,y))
            n += 1
        
        pygame.display.flip()

    def event(self,e):
        if (e.type is KEYDOWN and e.key == K_RETURN) or e.type is MOUSEBUTTONDOWN:
            return self.next
        
        
        
        
        
        
        
        