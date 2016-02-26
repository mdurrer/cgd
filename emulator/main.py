import sys
import os
import pygame
from emulator import *
from z80 import *

if __name__ == '__main__':

	try:
		import psyco
		psyco.log()
		psyco.full()
	except ImportError:
		print "Couldn't load Psyco - The emulator will run much slower than it should..."

	#e = emulator.Emulator(systemarg="Z80")
	machine = Z80("Z80")
	print machine
	print "Initializing Pygame."
	pygame.init()
	machine.loadROM("spectrum.rom")
	machine.VideoComponent.setVideo(256,192,0)
	print "Main loop starting!"
	machine.runZ80()
	while machine.Running == True:
		machine.CPUComponent.B = 0x20
		machine.CPUComponent.C = 0xF0
		#print machine.CPUComponent.getBC()
		print machine.RAMComponent.data[0xff50]
		machine.handleInput()
		pygame.display.flip()
##	fh.write(machine.ROMComponent.fileContent)
##	fh.close()