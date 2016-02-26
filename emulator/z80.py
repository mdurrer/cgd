import os,sys,pygame,emulator,processor,rom,zxs,ram,video
from pygame.locals import *
class Z80(emulator.Emulator):
	system = "ZX Spectrum"
	def __init__(self,systemarg):
		#emulator.Emulator.__init__(self)
		if (systemarg != ""):
			self.system = systemarg
			print "Initializing instance of " + self.system +"..."
			self.ROMComponent = rom.ROM(romsize=32000)
			self.CPUComponent = zxs.ZXS_CPU("Z80")
			self.RAMComponent = ram.RAM(size=0xffff)
			self.VideoComponent = video.Video(self)# Main Resolution of ZX Spectrum classic
			self.Running = False

	def runZ80(self):
		self.Running = True
		print "Running CPU!"
	def haltZ80(self):
		self.Running = False
		print "Stopped your CPU!"
	def handleInput(self):
		for event in pygame.event.get():
			if(event.type == KEYDOWN):
				if (event.key == K_f):
					pygame.display.toggle_fullscreen()
				elif (event.key == K_ESCAPE):
					print "Input found!"
					print "Escape pressed."
					print "Exitting..."
					self.haltZ80()
				else:
					print "Input found: " + str(event.key)
					print 
			elif (event.type == QUIT):
				print "Asked to exit, thus, I'm exitting."
				self.haltZ80()
			elif (event.type == MOUSEMOTION):
				mousepos = pygame.mouse.get_pos()
				print "Mouse moved to: X=" + str(mousepos[0]) + ", Y=" + str(mousepos[1])
			elif (event.type == MOUSEBUTTONDOWN):
				mousepos = pygame.mouse.get_pos()
				print "Mouse Button pressed at: X=" + str(mousepos[0]) + ", Y=" + str(mousepos[1])
				

