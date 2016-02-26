#!/usr/bin/env python
import os,sys
import commandline
from socket import *
class Server(object):
	def __init__(self,pType=AF_INET,pFamily=SOCK_STREAM):
		self.protocolType = pType
		self.protocolFamily = pFamily
		self.socket = socket(pType, pFamily)
		self.socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
	def bindHost(self,host='',port=1024):
		self.socket.bind((host,port))
	def listenForConnections(self,maxCon):
		self.socket.listen(maxCon)
	def acceptConnection(self):
		connectionTuple = self.socket.accept()
		return connectionTuple
