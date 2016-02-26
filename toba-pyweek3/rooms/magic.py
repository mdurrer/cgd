import level

class Room(level.Room):
    def __init__(self,game,value):
        level.Room.__init__(self,game,__name__.split('.')[-1],value)
    
    def init(self):
        level.Level.init(self)
        
        self.music('inside')
        
        self.player = self.objs['player']
        for o in self.objs.values():
            if 'del_%s'%o.name in self.data: del self.objs[o.name]
            
        if 'cards' in self.inv:
            del self.objs['cards']
            
    def use_sales(self):
        self.player.walkpos('sales',self._use_sales)
    def _use_sales(self):
        self.say("""sales:How might I help you, sir?""")
        self.talkto(self.talk_sales,'top')
    
    def talk_sales(self,topic):
        if 'nag' not in self.data:
            self.data['nag'] = 0
        opts = []
        
        def naginc():
            self.data['nag'] += 1
            
        def getinfo():
            if 'skull' not in self.info:
                self.info.append('skull')
        
        if topic == 'top':
            opts.append((
                """Can you do any magic tricks?""",[None,
                """sales:This is not a magic trick store.""",
                ],'top'))
                
            if 'magic' in self.game.data['info'] and 'cloak' not in self.inv:
                if self.data['nag'] == 0:
                    opts.append((
                        """Word on the street is you've got more here than on display.""",[None,
                        """sales:I wouldn't believe everything you hear.""",
                        (naginc,),
                        ],'top',
                        ))
                if self.data['nag'] == 1:
                    opts.append((
                        """Reliable sources informed me you've got the goods in the back.""",[None,
                        """sales:Not all sources are as reliable as you might wish them to be.""",
                        (naginc,),
                        ],'top',
                        ))
                if self.data['nag'] > 1:
                    opts.append((
                        """I know you've got the merchanise.  Just show it to me.""",[None,
                        """sales:Very well.  I have many sacred items.  What are you looking for?""",
                        ],'goods',
                        ))
                
            opts.append((
                """Uh, never mind...""",[None,]
                ,'exit'))
                
        if topic == 'goods':
            opts.append((
                """I need a magic gorilla.""",[None,
                """sales:I'm sorry, I'm all out.""",
                ],'goods'))
            opts.append((
                """I need about fifty snake skins.  I'm making a pair of pants.""",[None,
                """sales:I don't sell textiles.""",
                ],'goods'))
            opts.append((
                """I'm looking for an Invisibility Cloak.  Do you have one?""",[None,
                """sales:Indeed, but I only trade my elite merchandise.  Tax purposes, you know.  I've needed a glow-in-the-dark skull for quite some time.  Maybe you can find one.""",
                (getinfo,),
                ],'goods'))
            opts.append((
                """Thanks for the .. information.""",[None,
                ],'exit'))
        
        return opts
        
    def skull_sales(self):
        self.player.walkpos('sales',self._skull_sales)
    def _skull_sales(self):
        if 'skull' in self.info:
            self.say("""sales:Excellent trade, sir.""")
            self.lost('skull')
            self.got('cloak')
            self.sfx('item-find')

    def use_cards(self):
        self.player.walkpos('sales',self._use_cards)
    def _use_cards(self):
        self.script([
            """player:I'd like to buy these cards.""",
            """sales:Three pieces-of-eight.  Thank you kindly.""",
            (self._get_cards,)
            ])
    def _get_cards(self):
        del self.objs['cards']
        self.sfx('gold')
        self.got('cards')
        
    def use_mace(self):
        self.player.walkpos('sales',self._use_mace)
    def _use_mace(self):
        self.script([
            """player:I'd like to buy this lovely mace.""",
            """sales:Twelve pieces-of-eight.  Thank you kindly.""",
            (self._get_mace,),
            ])
    def _get_mace(self):
        del self.objs['mace']
        self.data['del_mace'] = 1
        self.sfx('gold')
        self.got('mace')
        
    def mace_sales(self):
        self.player.walkpos('sales',self._mace_sales)
    def _mace_sales(self):
        self.say("""sales:This is a house of mystery, not a play ground.  Please put that artifact away immediately.""")

        
    def use_exit(self):
        self.player.walkto('exit_pos',self._use_exit)
    def _use_exit(self):
        if 'cloak' in self.inv and 'c_cloak' not in self.info:
            self.goto('lair')
            return

        self.goto('mainst')
        





    
    



