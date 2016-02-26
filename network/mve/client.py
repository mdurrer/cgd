#!/usr/bin/env python
import os,sys
from socket import *
from server import *
class Client(Server):
	def __init__(self,pType=AF_INET,pFamily=SOCK_STREAM):
		self.protocolType = pType
		self.protocolFamily = pFamily
		self.socket = socket(pType, pFamily)
		self.clientSocket = None
		self.addressString = None
	def connect(self,address):
		self.socket.connect(address)
	def receive(self,length=1024):
		message = self.socket.recv(length)
		return message
	def send(self,data):
		self.socket.send(data) # Data must be string
