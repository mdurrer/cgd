import os,sys
from bottle import route, run, template

@route ('/hello/<name>')
def index(name):
	return bottle.template('<b>Hello {{name}}</b>!',name=name)

run(host='localhost', port=8080)