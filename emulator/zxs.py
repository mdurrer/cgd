import os
import sys
import pygame
from processor import *
class ZXS_CPU(Processor):
	def __init__(self,systemarg):
		self.system = systemarg
		print "Initializing " + systemarg
		print "Initializing CPU registers..."
		self.A = self.B = self.C = self.D = self.E = self.F = self.H = self.L = self.SPlow = self.SPhigh = self.SP = self.IXlow = self.IXhigh = self.IX = self.IYlow = self.IYhigh = self.IY = 0 
		self.FLAG_C = 0x01
		self.FLAG_N = 0x02
		self.FLAG_P = 0x04
		self.FLAG_V = FLAG_P
		self.FLAG_3 = 0x08
		self.FLAG_H = 0x10
		self.FLAG_5 = 0x20
		self.FLAG_Z = 0x40
		self.FLAG_S = 0x80
		elf.tstates = None
	def getA(self):
		return self.A
	def getB(self):
		return self.B
	def getC(self):
		return self.C
	def getD(self):
		return self.D
	def getE(self):
		return self.E
	def getF(self):
		return self.F
	def getH(self):
		return self.H
	def getL(self):
		return self.L
	def getBC(self):
		return ((self.C << 8)or  self.B)
	def getDE(self):
		return ((self.E << 8) or self.D)
	def getHL(self):
		return ((self.L << 8) or self.H)
	def getSP(self):
		return ((self.SPhigh << 8) or self.SPlow) 
	def getPC(self):
		return ((self.PChigh << 8) or self.PClow)
	def setA(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.A = value
	def setB(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.B = value
	def setC(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.C = value
	def setD(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.D = value
	def setE(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.E = value
	def setF(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.F = value
	def setH(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.H = value
	def setL(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.L = value
	def setBC(self, value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.C = value >>8
			self.B = value 
	def setPC(self,value):
		if type(value) != type(3):
			print "Error, value is not of integer type!"
			return 1
		else:
			self.PChigh = value >> 8
			self.PClow = value
