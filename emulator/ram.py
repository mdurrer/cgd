import os
import sys
import pygame

class RAM(object):
	def __init__(self, size=0):
		print "Initializing " + str(size) + " bytes of RAM..."
		self.data = [None] * size
		print "Allocated " + str(len(self.data)) + " bytes for RAM!"
		eightbitcounter = 0
		for counter in range(65336):
				self.data[counter] = eightbitcounter
				eightbitcounter += 1
				if(eightbitcounter >= 256):
					eightbitcounter = 0
				print "counter: " +hex(counter) + " | eightbitcounter: "+ hex(eightbitcounter)