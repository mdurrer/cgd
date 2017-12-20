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
class Event(object):
    def __init__(self,event):
        self.event = event
    def __init__(self):
        self.event = pygame.event()
# Virtual Components for engine
        
