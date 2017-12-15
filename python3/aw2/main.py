#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 03:58:50 2017

@author: Michael Durrer
"""
import os,sys
import pygame
import cpu
from pygame.locals import *
from engine import *
from cpu import *
if __name__ =='__main__':
    processor = CPU("VM",0x0000)
    game = Engine("AW2 Working Title","data.obj",cpu)
    print ("Another World 2 Working Title")
    # Main Loop
    scenes = []
    #raise SystemExit
    pygame.quit()

