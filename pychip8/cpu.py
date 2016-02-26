#-------------------------------------------------------------------------------
# Name:        Chip CPU Module
# Purpose:
#
# Author:      pixman
#
# Created:     01/10/2012
# Copyright:   (c) pixman 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import memory
import pygame
import sys

class CPU:
    def __init__(self,memory,VirtualMachine=None,Debug=None):
        print ("Initiating CPU instance")
        self.Debugging = Debug
        self.Memory = memory
        self.VM = VirtualMachine
        self.CreateRegisters()
    def CreateRegisters(self):
        print ("Creating Registers")
        self.Registers = [0 for x in range(0x0,0x10)]
        self.I = int(0x00)
        self.ProgramCounter= int (0x200)
        self.StackPointer = int(0)
        self.Stack = []
        self.DelayTimer = int(0x0)
        self.SoundTimer = int(0x0)
        self.RawOpcode = ""
    def Push(self,value):
        if self.StackPointer>15:
            if self.Debugging:
                print ("Stack is full, couldn't process PUSH()")
            return (-1)
        else:
            if self.Debugging:
                print ("StackPointer plus 1")            
            self.Stack.append(value)
            self.StackPointer=+1
            return value
    def Pop(self):
        if self.StackPointer < 0:
            print ("Stack Pointer points to below zero, can't process POP()")
            sys.exit()
        else:
            if self.Debugging:
                print ("StackPointer minus 1")
            self.StackPointer -= 1
            return self.Stack.pop()
            
    def UpdateTimer(self):
        if self.DelayTimer != 0:
            self.DelayTimer -= 1
    def NextOpcode(self):
        self.OpcodePart =  ord(str(self.Memory.Mem[self.ProgramCounter]))
        if self.Debugging:
            print ("Opcode-Daten:", hex(self.OpcodePart), hex(ord(str(self.Memory.Mem[self.ProgramCounter+1]))))
        self.OpcodePart <<= 8
        self.OpcodePart |= ord(str(self.Memory.Mem[self.ProgramCounter+1]))
        self.OpcodePart = "0x%0.4X" % self.OpcodePart
        if self.Debugging:
            print ("Current Program Counter:",self.ProgramCounter)
        self.VM.Cpu.ProgramCounter += 2
        if self.Debugging:
            print ("Program Counter prognosis:", self.VM.Cpu.ProgramCounter)
        
        return self.OpcodePart
    def DecodeOpcode(self,opCode):
        rawOpCode = opCode[2:]
        Found = False
        switch = None
        x = 0
        OpcodeTable = { "0NNN" : 1, 
                        "1NNN" : 2, 
                        "8NN3" : 3, 
                        "2NNN" : 4, 
                        "ANNN" : 5,
                        "3NNN" : 6, 
                        "7NNN" : 7, 
                        "DNNN" : 8, 
                        "6NNN" : 9,
                        "4NNN" : 10,
                        "FN33" : 11,
                        "FN55" : 12,
                        "FN65" : 13,
                        "FN29" : 14,
                        "00EE" : 15,
                        "FN07" : 16,
                        "FN15" : 17,
                        "CNNN" : 18,
                        "FN1E" : 19,
                        "ENA1" : 20,
                        "EN9E" : 21,
                        "8NN0" : 22,
                        "9NN0" : 23,
                        }
        print ("Opcode: ", opCode[0:])
        firstNumber = str(opCode)[2] + "NNN"
        secondNumber = "N" + str(opCode)[3] + "NN"
        secondAndLast = "N" + str(opCode)[3] + "N" + str(opCode)[5]
        lastTwoNumbers = "NN" + str(opCode)[4:6]
        firstAndLast = str(opCode)[2] + "NN" + str(opCode)[5:6]
        firstAndLastTwo = str(opCode)[2] + "N" + str(opCode)[4:6]
        possibleOpCodes = [firstNumber, secondNumber, secondAndLast, lastTwoNumbers, firstAndLast, firstAndLastTwo, str(rawOpCode)]
        for i in possibleOpCodes:
            if i in OpcodeTable:
                switch = OpcodeTable[i]
                Found = True
        if Found == False:
            if self.Debugging:
                print ("Opcode",opCode, "not found")
        else:
            print ("Opcode",switch,"found")
        if switch == 1:
            self.Opcode_0NNN(rawOpCode)
        if switch == 2:
            self.Opcode_1NNN(rawOpCode)
        if switch == 4:
            self.Opcode_2NNN(rawOpCode)
        if switch == 5:
            self.Opcode_ANNN(rawOpCode)
        if switch == 6:
            self.Opcode_3NNN(rawOpCode)
        if switch == 7:
            self.Opcode_7NNN(rawOpCode)
        if switch == 8:
            self.Opcode_DNNN(rawOpCode)
        if switch == 9:
            self.Opcode_6NNN(rawOpCode)
        if switch == 15:
            self.Opcode_00EE()

        if self.Debugging:       
            print ("Decoding", possibleOpCodes)
    def Reset(self):
        self.Memory = memory.Memory(self)
        self.CreateRegisters(self)
        
    def Opcode_00E0(self):
        self.VM.Screen.fill((0,0,0))
    def Opcode_00EE(self):
        self.ProgramCounter = self.Pop()
        
        if self.Debugging:
            print ("Used",self.RawOpcode)
    def Opcode_0NNN(self,rawopc):
        if self.Debugging:
            print ("Used", self.RawOpcode)
    def Opcode_1NNN(self,rawopc):
        self.RawOpcode = rawopc
        if self.Debugging:
            print ("Used", self.RawOpcode)
        self.ProgramCounter = int(str( self.RawOpcode[1:]),16)
    def Opcode_2NNN(self, rawopc):
        self.RawOpcode = rawopc
        self.Push(self.ProgramCounter)
        if self.Debugging:
            print("Used", self.RawOpcode)
        self.ProgramCounter =  int(str(self.RawOpcode[1:]),16)
    def Opcode_ANNN(self,rawopc):
        self.RawOpcode = rawopc
        self.I = int(str(self.RawOpcode[1:]),16)
        if self.Debugging:
            print ("Used", self.RawOpcode)
    def Opcode_3NNN(self,rawopc):
        self.RawOpcode = rawopc
        if self.Registers[int(self.RawOpcode[1:2],16)] == int(self.RawOpcode[2:],16):
            self.ProgramCounter +=2
        # Function goes on and skips the next instruction (adding 2 to the PC)
    def Opcode_6NNN(self,rawopc):
        self.RawOpcode = rawopc
        self.Registers[int(self.RawOpcode[1],16)] == int(self.RawOpcode[2:],16)
    def Opcode_7NNN(self,rawopc):
        self.RawOpcode = rawopc
        self.Registers[1] = self.Registers[1] +  int(str(self.RawOpcode[2:]))
        #print (self.Registers)
       # print ("Register 2: ", int(self.Registers[1]))
        #print ("Byte from Opcode:",str(self.RawOpcode[2:]))
        # sys.exit("ENDE!") # LOESCHEN!
        if self.Debugging:
            print ("Used", self.RawOpcode)
    def Opcode_DNNN(self,rawopc):
        print ("SPrites are NEXT!")
        
