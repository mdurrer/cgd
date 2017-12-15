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
from sdl2.video import SDL_GL_DOUBLEBUFFER
class Engine(object):
    def __init__(self,name,data,vm):
        self.name = name
        self.dataFile = data
        self.cpu = CPU("aw2", 0xFFFF)
        self.memory = Memory(0,64738,1)

        print(self.memory)
        if not(pygame.init()):
            print ("Couldn't initialize PyGame Engine")
        else:
            print ("PyGame Engine successfully initialized.")