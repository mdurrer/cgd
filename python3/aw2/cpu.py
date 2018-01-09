#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 19:23:48 2017

@author: michael
"""

from memory import *
import os,sys,pygame
from pygame import *
from pygame.locals import *
from video import  *
class CPU:
    def __init__(self,name="",adr=0x0000):
        self.name = name
        self.engine = name
        self.pc =  adr
        self.lastOpcode = 0x00
        self.video = Video(1600,900,bpp=24, flags=SDL_GL_DOUBLEBUFFER,engine="Hey")
        print ("Virtual CPU created by Engine",self.engine)
        return None
        self.video.setTitle(self.name)

        print (self.data)
    def nextOpcode(self,memory):
        print("NextOpcode",memory.memory[self.pc])
        if (memory.memory[self.pc]) == "RTS".lower():
            print("RTS")
            pygame.quit()
            sys.exit(1)
        self.pc += 1
    def opRTS(self):
        pygame.quit()
        sys.exit()
    
    