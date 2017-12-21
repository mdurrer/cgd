#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 15 02:50:54 2017

@author: michael
"""

import os,sys
from pygame.locals import *
from pygame import *
from engine import *
from sdl2.video import SDL_GL_DOUBLEBUFFER
class Video(object):
    def __init__(self,x,y,bpp,flags,engine):
        self.resX = x
        self.resY = y
        self.bpp = bpp
        self.flags = SDL_GL_DOUBLEBUFFER
    def initDisplay(self,resolution,bpp,flags):
        display.set_mode((self.resX,self.resY),flags)
    def setTitle(self,title):
        self.title = display.set_caption(title)
    def flipDisplay(self):
        display.flip()
    def test(self):
        pass

#TODO: Write polygon / vector / pixel class into Video class
    """docstring for  __init__(self, arg):
        super _init__()
        self.arg = arg
        """
        