import level

class Room(level.Room):
    def __init__(self,game,value):
        level.Room.__init__(self,game,__name__.split('.')[-1],value)
    
    def init(self):
        level.Level.init(self)
        
        self.music('swamp')
        
        self.player = self.objs['player']
        for o in self.objs.values():
            if 'del_%s'%o.name in self.data: del self.objs[o.name]
        if self.value not in ('title',None):
            pos = self.objs['%s_pos'%self.value].pos
            self.player.rect.centerx,self.player.rect.bottom = pos
            
        else: #intro sequence..
            self.script([
                (self.player.walkpos,'lady',),
                (self.wait,),
                """player:I'm ready to save Goat Island.""",
                """lady:That is good, Mr. Wiljafjord.  I am ready to help you.""",
                """player:What can I do to stop Lord Tarbukas?""",
                """lady:Lord Tarbukas' "Secret Lair" is heavily guarded as you know.  However, in that is its greatest weakness.""",
                """lady:If you are able to slip past the guard it is a simple matter of pressing the self-destruct button and the evil Lord's Lair will crumble.""",
                """player:Well, great.  I'm glad I'm so well equipt to challenge the guard.""",
                """lady:To pass the guard you must be invisible.  Fortunately for you, there are ways of becoming invisible.""",
                """player:Great, I'll just find one of those.""",
                """lady:You must become *very* invisible.  There are three ways to become invisible.""",
                """lady:One: The Invisibility Cloak.  Two: The One Ring.  Three: The Cloaking Device.""",
                """player:Why is the One Ring number Two?""",
                """lady:None of these ways are sufficient as each has its weakness.  You must bring these items to me.""",
                """lady:I will grind these items into a fine powder to create for you the Ultimate Invisibility Potion.""",
                """lady:Then you will be able to easily sneak past the guard and destroy Lord Tarbukas' "Secret Lair." """,
                """player:Glad it sounds so easy...""",
                ])
       

    def use_shack(self):
        self.player.walkpos('lady',self._use_shack)
    def _use_shack(self):
        pass
    
    def use_skull(self):
        self.player.walkpos('lady',self._use_skull)
    def _use_skull(self):
        self.script([
            """player:How much for this swell glow-in-the-dark skull?""",
            """lady:Usually I'd let one go for about 23 pieces of eight.  But I'm low on rubber chickens lately.  I'd much rather trade if you can find one.""",
            ])
    
    def use_log(self):
        self.player.walkpos('log',self._use_log)
    def _use_log(self):
        if 'log' not in self.inv and 'fire' not in self.inv:
            self.got('log')
            self.sfx('get')
        elif 'log' in self.inv:
            self.say("""I'm already carrying around a load of wood!""")
        elif 'fire' in self.inv:
            self.say("""I'm already hauling around a burning load of wood!""")
        
    def chicken_lady(self):
        self.player.walkpos('lady',self._chicken_lady)
    def _chicken_lady(self):
        self.say("""lady:Thank you.""")
        self.lost('chicken')
        self.got('skull')
        self.sfx('chicken')
        del self.objs['skull']
        self.data['del_skull'] = 1
        
    def use_lady(self):
        self.player.walkpos('lady',self._use_lady)
    def _use_lady(self):
        self.say("""lady:Ahh, Mr. Wiljafjord, how are you fairing in your quest?""")
        self.talkto(self.talk_lady,'top')
    
    def talk_lady(self,topic):
        opts = []
        
        if topic == 'top':
            opts.append((
                """What were the three invisibility items again?""",[None,
                """lady:One: The Invisibility Cloak.  Two: The One Ring.  Three: The Cloaking Device.""",
                """Ah, yes.""",
                ],"top"))
                
            opts.append((
                """What are the individual weaknesses of the three items?""",[None,
                """lady:The Invisibility Cloak is not a perfect invisibilty token because it is barely hides your feet.  And more often than not, it falls off anyways.""",
                """lady:The One Ring is no good because those who would wear the One Ring can barely see where they are going through their own weeping.""",
                """lady:The Cloaking Device is useless because it is inconveniently heavy.""",
                """But hey...""",
                """lady:Admit it, even a tough guy like you wouldn't want to carry around a eighty-five pound Cloaking Device all day.""",
                ],"top"))
                
            opts.append((
                """Well, off to find those items!""",[None,
                """lady:My blessings go with you, Mr. Wiljafjord.""",
                ],'exit'))
        
        return opts

    def cloak_lady(self):
        self.player.walkpos('lady',self._cloak_lady)
    def _cloak_lady(self):
        self.lost('cloak')
        self.info.append('g_cloak')
        self.sfx('get')
        scr = ["""lady:Yes, the Invisibility Cloak."""]
        scr.extend(self.ucheck())
        self.script(scr)
        
    def ring_lady(self):
        self.player.walkpos('lady',self._ring_lady)
    def _ring_lady(self):
        self.lost('ring')
        self.info.append('g_ring')
        self.sfx('get')
        scr = ["""lady:Ahh, the One Ring."""]
        scr.extend(self.ucheck())
        self.script(scr)
        
    def device_lady(self):
        self.player.walkpos('lady',self._device_lady)
    def _device_lady(self):
        self.lost('device')
        self.info.append('g_device')
        self.sfx('get')
        scr = ["""lady:Mmmmn, the Cloaking Device."""]
        scr.extend(self.ucheck())
        self.script(scr)
    
    def ucheck(self):
        if 'g_cloak' in self.info and 'g_ring' in self.info and 'g_device' in self.info:
            self.got('potion')
            return [
                """lady:At last!  We have all elements needed to create the Ultimate Invisibility Potion.""",
                (self.sfx,'item-find'),
                """lady:Take the potion!  Feel the power!""",
                """Oh, I feel it.""",
                """lady:Now go!  Defeat Lord Tarbukas and free us from his reign of terror!""",
                ]
        return []

    def use_mainst(self):
        self.player.walkto('mainst_pos',self._use_mainst)
    def _use_mainst(self):
        self.goto('mainst')
        
