# -*- coding: utf-8 -*-

import os
import codecs
import re

import tools

def fixDescriptions(descriptionsText):
	ret = descriptionsText.replace('&nbsp;', ' ')
	ret = ret.replace('&mdash;', '-')
	ret = ret.replace('&hellip;', '')

	startIndex = ret.rfind('<span class="q">')
	if startIndex >= 0:
		ret = ret[startIndex + len('<span class="q">') : ]

	ret = ret.replace(u'На эту способность не влияет общее время восстановления.', '')
	ret = ret.replace('<table width="100%">', ' ')
	ret = ret.replace('<table>', '')
	ret = ret.replace('</table>', ' ')
	ret = ret.replace('<tr>', '')
	ret = ret.replace('</tr>', ' ')
	ret = ret.replace('<td>', '')
	ret = ret.replace('</td>', ' ')
	ret = ret.replace('<th>', '')
	ret = ret.replace('</th>', ' ')
	ret = ret.replace('<span>', '')
	ret = ret.replace('</span>', ' ')
	ret = ret.replace('<b>', '')
	ret = ret.replace('</b>', '')
	ret = ret.replace('<br />', ' ')
	ret = ret.replace('</a>', '')

	match = tools.find(ret, '<span', '>', 0, False)
	while match:
		ret = ret.replace('<span'+match+'>', '')
		match = tools.find(ret, '<span', '>', 0, False)
	
	match = re.search('<a[^>]+>', ret)
	while match:
		ret = ret.replace(match.group(0), '')
		match = re.search('<a[^>]+>', ret)

	match = re.search('<!--[^>]+>', ret)
	while match:
		ret = ret.replace(match.group(0), '')
		match = re.search('<!--[^>]+>', ret)

	return ret

def main():
	fin = codecs.open('result_1-spells.txt', 'r', 'utf-8')
	text = fin.read()
	fin.close()

	classes = text.split('\n\n======= ')
	del text
	
	tools.makeFileBackup('result_2-filetered-spells.txt')
	fout = codecs.open('result_2-filetered-spells.txt', 'w', 'utf-8')
	for classText in classes:
		classText = classText.strip()
		if len(classText) == 0:
			continue

		match = re.search('^([^\n]+)\n', classText)
		if match == None:
			break
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
			for descrIndex in range(0, len(spellDescriptions)):
				spellDescriptions[descrIndex] = fixDescriptions(spellDescriptions[descrIndex])
			del spellDescriptions[0]	#Must be empty

			fout.write('\n+++ %d | %s | %s' % (spellId, spellRuName, spellEnName))
			for descr in spellDescriptions:
				fout.write('\n   %s' % (descr))
	fout.close()

	return True

if __name__ == '__main__':
	if main() == True:
		quit(0)
	else:
		quit(1)