import os,sys,pygame
from rom import *
class Emulator:
	system = ""
	mostProbable = "(Almighty Emulator thinks, it's a Z80)"
	textFragment = " a "
	def __init__(self,systemarg=""):
		if (str(systemarg) == ""):
			self.system = "unknown"
		else:
			self.system = systemarg
			if (self.system == "unknown"):
				print "Initializing new " + self.system + self.mostProbable + " Emulator instance..."
			else:
				print "Initializing new " + self.system + " Emulator instance..."
		self.ROMComponent = ROM(romsize=32000)
	def __str__(self):
		self.textFragment = " a "
		if (str(self.system).startswith("a") | str(self.system).startswith("e") | str(self.system).startswith("i") | str(self.system).startswith("o") | str(self.system).startswith("u")):
			self.textFragment = " an "
		return "This is" + self.textFragment + " " + self.system + " " + " system."
	def loadROM(self,path=""):
		ROMsize = os.path.getsize(path)
		print "Size is: " + str(ROMsize)
		#self.ROMComponent = ROM(romsize=ROMsize)
		self.ROMComponent.loadROMFile(path)