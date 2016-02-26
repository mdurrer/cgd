import os
import random

import pygame
from pygame.locals import *

from pgu import engine

import states

from cnst import *

PAD = 8
TPEGS = 6
ROWS = 8
COLS = 4
        
TX,TY = 8,80-2*8
PAD = 10

CW,CH = 30,30

HELP = [
"The self-destruct button is locked ",
"with a secure 4-color code.",
"",
"To break the code, fill in the ",
"current row with colors.  Click ",
"OK once you are ready.  The ",
"security system will give you ",
"feedback in 2 numbers: ",
"",
"1st: number of correct guesses",
"2nd: number of guesses that were",
"correct in color, not in placement",
# "1st# matches color & position ",
# "2nd: # matches color ",
# "3rd: # unmatched ",
"",
"You have 8 turns to try to crack",
"the code.  Good luck.",
]

HELP_CODE = [1,5,4,5]
HELP_BOARD = [
    [1,2,3,4],
#    [1,None,None,None],
#    [None,None,5,None],
    [None,None,None,None],
    [None,None,None,None],
    [None,None,None,None],
#    [None,1,None,5],
    [None,None,None,None],
    [None,None,None,None],
    [None,None,None,None],
    [None,None,None,None],
    ]
HELP_STATS = [
    [1,1,2],
#    [1,0,0],
#    [0,1,0],
    [None,None,None],
    [None,None,None],
    [None,None,None],
#    [0,0,2],
    [None,None,None],
    [None,None,None],
    [None,None,None],
    [None,None,None],
    ]
    
HELP_TEXT = [
"This is an example board.  At the",
"top is the guess and at the bottom",
"is the correct code.",
"",
"In the guess, only the yellow dot",
"is both the correct color and in",
"the correct placement.  This gives",
"a 1 for the 1st feedback number.",
"",
"The dark blue dot is a correct",
"color, but it is not in the correct",
"place, that gives a 1 for the 2nd",
"feedback number.",
"",
# "The two other dots are not a",
# "correct color, so you they don't",
# "count towards any feedback.",
# "",
#"
# "The next row shows the guesses",
# "that are correct in color and",
# "placement.  This is the 1st",
# "feedback number.",
# "",
# "The following row shows the",
# "guesses that are the correct",
# "color, but not the correct",
# "placement.  This is the 2nd",
# "feedback number.",
# "",
"If you are still confused searh for",
"\"mastermind\" on the web.",
"",
"Good luck!",
]
# HELP_TEXT = [
# "This is an example board.  At the",
# "top is the guess and at the bottom",
# "is the correct code.",
# "",
# "The next row shows the dots that",
# "are correct in color and placement.",
# "This is the 1st feedback #.",
# "",
# "The following row shows the dots",
# "that the correct color, but",
# "incorrect place.  This is the 2nd #.",
# "",
# "The last row shows the dots that",
# "do not match at all.  This is the",
# "3rd feedback #.",
# "",
# "If you are still confused searh for",
# "\"mastermind.\"  Good luck!",
# ]
#     

class Codes(engine.State):
    def __init__(self,game,mode,next):
        self.game = game
        self.next = next
        self.mode = mode
        
        
    def init(self):
        self.hole = pygame.image.load(os.path.join("data","codes","hole.png")).convert_alpha()
        self.pegs = [pygame.image.load(os.path.join("data","codes","%d.png"%n)).convert_alpha() for n in xrange(1,TPEGS+1)]
        self.pegs2 = [pygame.image.load(os.path.join("data","codes","%da.png"%n)).convert_alpha() for n in xrange(1,TPEGS+1)]
        
        self.bkgr = pygame.image.load(os.path.join("data","codes","bkgr.png")).convert()
        
        self.code = [random.randrange(0,TPEGS) for n in xrange(0,COLS)]
        #print self.code
        self.board = [[None for x in xrange(0,COLS)] for y in xrange(0,ROWS)]
        
        self.buttons = [pygame.image.load(os.path.join("data","codes","red%d.png"%n)).convert_alpha() for n in xrange(0,3)]
        
        self.stats = [[None,None,None] for y in xrange(0,ROWS)]
        
        self.rects = []
        
        self.row = 0
        self.color = 0
        self.button = 0
        
        self.frame = 0
        
        #self.timer = -1
        
        self.loser = 0
        
        self.txt = HELP
        
        self.help = 0
        if self.mode == 1:
            self.txt = HELP_TEXT
            self.code = HELP_CODE
            self.board = HELP_BOARD
            self.stats = HELP_STATS
            self.help = 1
            self.row = 0
            
        self.hover = (-1,-1)
            
        
    def text(self,s,text,rect,fg,bg):
        rect = pygame.Rect(rect)
        fnt = self.game.font
        img = fnt.render(text,1,bg)
        x,y = rect.centerx-img.get_width()/2,rect.centery-img.get_height()/2
        for dx,dy in [(-1,-1),(-1,1),(1,-1),(1,1)]:
            s.blit(img,(x+dx,y+dy))
        img = fnt.render(text,1,fg)
        s.blit(img,(x,y))
        return
        
    def stat(self):
        stat = [0,0,0]
        row = self.board[self.row][:]
        code = self.code[:]
        for n in xrange(0,COLS):
            if row[n] == code[n]:
                stat[0] += 1
                row[n] = None
                code[n] = None
                
        for n in xrange(0,COLS):
            for m in xrange(0,COLS):
                if row[n] != None and code[m] != None:
                    if row[n] == code[m]:
                        stat[1] += 1
                        row[n] = None
                        code[m] = None
        
        stat[2] = COLS-(stat[0]+stat[1])
        self.stats[self.row] = stat
        
        
    def paint(self,screen):
        #screen.fill((0xaa,0xaa,0xaa))
        
        screen.blit(self.bkgr,(0,0))
        
        x,y = 300,PAD*2-4
        for line in self.txt:
            self.text(screen,line,(x,y,340-24,20),(0xff,0xff,0xff),(0x00,0x00,0x00))
            y += 20
            
        if not self.help:
            x,y = 360,400-16-48
            for line in ['SELF-DESTRUCT','BUTTON']:
                self.text(screen,line,(x,y,120,32),(0xff,0xff,0xff),(0x00,0x00,0x00))
                y += 20
            v = self.button
            if self.frame%4 == 0: v *= 2
        
            img = self.buttons[v]
            x,y = (510,400-(64+8))
            screen.blit(img,(x,y))
            self.button_r = pygame.Rect(x,y,img.get_width(),img.get_height())
        
        y = TY+PAD
        for ty in xrange(0,ROWS):
            x = TX+PAD
            if ty != 0:
                screen.fill((0,0,0),(x,y-PAD/2-1,(PAD*3+CW*4),1))
            for tx in xrange(0,COLS):
                img = self.hole
                screen.blit(img,(x-1,y-1))
                if self.board[ty][tx] != None:
                    img = self.pegs[self.board[ty][tx]]
                    if self.row == ty:
                        if self.button == 0 or (self.frame%4 == 0):
                            img = self.pegs2[self.board[ty][tx]]
                            
                    if self.hover == (tx,ty) and self.button == 0:
                        img = self.pegs2[self.board[ty][tx]]
                    screen.blit(img,(x,y))
                x += CW+PAD
                
            c = (0xff,0xff,0x55)
            if self.row == ty:
                t = 0
                for n in xrange(0,COLS): 
                    t += int(self.board[self.row][n]!=None)
                if t == 4:
                    c = (0x55,0xff,0x55)
            if self.row < ty: c = (0xaa,0xaa,0xaa)
            if self.row > ty: c = (0xff,0x55,0x55)
            self.text(screen,'OK',(x,y,CW,CH),c,(0x00,0x00,0x00))
            
            x += CW+PAD+PAD-10
            if self.stats[ty][0] != None:
#                self.text(screen,'%d/%d/%d'%tuple(self.stats[ty]),(x,y,CW*2,CH),(0xff,0xff,0xff),(0x00,0x00,0x00))
                self.text(screen,'%d / %d'%(self.stats[ty][0],self.stats[ty][1]),(x,y,CW*2,CH),(0xff,0xff,0xff),(0x00,0x00,0x00))
            
            y += CH+PAD
            
        x,y = TX+PAD,16
        self.rects = []
        mpos = pygame.mouse.get_pos()
        for n in xrange(0,TPEGS):
            img = self.hole
            screen.blit(img,(x-1,y-1))
            img = self.pegs[n]
            r = pygame.Rect((x,y,CW,CH))
            
            if self.color == n or (self.help != 1 and self.button == 0 and r.collidepoint(mpos)):
                img = self.pegs2[n]
            
            screen.blit(img,(x,y))
            self.rects.append((r,n))
            x += (CW+PAD)
        
        screen.fill((0,0,0),(0,400,640,80))
        fnt = self.game.font
        
        #self.loser = 1
        if self.loser or self.help:
            x = TX+PAD
            y = 400+40-CH/2
            for n in xrange(0,COLS):
                img = self.pegs2[self.code[n]]
                screen.blit(img,(x,y))
                x += CW+PAD
        
            img = fnt.render("< -- Correct Code",1,(255,255,255))
        else:
            img = fnt.render('press H for more help',1,(0xff,0xff,0xff))
        
        screen.blit(img,((SW-img.get_width())/2,400+(80-img.get_height())/2))
            
        sw,sh = SW,SH
        s1 = screen
        
        if (not self.loser) and (not self.help):
            img = fnt.render("press W to wimp out",1,(0xaa,0xaa,0xaa))
            s1.blit(img,((sw-img.get_width())/2,480-img.get_height()))
            
        pygame.display.flip()
        
    def loop(self):
#         if self.timer > 0:
#             self.timer -= 1
#             if self.timer == 0:
#                 self.next.value = 'loser'
#                 print 'loser'
#                 return self.next

        self.frame += 1
        self.repaint()
                
    def win(self):
        self.game.sfx('codes-winner')
        self.button = 1
            
    def event(self,e):
        
        if self.help:
            if e.type is MOUSEBUTTONDOWN or e.type is KEYDOWN:
                return self.next
            return
        
        if self.loser and e.type is MOUSEBUTTONDOWN:
            self.next.value = 'loser'
            print 'loser'
            return self.next
        
        #if self.timer >= 0: return
        
        if e.type is KEYDOWN and e.key == K_w:
            return self.win()
        
        if e.type is KEYDOWN and e.key == K_h:
            return Codes(self.game,1,self)
        
        
        if e.type is MOUSEBUTTONDOWN:
            if self.button_r.collidepoint(e.pos) and self.button ==1 :
                self.next.value = 'winner'
                self.game.sfx('codes-red')
                self.repaint()
                return self.next

            
            for r,n in self.rects:
                if r.collidepoint(e.pos):
                    self.color = n
                    self.game.sfx('codes-click')
                    self.repaint()
                    return
            
            x,y = e.pos
            tx,ty = (x-(TX+PAD/2))/(CW+PAD),(y-(TY+PAD/2))/(CH+PAD)
            if ty >= 0 and ty < self.row and tx >= 0 and tx < COLS:
                self.color = self.board[ty][tx]
                self.game.sfx('codes-click')
                self.repaint()
                return
                
            t = 0
            for n in xrange(0,COLS): 
                t += int(self.board[self.row][n]!=None)
            if t == 4 and ty == self.row and tx == COLS:
                self.game.sfx('codes-click')
                self.stat()
                if self.stats[self.row][0] == 4:
                    self.win()
                    self.repaint()
                    return
                else:
                    self.row += 1
                    if self.row == ROWS:
                        self.loser = 1
                        self.game.sfx('codes-loser')
                        return
                
        if not self.button:
            if e.type is MOUSEBUTTONDOWN or e.type is MOUSEBUTTONUP:
                x,y = e.pos
                tx,ty = (x-(TX+PAD/2))/(CW+PAD),(y-(TY+PAD/2))/(CH+PAD)
                if ty == self.row and tx >= 0 and tx < COLS:
                    if self.board[ty][tx] != self.color:
                        self.board[ty][tx] = self.color
                        self.game.sfx('codes-click')
                self.repaint()
                return
                
            if e.type is MOUSEMOTION:
                x,y = e.pos
                h = self.hover
                self.hover = tx,ty = (x-(TX+PAD/2))/(CW+PAD),(y-(TY+PAD/2))/(CH+PAD)
                if h != self.hover:
                    self.repaint()
                return
                
                
if __name__ == '__main__':
    import main
    g = main.Game()
#     g = engine.Game()
#     from pgu import timer
#     g.timer = timer.Timer(FPS)
#     g.tick = g.timer.tick
#     pygame.font.init()
#     g.font = pygame.font.Font(os.path.join('data','teen.ttf'),20)
#     g.screen = pygame.display.set_mode((SW,SH))

    class O: pass
    obj = O()
    obj.value = None
    g.run(Codes(g,0,obj))
    
                
