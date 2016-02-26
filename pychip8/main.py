#-------------------------------------------------------------------------------
# Name:        PyCHIP8 / Main
# Purpose:      Chip8 Emulator in Python
#
# Author:      pixman
#
# Created:     01/10/2012
# Copyright:   (c) pixman 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import os,sys,pygame,chip8vm

def main():
    print ("Starting Chip8 Emulator")
    VM = chip8vm.Chip8_VM(Debug=True)
    VM.Run()

if __name__ == '__main__':
    main()
