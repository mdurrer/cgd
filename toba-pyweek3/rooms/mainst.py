import level

class Room(level.Room):
    def __init__(self,game,value):
        level.Room.__init__(self,game,__name__.split('.')[-1],value)
    
    def init(self):
        level.Level.init(self)
        
        self.music('outside')
        
        self.player = self.objs['player']
        for o in self.objs.values():
            if 'del_%s'%o.name in self.data: del self.objs[o.name]
        if self.value != None:
            pos = self.objs['%s_pos'%self.value].pos
            self.player.rect.centerx,self.player.rect.bottom = pos
            
    def use_swamp(self):
        if 'potion' not in self.inv and 'potion' not in self.info:              
            self.player.walkto('swamp_pos',self._use_swamp)
        else:
            self.say("""There's no going back now!""")
    def _use_swamp(self):
        self.goto('swamp')

    def use_magic(self):
        if 'potion' not in self.inv and 'potion' not in self.info:              
            self.player.walkto('magic_pos',self._use_magic)
        else:
            self.say("""I'm girded to defeat evil already!""")
    def _use_magic(self):
        self.goto('magic')
        
    def use_arcade(self):
        if 'potion' not in self.inv and 'potion' not in self.info:            
            self.player.walkto('arcade_pos',self._use_arcade)
        else:
            self.say("""Not now!  Conquer evil first, games later!""")
    def _use_arcade(self):
        self.goto('arcade')
        
    def use_bar(self):
        if 'potion' not in self.inv and 'potion' not in self.info:
            self.player.walkto('bar_pos',self._use_bar)
        else:
            self.say("""No time for grog!""")
    def _use_bar(self):
        self.goto('bar')
    
    def use_lair(self):
        self.player.walkto('lair_pos',self._use_lair)
    def _use_lair(self):
        if 'potion' not in self.info:
            self.say("""I'm not going near that lair until I have the ultimate invisibility potion in my gullet!""")
            return
        self.goto('lair')
    
    def potion_player(self):
        self.player.src = 'iplayer'
        self.player.load()
        self.info.append('potion')
        self.lost('potion')
        self.sfx('potion')
        