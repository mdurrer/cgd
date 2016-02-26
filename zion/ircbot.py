import os,sys,socket,string

class IRCBot:

    def __init__(self, config=None): # config must be a class / an object
        self.botName = "Zion IRC Bot"
        self.version = "0.1 Alpha"
        self.nick = "ZionBot"
        self.network = "irc.euirc.net"
        self.port =  6667
        self.channel = ["#geschlossene","#df"]
        self.irc = None
        print("Initializing", self.botName, " in Version",self.version)
    def changeNick(self, newName):
        pass

    
    def connect(self,network=None,port=None,nick=None,channel=None):
        if network==None:
            network = self.network
        if port==None:
            port=self.port
        if channel==None:
            channel = self.channel
        if nick==None:
            nick = self.nick
        self.irc = socket.socket(socket.AF_INET,  socket.SOCK_STREAM)
        self.irc.connect((network,port))
        self.irc.recv(4096)
        self.irc.send(b'NICK ' + bytes(nick,"UTF-8")+ b'\r\n')
        self.irc.send(b'USER Zion Israel Abraham :Moses IRC\r\n')
        self.irc.send(b'JOIN ' + bytes(channel[0],"UTF-8") + b'\r\n')
        self.irc.send(b'PRIVMSG ' + bytes(channel[0],'UTF-8') + b' :Hello\r\n')
        return True
 
