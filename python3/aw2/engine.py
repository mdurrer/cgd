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
import numpy
from numpy import *
class Engine(object):
    def __init__(self,name,data,vm):
        self.xRes = 1600
        self.yRes = 900
        self.name = name
        self.dataFile = data
# Virtual Components for engine
        self.cpu = CPU("aw2", 0x0000)
        self.memory = Memory(64738)
        self.video = Video(self.xRes,self.yRes,24, DOUBLEBUF  )
        self.video.initDisplay((self.xRes,self.yRes),24,DOUBLEBUF)