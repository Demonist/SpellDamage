# -*- coding: utf-8 -*-

import sys
import os
import codecs

__lastLen__ = 0
def reprint(string):
	global __lastLen__
	outString = string[ : 80]
	while len(outString) < __lastLen__:
		outString += ' '
	sys.stdout.write('\r' + outString)
	sys.stdout.flush()
	__lastLen__ = len(outString)

def endReprint():
	global __lastLen__
	if __lastLen__ > 0 :
		__lastLen__ = 0
		sys.stdout.write('\n')
		sys.stdout.flush()

def clearReprint():
	global __lastLen__
	if __lastLen__ > 0:
		sys.stdout.write('\r')
		for i in range(0, __lastLen__):
			sys.stdout.write(' ')
		sys.stdout.write('\r')
		__lastLen__ = 0
		sys.stdout.flush()


def find(string, startPattern, endPattern, start = 0, dumpFindError = True):
	s = string.find(startPattern, start)
	if s == -1:
		if dumpFindError:
			dumpError('tools.find() can not find startPattern "%s" from start position %d in\n\n%s' % (startPattern, start, string))
		return None
	s += len(startPattern)
	
	e = string.find(endPattern, s)
	if e == -1:
		if dumpFindError:
			dumpError('tools.find() can not find endPattern "%s" from position %d in\n\n%s' % (endPattern, s, string))
		return None
	return string[s:e]

def dumpError(text):
	try:
		os.rename('error.txt', 'error.txt.bak')
	except:
		pass

	f = codecs.open('error.txt', 'w', 'utf-8')
	f.write(text)
	f.close()

def makeFileBackup(filePath):
	backupFileName = filePath + '.bak'
	try:
		os.remove(backupFileName)
	except:
		pass
	try:
		os.rename(filePath, backupFileName)
	except:
		pass

def uprint(string):
	print codecs.encode(string, 'cp866', 'ignore')