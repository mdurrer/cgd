import os
import sys
import pygame

class ROM(object):
	filename = ""
	romsize = 0
	def __init__(self, filename="",romsize=0):
##		if (filename == "" and romsize==0):
##			print "Can't init rom, you must give me some data to work with..."
##		elif(filename != ""):
##			try:
##				self.fileHandler = open(filename,"rb")
##			except IOError:
##				print "Can't open ROM-file " + str(filename) + ", quitting..."
##				sys.exit(1)
##			self.fileContent = ""
##			self.romsize = 0
##			self.fileContent = self.fileHandler.read()
##			self.romsize = self.fileHandler.tell()
##			print "Loading system-ROM file..."
##			print "Allocated " + str(self.romsize) + " bytes for " + filename + "."
##			self.fileHandler.close()
##		else:
		print "Allocating " + str(romsize) + " bytes for a new ROM..."
	
	def loadROMFile(self,filename):
		try:
			self.fileHandler = open(filename)
		except IOError:
			print "Can't open ROM-file " + str(filename)
			sys.exit(1)
		print "Loading system-ROM file..."
		self.fileContent = self.fileHandler.read()
		self.romsize = self.fileHandler.tell()
		print "Allocated " + str(self.romsize) + " bytes for " + filename + "."
		self.fileHandler.close()
		print "Loaded system-ROM successfully!"