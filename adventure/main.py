#!/usr/bin/env python2.7
from math import *
import os,sys,pygame
from pygame import *
from adventure import *
from display import *
from scene import *
import sqlite3 as sql
engine = "Adventure"
FPS = 60
if __name__ == "__main__":
	#con = sql.connect('data/sample.sqlite3')
	#cursor = con.cursor()

	print "Starting",engine,"Engine"
	engine = Adventure ("Wazoo!")
	pygame.display.set_caption(engine.name)
	playtime = float()
	clock = pygame.time.Clock()
	engine.init()
	#cursor.execute('SELECT name from character WHERE state=0')
	#con.commit()
	#print cursor.fetchone()[0]
	firstChapter = Chapter("start")
	firstChapter.loadFirstScene('')
	a = Character("Hero")
	#a.loadDatabase(a.name)
	pygame.mouse.set_visible(0)
	startScene  = Scene("scene1")

	print startScene.background
	while True:
		for event in pygame.event.get():
			if event.type == QUIT:
				pygame.quit()
			if event.type == KEYDOWN:
				if event.key == K_ESCAPE:
					pygame.quit()
				if event.key == K_f:
					pygame.display.toggle_fullscreen()
		engine.display.surface.fill((0,0,0))
		engine.display.surface.blit(startScene.backgroundSurface,(0,0))
		#engine.display.surface.blit(startScene.walkableSurface,(0,0))
		engine.display.surface.blit(engine.mouse.image,(engine.mouseX,engine.mouseY))
		milliseconds = clock.tick(60)
		playtime += milliseconds
		engine.updateMouse()
		print "X:",engine.mouseX,"Y:",engine.mouseY
		print  "Alpha",engine.mouse.image.get_alpha()
		if startScene.walkableSurface.get_at((engine.mouseX,engine.mouseY)) == (1,1,1):
			print "Houston, we've got contact at ",engine.mouseX,engine.mouseY
			#startScene.backgroundSurface.set_alpha(0)
			engine.mouse.image.set_alpha(0)

		pygame.display.flip()
