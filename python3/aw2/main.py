#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 03:58:50 2017

@author: Michael Durrer
"""
import os,sys
import pygame
from pygame.locals import *
from engine import *
from cpu import *
if __name__ =='__main__':
    game = Engine("AW2 Working Title","data.obj")
    print ("Another World 2 Working Title")
    # Main Loop
    scenes = []
    while True:
        for event in pygame.event.get():
            if event.type==QUIT:
                pygame.quit()
                sys.exit()
            if event.type==pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    pygame.quit()
                    sys.exit()
        pygame.display.update()
    #raise SystemExit
    pygame.quit()

