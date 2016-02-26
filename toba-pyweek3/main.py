import sys
import os

import pygame
from pygame.locals import *

from cnst import *

from pgu import engine,timer

#gotta import everything just to be sure

import rooms.arcade
import rooms.bar
import rooms.lair
import rooms.magic
import rooms.mainst
import rooms.swamp

def toggle_fullscreen():
    screen = pygame.display.get_surface()
    tmp = screen.convert()
    caption = pygame.display.get_caption()
    
    w,h = screen.get_width(),screen.get_height()
    flags = screen.get_flags()
    bits = screen.get_bitsize()
    
    pygame.display.quit()
    pygame.display.init()
    
    screen = pygame.display.set_mode((w,h),flags^FULLSCREEN,bits)
    screen.blit(tmp,(0,0))
    pygame.display.set_caption(*caption)
 
    pygame.key.set_mods(0) #HACK: work-a-round for a SDL bug??
    
    return screen

class Game(engine.Game):
    def init(self):
        v = 0
        if '-full' in sys.argv:
            v |= FULLSCREEN
        self.screen = pygame.display.set_mode((SW,SH),v)
        pygame.display.set_caption('Colonel Wijafjord and the Tarbukas Tyranny')
        
        if (v&FULLSCREEN)!=0:
            pygame.time.wait(2000)
        
        self.timer = timer.Timer(FPS)
        
        pygame.font.init()
        self.font = pygame.font.Font(os.path.join('data','teen.ttf'),20)
        
        try:
            if '-nosound' in sys.argv:
                0/0
            
            # stop crackling sound on some windows XP machines.
            if os.name == 'posix' or 1:
                try:
                    pygame.mixer.pre_init(44100,-16,2, 1024 * 3)
                except:
                    pygame.mixer.pre_init()
            else:
                pygame.mixer.pre_init()

            pygame.mixer.init()
            print 'mixer initialized'
        except:
            import traceback; traceback.print_exc()
            print 'mixer not initialized'
            
        self._sfx = {}
        self._music = None
        
    def sfx(self,name,loops=0):
        if not pygame.mixer.get_init(): return
        
        if name not in self._sfx:
            for ext in ['wav','ogg']:
                try:
                    self._sfx[name] = pygame.mixer.Sound(os.path.join("data","sfx","%s.%s"%(name,ext)))
                    break
                except:
                    pass
        
        if name not in self._sfx:
            print 'sfx: cannot find %s'%name
            return
        
        self._sfx[name].play(loops)
        
    def sfx_stop(self,name):
        if name in self._sfx:
            self._sfx[name].stop()
        
    def music(self,name):
        if not pygame.mixer.get_init(): return
        
        if self._music == name:  return
        
        pygame.mixer.music.stop()
        self._music = None
        
        for ext in ['wav','ogg']:
            try:
                pygame.mixer.music.load(os.path.join("data","music","%s.%s"%(name,ext)))
                pygame.mixer.music.play(-1)
                self._music = name
                break
            except:
                #import traceback; traceback.print_exc()
                pass
        
        if not self._music:
            print 'music: cannot find %s'%name
        
    def reset(self):
        self.data = {}
        self.data['inv'] = ['gold']
        self.data['info'] = []
        
    def tick(self):
        self.timer.tick()
        
    def event(self,e):
        if e.type is QUIT:
            self.state = engine.Quit(self)
            return True
        if e.type is KEYDOWN and e.key == K_F10:
            self.screen = toggle_fullscreen()
            return True
            
        pass
    
    
if __name__ == '__main__':
    
    game = Game()
    game.reset()
    
    # import rooms.test
    # l = rooms.test.Room(game,None)
    
    # import rooms.mainst
    # l = rooms.mainst.Room(game,None)
    
    #import nibbles
    #game.run(nibbles.Nibbles(game,0,None))
    
#     game.data['inv'].extend(['ring','device','cloak'])
#     game.data['info'].extend([])
#     import rooms.swamp
#     l = rooms.swamp.Room(game,None)
    
#     game.data['inv'].extend(['potion'])
#     game.data['info'].extend([])
#     import rooms.mainst
#     l = rooms.mainst.Room(game,'lair')
#     
    # game.data['inv'].extend([])
    # game.data['info'].extend([])
    # import rooms.lair
    # l = rooms.lair.Room(game,None)
    
    import title
    l = title.Title(game)
    
    # game.data['inv'].extend([])
    # game.data['info'].extend([])
    # import rooms.arcade
    # l = rooms.arcade.Room(game,None)
    
    # import rooms.bar
    # game.data['inv'].extend(['cards'])
    # game.data['info'].extend([])
    # l = rooms.bar.Room(game,None)
    
    
    game.run(l)