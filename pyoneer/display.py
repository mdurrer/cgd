import sys,pygame
class Display:
    def __init__(self):
        print ("Initialising Display")
        self.Surface = None
    def setVideo(self,resX,resY,depth):
        self.Surface = pygame.display.set_mode( (resX,resY),pygame.DOUBLEBUF|pygame.HWSURFACE,depth)