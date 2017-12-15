#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 19:23:48 2017

@author: michael
"""

from memory import *
import os,sys,pygame
from video import  *
class CPU(object):
    def __init__(self,name,adr):
        self.name = name
        self.engine = name
        self.pc =  adr
        self.lastOpcode = 0x00
        self.video = Video(1600,900,bpp=24, flags=SDL_GL_DOUBLEBUFFER)
        print ("Virtual CPU created")
        return None
    def nextOpcode(list):
        if self.pc == 0:
            
            print ("RTS")
            pygame.quit()
        
    