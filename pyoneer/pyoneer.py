import os,sys,pygame,display

class Pyoneer:
    def __init__(self):
        print ("Initialising Pyoneer-Engine")
        self.Display = display.Display()
        self.Version = 0.1
        self.Name = "Pyoneer Adventure Engine"
        self.Running = 0
        self.scriptFile = ""
    def loadScript(self,filename):
        self.scriptFile = open(filename)
        self.scriptFile.read() 
    def play(self):
        self.Running = 1    
if __name__== '__main__':
    engine = Pyoneer()
    print "Running " + engine.Name + " Version: ", str(engine.Version)
    engine.Display.setVideo(800,600,0)
    engine.play()
while engine.Running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            print ("Quitting PyGame")
            sys.exit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                engine.Running = 0
            elif event.key == pygame.K_f:
                pygame.display.toggle_fullscreen()