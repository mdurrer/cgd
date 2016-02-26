import os,sys,pygame
class Intel8080:
	def __init__(self, memory):
		print "Initializing Intel 8080 CPU..."
		self.type = "Intel 8080 CPU"
		self.mem = memory
		""" Variables for the registers  (all commented)"""
		self.PC = None # Program Counter
		self.B = 0  # 8/16 Bit R egisters (B/BC)
		self.C = 0
		self.D = 0 # 8/16 Bit R egisters (D/DE)
		self.E = 0
		self.H = 0 # 8/16 Bit R egisters (H/HL)
		self.L = 0
		self.A = 0 # 8 Bit Register
		self.F = 0 # 8 Bit Flag Register
		self.SP = [0x00] * 0xF000 # Stack Pointer filled with zeros
		self.Opcodes = {\
		"40":(self.Opcode40,1),\
		"41":(self.Opcode41,3),\
		}
		self.resetCPU()
		print "Done."
	def __del__(self):
		print "Deleting %s..."%self.type
	def resetCPU(self):
		print "Resetting %s..."%self.type
		print "Done."
	def GetCPUType(self):
		return self.type
	def Interrupt(type):
		print "Interrupt" 
		return "Interrupt"
	def Step(self):
		print "Step"
	def Opcode (self, opcode):
		self.Opcodes[opcode][0]()
		print "Opcode test"
	def Opcode40(self): # mov b,b
		pass
	def Opcode41(self): # mov b,c
		self.B = self.C
	def Opcode42(self): # mov b,d
		self.B = self.D
	def Opcode43(self): # mov b,e
		self.B = self.E
	def Opcode44(self): # mov b,h
		self.B = self.H
	def Opcode45(self,): # mov b,l
		self.B = self.L
	def Opcode46(self, address): # mov b,MM
		self.B = self.mem[address] # HL FIX THIS!! WHY? It's a trap emulator check
	def Opcode47(self): # mov b,a
		self.B = self.A
