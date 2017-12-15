#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 19:23:48 2017

@author: michael
"""

import os,sys,pygame
from video import  *
class CPU(object):
    def __init__(self,name,adr):
        self.name = name
        self.engine = name
        self.pc = 0
        self.video = Video(1600,900,bpp=24, flags=SDL_GL_DOUBLEBUFFER)
        print ("Virtual CPU created")
        return None
    def nextOpcode(list):
        if self.pc == 0x00001]:
            print ("RTS")
            pygame.quit()
        
    