import os,sys
from socket import *

class CommandLine:
	def __init__(self,connection,user="Default"):
		self.connection = connection
		self.user = user
	def getUser(self):
		return self.user
	def getConnection(self):
		return self.connection
	def sendCommand(self,command):
		self.connection.send(command)
	def receiveCommand(self):
		pass
	def receive(self):
		self.connection.recv(1024)
	def send(self,data):
		self.connection.send(data) # Data must be string
