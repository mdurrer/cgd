# __________________________________________
# | Space Invaders Emulator                          
# | by Michael Durrer                                  
# | Arcade Machine class / arcade.py         
# |_________________________________________
import os,sys,pygame
import cpu,memory
class Arcade:
	def __init__(self):
		print "Initializing Variables..."
		self.framerate = None
		self.cycles_per_interrupt = None
		print "Initializing Arcade Machine..."
		self.screen = None  # Screen 
		self.mem = memory.Memory(0x4000)
		self.cpu = cpu.Intel8080(self.mem)
	def __del__(self):
		print "Deleting Arcade Machine..."
	def GetCPUType(self):
		return self.cpu.type
	def SetFrameRate(self,	 count):
		self.cycles_per_interrupts =  (2000000 / (2*count)); 
		self.framerate = count
		print "Frame rate set to " + str(count)		
	def Run(self):
		self.cpu.step()
	def LoadROM(self,filename):
		self.ROMHandle = open(filename,"rb")
		for i in range(0,0x2000):
			self.mem[i] = self.ROMHandle.read(1)
		if self.ROMHandle.tell() < 0x2000:
			print "Couldn't load file %s into RAM" % filename
		else:
			print "%s Bytes loaded into RAM at 0x0000 from invaders.rom" % self.ROMHandle.tell()
	def ReadByte(self,address):
		if address > 0x4000:
			return 0x00
		else:
			return self.cpu.mem.ram[address]
	def WriteByte(self,value,address):
		if value > 0xff:
			value = 0xff
		if value < 0x00:
			value = 0x00
		if address < 0x2000:
			address |= 0x1fff
		else:
			pass
			self.cpu.mem.ram[address] = value
	def Step(self):
		self.cpu.Step()
		#print "Wrote value %d to address %d" % value, address