import os,sys,socket,string, irclib

class IRCBot:

    def __init__(self, config=None): # config must be a class / an object
        self.botName = "Zion IRC Bot"
        self.version = "0.1 Alpha"
        self.nick = "ZionBot"
        self.network = "irc.euirc.net"
        self.port =  6667
        self.channel = ["#geschlossene" q,"#df"]
        self.irc = None
        print("Initializing", self.botName, " in Version",self.version)
    def changeNick(self, newName):
        pass

    
    def connect(self,network=None,port=None,nick=None,channel=None):
        return True
 
