#-------------------------------------------------------------------------------
# Name:        Chip8 Memory Module
# Purpose:
#
# Author:      pixman
#
# Created:     01/10/2012
# Copyright:   (c) pixman 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------

class Memory:
    def __init__(self):
        print ("Initiating Memory instance")
        self.Mem = [0 for x in range (0x0,0x1000)]
        if len(self.Mem) >= 0x1000:
            print ("Created 4096 Bytes of RAM")
        else:
            print ("Not enough bytes of RAM allocated, something went wrong")
    def PrintMemory(self):
        print (self.Mem)

