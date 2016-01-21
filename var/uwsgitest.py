#!/usr/bin/python

# run with:
# uwsgi --module uwsgitest --master --http-socket :9999 --max-requests 2 --processes 2
# uwsgi --module uwsgitest --master --http-socket :9999 --max-requests 2 --processes 2 --harakiri 1

import time
import os
import uwsgi
import random
import atexit
import pprint
import signal


def myExit():
	print "myExit"

def myHandle():
	print "signal my handle"
	if signal._old:
		signal._old()

class handler(object):
	def __init__(self):
		self.old = None

	def handle(self):
		print "Signal handle"
		if(self.old):
			self.old()

class Application(object):
	def __init__(self):
		self.i = 0
		print "init!!!", self.i

	def cleanup(self):
		print "cleanup!!!", self.i

	def __call__(self, env, start_response):
		start_response('200 OK', [('Content-Type','text/html')])
		self.i += 1
		sleep = random.random() * 3
		# pprint.pprint(locals())
		print os.getpid(), self.i, sleep

		time.sleep(sleep)
		print os.getpid(), self.i, "x"
		return "Hello World %s" % self.i

application = Application()
uwsgi.atexit = application.cleanup
atexit.register(myExit)
# h = handler()
# handler.old = signal.getsignal(9)
# signal.signal(9, h.handle)

signal._old = signal.getsignal(9)
uwsgi.register_signal(9, "workers", myHandle)
# signal.signal(15, myHandle)
