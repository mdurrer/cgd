# __________________________________________
# | Space Invaders Emulator                         
# | by Michael Durrer                                  
# | Main file / emulatior.py                           
# |_________________________________________

import os,sys,pygame
from pygame import *
from arcade import *
from cpu import *
from memory import *
class Emulator:
	def __init__(self):
		self.machine = Arcade()
		self.finished = False
		print "Initializing Intel 8080 CPU Arcade Machine..."
	def __del__(self):
		machine =  None
		print "Quitting Intel 8080 CPU Arcade Machine..."
	def initEmulator(self):
		print "Initializing PyGame..."
		pygame.init()
		screen = pygame.display.set_mode((256,224),0,8)
		print "Done."
	def quitEmulator(self):
		print "Quitting PyGame..."
		pygame.quit()
		print "Done."
		print "Finally, exitting application."
		exit(0)
	def GetInput(self):
		for event in pygame.event.get():
			if event.type == KEYDOWN or event.type == KEYUP:
				if event.key == K_ESCAPE:
					self.finished = True
print  "Starting Space Invaders Machine EmulatorAlpha 1"
emu = Emulator()
emu.initEmulator()
emu.machine.SetFrameRate(60)
emu.machine.GetCPUType()
emu.machine.mem.LoadROM("invaders.rom")
emu.machine.WriteByte(24,0x3000) # Test Write to RAM at 0x3000
print "Printing 0x3000: %d" % emu.machine.cpu.mem.ram[0x3000]
while not emu.finished == True:
	emu.machine.cpu.Step()
	emu.GetInput()
emu.quitEmulator()