import os,sys,socket, ircbot,string, irclib

if __name__ == "__main__":
    bot = ircbot.IRCBot()
    print ( bot.botName,"has been started successfully.")
    if bot.connect() == True:
        print ("Succesfully connected to", bot.network)
    while True:
            
