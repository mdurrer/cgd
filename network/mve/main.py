#!/usr/bin/env python
# MVE
import os,sys
from commandline import *
from server import *
from client import *
debug = True
if debug:
	debug = True
c=Client()
s = Server(AF_INET,SOCK_STREAM)
serverRunning = True
print gethostname()
s.bindHost('',1315)
s.listenForConnections(5)
print "Socketname", s.socket.getsockname()
while serverRunning:
	(c.clientSocket,c.addressString) = s.acceptConnection()
	print "Accepting connection by", c.addressString
	#ctClient = client_thread(clientSocket)
	#ctClient.run()
	serverRunning = False
	
	
cl = CommandLine(c.clientSocket)	
cl.sendCommand("24")
while True:
	message = cl.receive()
	if message != "":
		print message
s.socket.close()
c.socket.close()
sys.exit
