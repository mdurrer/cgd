#!/usr/bin/env python
import os,sys,pygame,board,stone
from pygame.locals import *
class Dame:
	Running = None
	def __init__(self):
		print "Initializing Dame"
		self.Screen = None
		self.Board = None
		#self.Stones = None
		self.GameClock = None
		self.Font = None
	def main(self):
		pygame.init()
		self.setFont()
		self.GameClock = pygame.time.Clock()
		print "Starting Main Routine"
		self.Running=True
		print "Initializing Display at 800x800"
		pygame.display.set_caption("PyDame - Multiplayer Modus")
		self.Screen = pygame.display.set_mode((800,800),DOUBLEBUF|HWSURFACE)
		self.Board = board.Board("images/10x10board.png",10)
		self.Board.initStones(0,1)
		#self.stone.St
		while self.Running:
			for event in pygame.event.get():
				if event.type == KEYDOWN:
					if event.key == K_ESCAPE:
						self.Running = False
					elif event.key == K_f:
						pygame.display.toggle_fullscreen()
				if event.type == QUIT:
					self.Running = False
			
			self.GameClock.tick(60)
			self.Screen.fill((255,255,255	))
			self.Screen.blit(self.Board.image,(0,0))
			self.Board.Stones.update()
			self.Board.Stones.draw(self.Screen)
			self.displayFPS(10,10,(255,0,0))
			pygame.display.flip()
	def setFont(self,fontname=None, size=22):
		self.Font = pygame.font.Font(fontname,size)
	def displayFPS(self,x,y,color):
		FPSoutput = self.Font.render("Frames per seconds: " + str(round(self.GameClock.get_fps(),2)),False,color)
		self.Screen.blit(FPSoutput,(x,y))
if __name__ == "__main__":
	print "Starting PyDame"	
	game = Dame()
	game.main()
	pygame.quit()
	print "Exitting PyDame"
	sys.exit(1)