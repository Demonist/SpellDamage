# -*- coding: utf-8 -*-

import os
import urllib2
import codecs
import time
import sys
import re

import tools

def filter(text):
	patterns = ['<[^>]+>', u'\\(\\d+ (мин|сек\\.) Восстановление\\)', u'Время действия – \\d+ (мин|сек)\\.', u'Действие эффекта прерывается, если персонаж встает с места\\.']

	for pattern in patterns:
		match = re.search(pattern, text)
		while match:
			text = text.replace(match.group(0), '')
			match = re.search(pattern, text)

	return text

def check(id, name, text):
	if None != re.search(u'(Восстанавливает|Восполняет|Восполнение) (\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. здоровья\\.', text):
		return "Items.spells[%d]	= Heal({ru=1}) \t\t--%s" % (id, name)
	elif None != re.search(u'(Восстанавливает|Восполняет|Восполнение) (\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. маны\\.', text):
		return "Items.spells[%d]	= Mana({ru=1}) \t\t--%s" % (id, name)
	if None != re.search(u'(Восстанавливает|Восполняет|Восполнение) (\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. здоровья и (восполняет |)(\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. маны\\.', text):
		return "Items.spells[%d]	= HealAndMana({ru=1}) \t\t--%s" % (id, name)
	
	elif None != re.search(u'(Восстанавливает|Восполняет|Восполнение) (\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. здоровья (в течение|за) \\d+ сек\\.', text):
		return "Items.spells[%d]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) \t\t--%s" % (id, name)
	elif None != re.search(u'(Восстанавливает|Восполняет|Восполнение) (\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. маны (в течение|за) \\d+ сек\\.', text):
		return "Items.spells[%d]	= TimeMana({ru=1, de=2, cn=2, kr=2}) \t\t--%s" % (id, name)
	elif None != re.search(u'(Восстанавливает|Восполняет|Восполнение) (\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. здоровья и (восполняет |)(\\d+|\\d+\\.\\d+|\\d+ to \\d+) ед\\. маны (в течение|за) \\d+ сек\\.', text):
		return "Items.spells[%d]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) \t\t--%s" % (id, name)
	return None

def main():
	fin = codecs.open('data_3-rawText.txt', 'r', 'utf-8')
	rows = fin.read().split('\n')
	fin.close()
	items = []
	for row in rows:
		if len(row) == 0:
			continue

		match = re.search('(\\d+) ([^\\|]+) \\| (.+)', row)
		if match:
			items.append((int(match.group(1)), match.group(2), match.group(3)))
		else:
			print('Input data parsing error')
			print(row)
			return False

	tools.makeFileBackup('data_4-result.txt')
	fout = codecs.open('data_4-result.txt', 'w', 'utf-8')

	used = []
	unknown = []

	for i in range(0, len(items)):
		id = items[i][0]
		name = items[i][1]
		description = filter(items[i][2])

		usedText = check(id, name, description)
		if usedText == None:
			unknown.append((id, name, description))
		else:
			used.append((usedText))

	for u in used:
		fout.write("%s\n" % u)

	fout.write('\n========\n\n')

	for u in unknown:
		fout.write('%d %s | %s\n' % (u[0], u[1], u[2]))

	fout.close()

	return True

if __name__ == '__main__':
	if main() == True:
		quit(0)
	else:
		quit(1)
		