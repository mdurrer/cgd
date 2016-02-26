import pygame,sys
from pygame.locals import *
				
class Point:
	def __init__(self, x=None,y=None,z=None):
		self.coords = (x,y,z)
	def AddVectorToPoint(self, v):
		self.coords = ((self.coords[0]+v.coords[0]), (self.coords[1]+v.coords[1]), (self.coords[2]+v.coords[2]))
	def SubtractVectorFromPoint(self,v):
		self.coords((self.coords[0]-v.coords[0]), (self.coords[1]-v.coords[1]),(self.coords[2]-v.coords[2]))
	def SubtractPointFromPoint(self,p):
                return Vector((self.coords[0]-p.coords[0]), (self.coords[1]-p.coords[1]),(self.coords[2]-p.coords[2]))
	def drawPoint():
		pass
        def getCoords(self):
                return self.coords
class Vector:
	def __init__(self,x,y,z):
		self.coords = (x,y,z)
	def AddVectorToVector(self, Vector):
		pass
	def SubtractVectorFromVector(Vector):
                pass	

if __name__ == "__main__":
                
        pygame.init()

        Surface = pygame.display.set_mode((640,480),0,32)
        pygame.display.set_caption("3D Engine Example")

        Surface.fill((255,0,0))
        a = Point(2,3,3)
        print (a.getCoords())
        b = Vector(2,3,4)
        a.AddVectorToPoint(b)
        print (a.getCoords())
        while True:
                for event in pygame.event.get():
                        if event.type == QUIT:
                                pygame.quit()
                                sys.exit()
                        if event.type == KEYDOWN:
                                if event.key == pygame.K_ESCAPE:
                                        pygame.quit()
                                        sys.exit()
				
