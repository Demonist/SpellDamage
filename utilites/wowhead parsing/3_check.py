# -*- coding: utf-8 -*-

import os
import codecs
import re
import string

import tools

def main():
	fin = codecs.open('result_2-filetered-spells.txt', 'r', 'utf-8')
	text = fin.read()
	fin.close()

	classes = text.split('\n\n======= ')
	del text
	
	languages = ['ru', 'en', 'de', 'es', 'fr', 'it', 'pt', 'cn', 'kr']

	tools.makeFileBackup('result_3-checked-spells.txt')
	fout = codecs.open('result_3-checked-spells.txt', 'w', 'utf-8')
	for classText in classes:
		classText = classText.strip()
		if len(classText) == 0:
			continue

		match = re.search('^([^\n]+)\n', classText)
		className = match.group(1)
		fout.write('\n\n======= %s\n' % className)

		spells = classText[len(match.group(0)) - 1 : ].split('\n+++ ')
		for spell in spells:
			spell = spell.strip()
			if len(spell) == 0:
				continue

			match = re.search('^(\\d+) \\| ([^\\|\n]+) \\| ([^\\|\n]+)', spell)
			spellId = int(match.group(1))
			spellRuName = match.group(2)
			spellEnName = match.group(3)

			spellDescriptions = spell[len(match.group(0)) : ].split('\n   ')
			del spellDescriptions[0]	#must be empty
			
			fout.write('\n\n+++ %d | %s | %s' % (spellId, spellRuName, spellEnName))

			ruMatch = re.findall('\\d+\\.\\d+%?|\\d+%?', spellDescriptions[0])
			fout.write('\n%s   %s: %s' % (languages[0], string.join(ruMatch, ', '), spellDescriptions[0]))
			
			for i in range(1, len(languages)):
				match = re.findall('\\d+\\.\\d+%?|\\d+%?', spellDescriptions[i])
				if match != ruMatch:
					fout.write('\n%s   %s: %s' % (languages[i], string.join(match, ', '), spellDescriptions[i]))
	fout.close()

	return True

if __name__ == '__main__':
	if main() == True:
		quit(0)
	else:
		quit(1)