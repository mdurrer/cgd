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
        self.engine = engine
       print ("Virtual Machine created")