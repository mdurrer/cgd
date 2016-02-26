# __________________________________________
# | Space Invaders Emulator                         
# | by Michael Durrer                                  
# | Memory Class / memory.py                          
# |_________________________________________

import os,sys,pygame

class Memory:
	def __init__(self,size):
		self.ram = [0x00] * size
		self.romhandle = None
	def __del__(self):
		pass
	def LoadROM(self,file):
		self.romhandle = open(file,"rb")
		for i in range(0x2000):
			self.ram[i] = self.romhandle.read(1)
		print "%s Bytes read into Memory at 0x0000 from %s ..." % (self.romhandle.tell(),file)
		#print self.ram # Prints RAM content to check if it worked