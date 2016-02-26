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

        if self.value in ('loser','winner'):
            pos = self.objs['patron2_pos'].pos
            self.player.rect.centerx,self.player.rect.bottom = pos
            
        if self.value == 'loser':
            self.script([
                (self.player.face,'patron2'),
                """patron2:Times up!""",
                """That matching game is tricky.  I'll have to try again.""",
                ])
        if self.value == 'winner':
            if 'ring' not in self.inv:
                self.player.face('patron2')
                self.sfx('item-find')
                self.got('ring')
                self.say("""patron2:Well, you win.  Here's the One Ring.""")
            else:
                self.player.face('patron2')
                self.say("""patron2:You win again.""")

    def use_fire(self):
#         self.script([
#             (self.player.walkto,'fire_pos'),
#             "I need a gorilla.",
#             (self.wait,),
#             "I need a gorilla.",
#             (self.say,"this is a test"),
#             (self.wait,),
#             (self.say,"patron1:get me more grog!"),
#             (self.wait,)
#             ])
#         
#         
        self.player.walkpos('fire',self._use_fire)
    def _use_fire(self):
        self.say("""Aye, this fire be mighty toasty and flame filled.""")
    
#     def cards_fire(self):
#         self.player.walkto('fire_pos',self._cards_fire)
#     def _cards_fire(self):
#         #self.inv.remove('cards')
#         self.item = 'fire'
#         self.say("""Gee, now I have a hadful of burning cards.  Good thing my pants are fireproof.""")

    def log_fire(self):
        self.player.walkpos('fire',self._log_fire)
    def _log_fire(self):
        self.sfx('fire')
        self.lost('log')
        self.got('fire')
        self.say("""Gee, now I have a burning log.  Good thing I wear fireproof gloves and asbestos pants.""")


    def use_sales(self):
        self.gold_sales()
        
    def gold_sales(self):
        self.player.walkpos('sales',self._gold_sales)
    def _gold_sales(self):
        if 'grog' not in self.inv:
            self.sfx('gold')
            self.say("""sales:Enjoy your grog.""")
            self.got('grog')
        else:
            self.say("""I already have a grog.""")
        
    def use_patron1(self):
        self.player.walkpos('patron1',self._use_patron1)
    def _use_patron1(self):
        self.say("""patron1:Leave me to my grog.""")
        
    def grog_patron1(self):
        self.player.walkpos('patron1',self._grog_patron1)
    def _grog_patron1(self):
        self.lost('grog')
        self.sfx('grog')
        self.say("""patron1:Ahhh, more grog.""")
        self.talkto(self._talk_patron1,'top')
    def _talk_patron1(self,topic):
        opts = []
        
        if topic == 'info':
            if 'magic' not in self.info:
                self.info.append('magic')
            topic = 'top'
        
        if topic == 'top':
            opts.append(("""What's the word on the street?""",[None,
                """patron1:The word on the street?""",
                """Aye, the word on the street.""",
                """patron1:Well, the word on the street is that Mr. Mumford at the Magical Museum sells some rather desirable magical items which aren't on public display.""",
                """Is that so?""",
                """patron1:Indeed it is.""",
                ],'info'))
            opts.append(("""Do you know how to beat the games at the arcade?""",[None,
                """patron1:Nay, I'm not much into games, but the fellow over there takes to the gaming quite regular.""",
                ],'top'))
                
            opts.append(("""Good talking to you.""",[None,
                """patron1:And you, sir.""",
                ],'exit'))
            
        return opts
        
    def use_patron2(self):
        self.player.walkpos('patron2',self._use_patron2)
    def _use_patron2(self):
        self.say("""patron2:Good evening.""")
        self.talkto(self._talk_patron2,'top')
        #self.say("""patron2:I'm not interested in you, I'm interested in grog.""")
        
#     def cards_patron2(self):
#         self.player.walkto('patron2_pos',self._cards_patron2)
#     def _cards_patron2(self):
#         #self.say("""patron2:I like cards.  But I like grog more.""")
        
    def grog_patron2(self):
        self.player.walkpos('patron2',self._grog_patron2)
    def _grog_patron2(self):
        self.lost('grog')
        self.sfx('grog')
        self.say("""patron2:Why how generous.  Please, take a seat.""")
        self.talkto(self._talk_patron2,'top')
    def _talk_patron2(self,topic):
        opts = []
        
        def getinfo():
            if 'game' not in self.info:
                self.info.append('game')
            
        def playcards():
            self.refresh()
            self.data['played'] = 1
            import cards
            g = cards.Cards(self.game,0,Room(self.game,None))
            self.goto(g)

        if topic == 'top':
            opts.append(("""Do you know how to beat the game at the arcade?""",[None,
                """patron2:Of course, you've just got to give it a swift kick when you put in your piece-of-eight and everything works fine.""",
                (getinfo,)],
                'top'))
                
            
            if 'played' not in self.data and 'cards' in self.inv and 'ring' not in self.inv:
                opts.append(("""Would you like to play cards?""",[None,
                    """patron2:Of course, as long as the stakes are high.""",
                    """I've got a heaping pile of gold.""",
                    """patron2:And I've got the One Ring.  We'll play a matching game.  You get 45 seconds to find all the matches.  Ready?""",
                    """I was born ready.""",
                    (playcards,),
                    ],
                    'top'))
            if 'played' in self.data:
                opts.append(("""Let's play cards again.""",[None,"""patron2:Okay.""",(playcards,),],'top'))
            
            opts.append(("""Have a good evening.""",[None],
                'exit'))
                
        return opts

    def mace_sales(self):
        self.player.walkpos('sales',self._mace_sales)
    def _mace_sales(self):
        self.script([
            """sales:I think you've had more than your limit tonight.  How about you get out and get some fresh air.""",
            (self.player.walkto,'exit_pos',self._use_exit),
            ])

    def mace_patron1(self):
        self.player.walkpos('patron1',self._mace_patron1)
    def _mace_patron1(self):
        self.say("""patron1:Leave me alone.""")

    def mace_patron2(self):
        self.player.walkpos('patron2',self._mace_patron2)
    def _mace_patron2(self):
        self.say("""patron2:Leave me alone.""")


    def use_exit(self):
        self.player.walkto('exit_pos',self._use_exit)
    def _use_exit(self):
        if 'ring' in self.inv and 'c_ring' not in self.info:
            self.goto('lair')
            return

        self.goto('mainst')
        




    
    



