#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 19:23:48 2017

@author: michael
"""

import os,sys,pygame
from video import  *
class CPU(object):
    def __init__(self,name,engine):
        self.name = name
        self.engine = engine
        self.video = Video(1600,900,bpp=24, flags=SDL_GL_DOUBLEBUFFER)
        print ("Virtual CPU created")
        return self
    