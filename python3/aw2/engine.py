#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 19:23:48 2017

@author: michael
"""

import os,sys,pygame
from cpu import *
from pygame import *
from pygame.locals import *
from video import *
import numpy as np

class Engine(object):
    def __init__(self,name,data):
        # Define some colors
        self.BLACK    = (   0,   0,   0)
        self.WHITE    = ( 255, 255, 255)
        self.GREEN    = (   0, 255,   0)
        self.RED      = ( 255,   0,   0)
        self.BLUE     = (   0,   0, 255)
        self.xRes = 1600
        self.yRes = 900
        self.name = name
        self.dataFile = data
        self.data = array(65536)
        self.contents = []
# Virtual Components for engine

        self.cpu = CPU("aw2", 0x0000)
        self.memory = Memory(64738)
        self.video = Video(self.xRes,self.yRes,24, DOUBLEBUF, engine=self )
        self.video.surface = self.video.initDisplay((self.xRes,self.yRes),24,DOUBLEBUF)

    def loadScript(self,*args):
        f = open(sys.argv[1],"r")
        for num in f:
            self.contents.append(num.rstrip())                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
        f.close()
        print (self.contents)
  
    def convertScript(self,script):
        for word in self.data:
            self.data[word].rstrip()
    def loadMemory(self,data):
        for count in self.data
            for opcode in data:
                self.memory.memory[count] = opcode
            self.memory.memory = np.array([self.data])
            print (self.memory.memory)