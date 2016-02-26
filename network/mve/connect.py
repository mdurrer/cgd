#!/usr/bin/env python
# MVE
import os,sys
from server import *
from client import *
debug = True
if debug:
	print "Connecting"
c=Client()

c.connect(('',1315))
	
while True:
	message = c.receive()
	
	if message != "":
		if message[0:2] == "20":
			print "Closing Socket, good bye!"
			c.socket.close()
			sys.exit()
		if message[0:2] == "24":
			 print "Say hi to Deborah and Ian for me!"
