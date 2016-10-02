# -*- coding: utf-8 -*-

import os
import codecs
import time
import sys
import re

import tools

def main():
	tools.makeFileBackup('data_2-ids.txt')
	fout = codecs.open('data_2-ids.txt', 'w', 'utf-8')

	fin = codecs.open('data_1-raw.txt', 'r', 'utf-8')
	data = fin.read()
	fin.close()

	rows = data.split('},{')
	for row in rows:
		id = None
		name = None
		
		match = re.search('"id":(\\d+),', row)
		if match:
			id = int(match.group(1))

		match = re.search('"name":"\\d([^"]+)",', row)
		if match:
			name = match.group(1)

		if id and name:
			fout.write('%d %s\n' % (id, name))

	fout.close()
	return True

if __name__ == '__main__':
	if main() == True:
		quit(0)
	else:
		quit(1)