import os,sys

import pygame
from pygame.locals import *

from cnst import *

import sys; sys.path.insert(0, "/home/michael/python/toba-pyweek3/pgu")

from pgu import gui

import level

class LevEdit(gui.Widget):
    def __init__(self,src):
        self.src = src
        gui.Widget.__init__(self)
        self.level = level.Level(None,src)
        self.level.init()
        self.style.width = self.level.bkgr.get_width()
        self.style.height = self.level.bkgr.get_height()+32
        
    def paint(self,screen):
        self.level.mode = 'edit'
        self.level.paint(screen)
        
        if self.mode.value in ('walkable','objs'):
            img = self.level.i_walkable
            img.set_alpha(128)
            img.set_colorkey((0,0,0))
            screen.blit(img,(0,0))
            
            y = TH/2
            for row in self.level.walkable:
                x = TW/2
                for v in row:
                    if v: screen.fill((255,255,255),(x,y,2,2))
                    x += TW
                y += TH
        
        if self.mode.value == 'layers':
            img = self.level.i_layers
            img.set_alpha(128)
            img.set_colorkey((0,0,0))
            screen.blit(img,(0,0))
        
        if self.mode.value == 'hotspots':
            img = self.level.i_hotspots
            img.set_alpha(128)
            img.set_colorkey((0,0,0))
            screen.blit(img,(0,0))
            
        if self.mode.value == 'objs':
            l = gui.Label('x')
            fnt = l.style.font
            for o in self.level.objs.values():
                pygame.draw.rect(screen,(0,0,0),o.rect,2)
                pygame.draw.rect(screen,(255,255,255),o.rect,1)
                img = fnt.render(o.name,1,(0,0,0),(255,255,255,128))
                screen.blit(img,(o.rect.centerx-img.get_width()/2,o.rect.bottom+1))
        
                
    def hotspots_set(self,f):
        self.level.hotspots[f['color'].value] = f['name'].value
        app.mywindow.close()
            
    def event(self,e):
        if self.mode.value == 'hotspots':
            if e.type is MOUSEBUTTONDOWN and e.button == 1:
                f = gui.Form()
                
                t = gui.Table()
                c = self.level.i_hotspots.get_at(e.pos)
                ct = self.level.c2hex(c)
                t.tr()
                t.td(gui.Label('Color: '))
                t.td(gui.Input(value=ct,name='color'))
                
                t.tr()
                t.td(gui.Label('Name: '))
                name = self.level.hotspots_match(c)
                if name == None: name = ''
                wb = gui.Input(value=name,name='name')
                t.td(wb)
                t.tr()
                w = gui.Button(gui.Label('Okay'))
                w.connect(gui.CLICK,self.hotspots_set,f)
                t.td(w,colspan=2)
                
                d = gui.Dialog(gui.Label('Hotspots'),t)
                d.open()
                
                wb.focus()
                
        if self.mode.value == 'objs':
            if e.type is MOUSEBUTTONDOWN and e.button == 3:
                o = self.level.objs_find(e.pos)
                if o == None:
                    self.obj = o = level.Obj(self.level,'','blank',e.pos)
                    self.objs_form(o)
                else:
                    #del self.level.objs[o.name]
                    #self.repaint()
                    self.obj = o
                    self.objs_form(o)
            if e.type is KEYDOWN and e.key == K_DELETE and self.obj:
                if self.obj:
                    del self.level.objs[self.obj.name]
                    self.obj = None
                self.repaint()
                    
            if e.type is MOUSEBUTTONDOWN and e.button == 1:
                self.obj = self.level.objs_find(e.pos)
                
            if e.type is MOUSEMOTION and e.buttons[0] == 1 and self.obj:
                self.obj.rect.centerx, self.obj.rect.centery = e.pos
                self.repaint()
                
    def objs_form(self,o):
        f = gui.Form()
        
        t = gui.Table()
        t.tr()
        t.td(gui.Label('Name: '))
        t.td(gui.Input(value=o.name,name='name'))
        t.tr()
        t.td(gui.Label('Src: '))
        t.td(gui.Input(value=o.src,name='src'))
        t.tr()
        t.td(gui.Label('Scale: '))
        t.td(gui.Input(value=str(o.scale),name='scale'))
        t.tr()
        w = gui.Button(gui.Label('Okay'))
        w.connect(gui.CLICK,self.objs_update,f)
        t.td(w,colspan=2)
        
        d = gui.Dialog(gui.Label('Objects'),t)
        d.open()
        
    def objs_update(self,f):
        if self.obj.name in self.level.objs:
            del self.level.objs[self.obj.name]
        self.obj.name = f['name'].value
        self.obj.src = f['src'].value
        self.obj.scale = int(f['scale'].value)
        self.obj.load()
        self.level.objs[self.obj.name] = self.obj
        self.repaint()
        app.mywindow.close()
        
                

def init(src):
    app = gui.Desktop()
    app.connect(gui.QUIT,app.quit,None)
    
    
    
    t = gui.Table()
    t.tr()
    
    g = app.mode = gui.Group()
    t.td(gui.Tool(g,gui.Label('Background'),'bkgr'))
    t.td(gui.Tool(g,gui.Label('Layers'),'layers'))
    t.td(gui.Tool(g,gui.Label('Walkable'),'walkable'))
    t.td(gui.Tool(g,gui.Label('Hot Spots'),'hotspots'))
    t.td(gui.Tool(g,gui.Label('Objects'),'objs'))
    
    t.tr()
    
    l = LevEdit(src)
    l.mode = g
    g.connect(gui.CHANGE,l.repaint)
    w = gui.ScrollArea(l,SW,400)
    
    t.td(w,colspan=5)
    
    t.tr()
    w = gui.Button(gui.Label('Save'))
    w.connect(gui.CLICK,l.level.save)
    t.td(w)
    
    app.init(t)
    return app



if __name__ == '__main__':
    screen = pygame.display.set_mode((SW,SH))
    src = sys.argv[1]
    app = init(src)
    app.run()
