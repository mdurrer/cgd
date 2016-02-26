#-------------------------------------------------------------------------------
# Name:        Chip8 Virtual Machine
# Purpose:     Emulating Chip8  (uses Code from another Python Chip8 Emulator)
#
# Author:      pixman
#
# Created:     01/10/2012
# Copyright:   (c) pixman 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import os
import sys
import pygame
import cpu
import memory
import rom
import font
class Chip8_VM:
    def __init__(self,Debug=False):
        print ("Initiating Chip8 Virtual Machine")
        self.Debugging = Debug
        self.Memory = memory.Memory()
        self.Cpu = cpu.CPU(self.Memory,VirtualMachine=self,Debug=True)
        self.Rom = rom.ROM(self.Memory)
        self.Font = font.Font(self.Memory)
        self.Clock = pygame.time.Clock()
        self.NextCycle = Cycle(VirtualMachine=self)
        pygame.init() # To be sure, can be removed maybe? Multiple init-calls are legal and just will be dismissed if pygamei s activated
        pygame.display.init()
        self.Screen = pygame.display.set_mode((640,320), pygame.DOUBLEBUF|pygame.HWSURFACE)
    def Run(self):
        #self.Rom.Load("c:\python\mve\pychip8\Tank.c8") # Windows
        self.Rom.Load("Tank.c8")
        self.Rom.LoadTo(0x200)
        # DIsplay Code?
        while True:
            event = pygame.event.poll()
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    pygame.quit()
                    sys.exit()
                if event.key:
                    print ("Key", event.key," was pressed")
            """
            self.Memory.Mem[0x200] = "\x22"
            self.Memory.Mem[0x201] = "\x20"
            self.Memory.Mem[0x220] = "\xff"
            self.Memory.Mem[0x221] = "\x18"
            self.Memory.Mem[0x222] = "\xff"
            self.Memory.Mem[0x223] = "\x18"
            self.Memory.Mem[0x224] = "\x00"
            self.Memory.Mem[0x225] = "\xee"
            offset = 0x200
            """
            #print ("Speicher bei %s" % offset,": %s"%str(self.Memory.Mem[offset]), "%s"%str(self.Memory.Mem[offset+2]))
            self.NextCycle.ExecuteCycle()
            pygame.display.flip()
            #Update Clock / End Frame, one Instruction per Frame
            self.Clock.tick(60)


class Cycle:
    def __init__(self,VirtualMachine):
        global DoneCycles
        Cycle.DoneCycles = 0
        self.VM = VirtualMachine
        self.Debugging = self.VM.Debugging 
    
    def ExecuteCycle(self):
        if self.Debugging:
            print ("Doing cycle No.", Cycle.DoneCycles+1)
        self.ExecuteOpcode()
        event = pygame.event.poll()
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                pygame.quit()
                sys.exit()
            if event.key:
                print ("Key", event.key," was pressed")
        # Test for set Pixel routine
        for x in range(0,40):
            self.VM.Screen.set_at((x,20),(255,255,255))
            self.VM.Screen.set_at((x+1,22),(255,255,255))
            self.VM.Screen.set_at((x+2,24),(255,255,255))
            self.VM.Screen.set_at((x+3,26),(255,255,255))
        Cycle.DoneCycles+= 1
        return (1)
    def ExecuteOpcode(self):
        opcode = self.VM.Cpu.NextOpcode()
        decoded = self.VM.Cpu.DecodeOpcode(opcode)
        if self.Debugging:        
            print ("Updated ProgramCounter", self.VM.Cpu.ProgramCounter)
        
