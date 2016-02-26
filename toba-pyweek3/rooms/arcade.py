import level

class Room(level.Room):
    def __init__(self,game,value):
        level.Room.__init__(self,game,__name__.split('.')[-1],value)
    
    def init(self):
        level.Level.init(self)
        
        self.music('arcade')
        
        self.player = self.objs['player']
        for o in self.objs.values():
            if 'del_%s'%o.name in self.data: del self.objs[o.name]
            
        if self.value in ('crash','loser','winner'):
            pos = self.objs['game_pos'].pos
            self.player.rect.centerx,self.player.rect.bottom = pos
            
        if self.value == 'crash':
            self.say("""I can never win this game, it keeps crashing on me!""")
            self.data['game_busted'] = 1
            
        if self.value == 'loser':
            self.say("""I can't believe I just lost.  I should try again.""")
            
        if self.value == 'winner':
            self.sfx('nibbles-winner')
            self.say("""Yes!  I won!""")
            if 'tokens' not in self.inv and 'tokens' not in self.info:
                self.got('tokens')
                self.info.append('tokens')
                
        self.smoke = self.objs['smoke']
        del self.objs['smoke']
        
        self.glass = self.objs['glass']
        if 'claw_broken' not in self.data:
            del self.objs['glass']

    def use_game(self):
        self.player.walkpos('game',self._use_game)
    def _use_game(self):
        self.refresh()
        if 'game' not in self.info:
            import nibbles
            g = nibbles.Nibbles(self.game,0,Room(self.game,'game'))
            self.goto(g)
        else:
            import nibbles
            g = nibbles.Nibbles(self.game,1,Room(self.game,'game'))
            self.goto(g)
    
    def tokens_sales(self):
        self.player.walkpos('sales',self._tokens_sales)
    def _tokens_sales(self):
        if 'chicken' in self.objs:
            self.lost('tokens')
            self.got('chicken')
            self.sfx('chicken')
            self.say("""sales:Here's your chicken, may it bring your life happiness.""")
            del self.objs['chicken']
            self.data['del_chicken'] = 1
        else:
            self.say("""sales:Sorry, man, I'm out of chickens.""")
        
        
    def use_claw(self):
        self.player.walkpos('claw',self._use_claw)
    def _use_claw(self):
        if 'claw_broken' not in self.data:
            self.say("""Look, you can't win this games unless you literaly smash the machine open and take what's inside.""")
        else:
            self.say("""It's terrible the way people vandalize these games.""")
        
    def mace_claw(self):
        self.player.walkpos('claw',self._mace_claw)
    def _mace_claw(self):
        if 'claw_broken' not in self.data:
            if 'sales' in self.objs:
                self.say("""sales:People, just because you don't like the game, doesn't mean nobody else does.  Just leave it alone, okay?""")
            else:
                self.sfx('arcade-claw')
                self.data['claw_broken'] = 1
                self.objs['glass'] = self.glass
                self.got('device')
                self.say("""Hey, no ship this size has a Cloaking Device!""")
        else:
            self.say("""Its already been trashed.""")
    
    def use_trash(self):
        self.player.walkpos('trash',self._use_trash)
    def _use_trash(self):
        self.say("""Oh my goodness!  The trashcan is full of...  Paper waste products!  A.K.A. Trash!""")
        
    
    def fire_trash(self):
        self.player.walkpos('trash',self._fire_trash)
        self.lost('fire')
    def _fire_trash(self):
        self.sfx('arcade-alarm')
        self.objs['smoke'] = self.smoke
        self.objs['sales'].rename('sales_')
        self.say("""sales_:Fire!  Run for your lives!""")
        self.objs['sales_'].walkto('exit_pos',self._fire_sales_exit)
    def _fire_sales_exit(self):
        del self.objs['sales_']
        
    def use_chicken(self):
        if 'sales' in self.objs:
            self.player.walkpos('sales',self._use_chicken)
        else:
            self.player.walkpos('chicken',self._use_chicken)
    def _use_chicken(self):
        if 'sales' in self.objs:
            self.script([
                """How much for the rubber chicken?""",
                """sales:No man, that chicken isn't for sale.  Its an honor and privilage bestoed only upon those who win the games.""",
                """sales:You win 100 prize tokens, you get the chicken.""",
                ])
        else:
            self.say("""I'd better not take it.  Stealing is wrong.""")
        
    def use_sales(self):
        self.player.walkpos('sales',self._use_sales)
    def _use_sales(self):
        self.say("""sales:Yo.""")
        self.talkto(self.talk_sales,'top')
        
    def mace_sales(self):
        self.player.walkpos('sales',self._mace_sales)
    def _mace_sales(self):
        self.say("""sales:Chief, that's not cool.  Arcades are places for good wholesome family fun.  Keep the violence at home.""")
        
    def grog_sales(self):
        self.player.walkpos('sales',self._grog_sales)
    def _grog_sales(self):
        self.say("""sales:Hey, not while I'm on the job.  Nothing would budge me from my post unless, uh, the building caught fire, or uh, it started to sink into the ground, or something.""")
        
    def talk_sales(self,topic):
        opts = []
        
        if topic == 'top':
            if 'game_busted' in self.data:
                opts.append((
                    """That game is broken.""",["""That game is broken.  It keeps saying "SEGMENTATION FAULT" on the screen.""",
                    """sales:Let the buyer beware, dude.""",
                    ],'top'))
                
            if 'claw_broken' not in self.data:
                opts.append((
                    """Those claw games are a total rip off.""",[None,
                    """sales:Dude, not everyone has the skills to be a claw master.  Don't be a sore loser.""",
                    ],'top'))
            else:
                opts.append((
                    """Gee, it's a pity that someone broke the claw.""",[None,
                    """sales:Yeah man, someone's a poor sport.""",
                    ],'top'))
                
                
            opts.append((
                """This place is pretty new-fangled.""",[None,
                """sales:Yeah, we try to bring all modern conveniences to the 1780s as best we can.""",
                """I can see that.  Electric lighting, video games, the claw... You've got it all.""",
                """sales:And hey, we believe in safety too!  We've got a first rate fire alarm system in this establishment.""",
                """Nice, nice.""",
                """sales:So, never fear.  If this place begins down the firey path to destruction, even if you're deeply involved in one of our games, you'll have fair warning.""",
                """I feel safer already.""",
                ],'top'))
                
            opts.append((
                """Uh, never mind...""",[None,
                """sales:Keep it real, man.""",
                ],'exit'))
        
        return opts

        
    def use_exit(self):
        return self.player.walkpos('exit',self._use_exit)
    def _use_exit(self):
        if 'device' in self.inv and 'c_device' not in self.info:
            self.goto('lair')
            return

        self.goto('mainst')
        





    
    



