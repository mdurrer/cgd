import level

class Room(level.Room):
    def __init__(self,game,value):
        level.Room.__init__(self,game,__name__.split('.')[-1],value)
    
    def init(self):
        level.Level.init(self)
        
        self.music('lair')
        
        self.player = self.objs['player']
        for o in self.objs.values():
            if 'del_%s'%o.name in self.data: del self.objs[o.name]
            
        
        if self.value == 'title':
            self.script([
                """                   """,
                """The evil Lord Tarbukas has oppressed the people for far too long.""",
                """Colonel Wiljafjord is the final hope for happiness in the land.""",
                """If only he isn't too late ...""",
                """                   """,
                (self.goto,'swamp','title'),
                ])
            return
                
        
        def codegame():
            import codes
            g = codes.Codes(self.game,0,Room(self.game,None))
            self.goto(g)
        if self.value == 'mainst': #we're going in for the end game...
            self.script([
                """                """,
                """Gee, the guards can't even see me.""",
                """Sweet!""",
                """Alright, I'm in Lord Tarbukas' "Secret Lair." """,
                (codegame,),
                ])
            return
            
        if self.value == 'loser':
            self.script([
                """            """,
                """Man, that's tough security.  I'll try again.  I'm the last hope.""",
                (codegame,),
                ])
            return
            
        if self.value == 'winner': #we just won
            import ending
            self.script([
                (self.sfx,'red',-1),
                """            """,
                """I better split before this place blows!""",
                """                     """,
                """lackey:Sire, ah, someone hit the SELF-DESTRUCT BUTTON.""",
                """tarbukas:So get down there and un-press it!!""",
                """lackey:Well, see, that's the thing about buttons.  You can't un-press them.""",
                """tarbukas:YOU MEAN TO SAY, THAT I SPENT OVER--""",
                (self.sfx_stop,'red'),
                (self.goto,ending.Ending(self.game)),
                ])
            return
        
        
        if 'count' not in self.data:
            self.data['count'] = 0
        self.data['count'] += 1
        
        scr = ["""                 """]
        c = self.data['count']
        if c == 1:
            scr.append("""Meanwhile at Lord Tarbukas' "Secret Lair...\"""")
        elif c == 2:
            scr.append("""Over the river and through the woods...""")
        elif c == 3:
            scr.append("""Meanwhile, back at the ranch...""")
        scr.append("""              """)
        
        if 'ring' in self.inv and 'c_ring' not in self.info:
            self.info.append('c_ring')
            scr.extend([
                """tarbukas:Why has Wiljafjord been allowed to find the One Ring?!""",
                """lackey:Oh, you know... Ah...""",
                """tarbukas:No I don't know!  This is all your fault!""",
                """lackey:But master, it will be remedied.""",
                """tarbukas:It had better be...""",
                (self.goto,'mainst',self.value),
                ])
        
        if 'cloak' in self.inv and 'c_cloak' not in self.info:
            self.info.append('c_cloak')
            scr.extend([
                """lackey:Umn, Lord Tarbukas...""",
                """tarbukas:What?!""",
                """lackey:It appears that Wiljafjord has located the Invisibility Cloak, sort of.""",
                """tarbukas:Wiljafjord must pay for his insubordinate behavior!""",
                """lackey:Yes master.""",
                (self.goto,'mainst',self.value),
                ])
        
        if 'device' in self.inv and 'c_device' not in self.info:
            self.info.append('c_device')
            scr.extend([
                """tarbukas:Lackey, get in here.  He's found the Cloaking Device!""",
                """lackey:Dear me, oh my.""",
                """tarbukas:I should dispose of you!  I thought you said you hid all the sacred objects!""",
                """lackey:But I did!  I did!  I did!  I did!""",
                """tarbukas:But obviously not good enough!""",
                """tarbukas:Typical incompetence.""",
                (self.goto,'mainst',self.value),
                ])
            
        self.script(scr)
        return
    
    
    




