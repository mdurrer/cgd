#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec 15 02:50:54 2017

@author: michael
"""

import os,sys,pygame
from pygame.locals import *
from sdl2.video import SDL_GL_DOUBLEBUFFER
class Video(object):
    def __init__(self,x,y,bpp,flags):
        self.resX = x
        self.resY = y
        self.bpp = bpp
        self.flags = SDL_GL_DOUBLEBUFFER
    def initDisplay(self,resolution,bpp,flags):
        display.set_mode([x,y],flags)
        