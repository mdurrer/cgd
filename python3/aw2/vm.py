#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 14 19:23:48 2017

@author: michael
"""

import os,sys,pygame
class VirtualMachine(object):
    def __init__(self,name,engine):
        self.name = name
        self.dataFile = data
        if not(pygame.init()):
            print ("Couldn't initialize PyGame Engine")
        else:
            print ("PyGame Engine successfully initialized.")