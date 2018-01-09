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
from numpy import *
import numpy as np
from sdl2.video import SDL_GL_DOUBLEBUFFER
class Memory(object):
    def __init__(self,size):
        self.block = 0
        self.memory = np.array([0]*655536)
        return None
