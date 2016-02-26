import os,sys,socket, ircbot,string

if __name__ == "__main__":
    bot = ircbot.IRCBot()
    print ( bot.botName,"has been started successfully.")
    if bot.connect() == True:
        print ("Succesfully connected to", bot.network)
    while True:
        
        data = bot.irc.recv(4096)
        print(data) 
        if data.find(bytes("PING",'UTF-8') ) != -1:
            bot.irc.send(b'PONG' + data.split()[1] + b'\r\n')
        elif data.find(b'PRIVMSG') != -1:
            message = ':'.join(data.split(':')[2:])
            if message.lower().find(b'geschlossene') == -1:
                nick = data.split('!')[0].replace(':',' ')
                destination = ''.join(data.split(':')[:2]).split(' ')[-2]
                function = message.split()[0]
                print("Function is " + function + ' From ' + nick)
                arg = data.split()
