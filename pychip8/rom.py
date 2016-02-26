#-------------------------------------------------------------------------------
# Name:        Chip8 ROM Handler
# Purpose:
#
# Author:      pixman
#
# Created:     01/10/2012
# Copyright:   (c) pixman 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------

class ROM:
    def __init__(self,memory,filename=None):
        print ("Initiating ROM instance with file:",filename)
        self.Memory = memory
        self.Data = None
        self.Length = None
    def Load(self,filename):
        file = open(filename,mode='rb')
        print("Opening",filename)
        self.Data = file.read()
        print ("Closing",filename)
        file.close()
        if self.Data != None:
            print ("Successfully loaded",filename)
        else:
            print ("Couldn't load",filename,"- Something went wrong.")
        self.Length = len(self.Data)
        print (self.Data[0],self.Data[1])
    def LoadTo(self,addr):
        for b in range(self.Length):
            self.Memory.Mem[addr+b] = self.Data[b]
            # print(self.Memory.Mem[addr+b]) # Debugging, shows data (if any)