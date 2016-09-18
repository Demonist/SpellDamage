# -*- coding: utf-8 -*-

#not required parameters: 
#	first - id of starting potion

import os
import urllib2
import codecs
import time
import sys
import re

import tools

def main():
	fin = codecs.open('data_2-ids.txt', 'r', 'utf-8')
	rows = fin.read().split('\n')
	fin.close()
	items = []
	for row in rows:
		match = re.search('(\\d+) (.+)', row)
		if match:
			items.append((int(match.group(1)), match.group(2)))

	tools.makeFileBackup('data_3-rawText.txt')
	fout = codecs.open('data_3-rawText.txt', 'w', 'utf-8')

	startId = -1
	if len(sys.argv) > 1:
		startId = int(sys.argv[1])

	for i in range(0, len(items)):
		id = items[i][0]
		name = items[i][1]

		if startId != -1:
			if id == startId:
				startId = -1
			else:
				continue

		tools.reprint('Downloading %d %s - %d/%d - %d%%' % (id, name, i, len(items), (i * 100) / len(items)))
		try:
			url = urllib2.urlopen('http://ru.wowhead.com/item=%d' % (id))
		except:
			tools.endReprint()
			print('Error: Can not open %d item - %s' % (id, name))
			return False
		text = codecs.decode(url.read(), 'utf-8', 'ignore')
		url.close()
		text = text.replace('\r\n', '')
		text = text.replace('\n', ' ')

		description = tools.find(text, u'Использование:', '</span>', dumpFindError=False)
		if description == None:
			tools.endReprint()
			print('Error: Can not find item description')
		else:
			fout.write('%d %s | %s\n' % (id, name, description))
		
		time.sleep(0.3)

	fout.close()

	tools.clearReprint()
	print("\nAll items downloded successfuly!")
	return True

if __name__ == '__main__':
	if main() == True:
		quit(0)
	else:
		quit(1)
		