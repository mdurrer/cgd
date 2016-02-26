#-------------------------------------------------------------------------------
# Name:        Chip8 Input Emulation
# Purpose:
#
# Author:      pixman
#
# Created:     06/10/2012
# Copyright:   (c) pixman 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------

class Input:
    def __init__(self,interface):
        print ("Initiating Input instance")
        self.Interface = interface

