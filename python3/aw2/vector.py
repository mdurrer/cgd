#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan  1 19:54:38 2018

@author: michael
"""

import os,sys
from pygame.locals import *
from pygame import *
from engine import *
from sdl2.video import SDL_GL_DOUBLEBUFFER
from cairo import *

class Vector:
    def __init__(self):
        return self