--Возложение рук:
local LayOnHands = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = UnitHealthMax("player")
	end)

--Вечное пламя:
local EternalFlame = MultiParser:create(SpellHealAndTimeHeal, {2, 3}, function(data, match)
	data.heal = match[2]
	data.timeHeal = match[3] * 15
end)

--Молот Света:
local LightsHammer = MultiParser:create(SpelLDamageAndHeal, {4, 8}, function(data, match)
	data.damage = match[4] * 7
	data.timeHeal = match[8] * 7
end)

Paladin = Class:create()
Paladin.spells[35395]	= SimpleDamageParser 									--Удар воина Света
Paladin.spells[20271]	= SimpleDamageParser 									--Правосудие
Paladin.spells[130552]	= SimpleHealParser2 									--Резкое слово
Paladin.spells[85673]	= SimpleHealParser2 									--Торжество
Paladin.spells[136494]	= SimpleHealParser2 									--Торжество
Paladin.spells[85256]	= SimpleDamageParser 									--Вердикт храмовника
Paladin.spells[20473]	= DoubleParser:create(SpellDamageAndHeal, 1, 2) 		--Шок небес
Paladin.spells[31935]	= SimpleDamageParser 									--Щит мстителя
Paladin.spells[19750]	= SimpleHealParser 	 									--Вспышка Света
Paladin.spells[633] 	= LayOnHands 											--Возложение рук
Paladin.spells[2812]	= SimpleDamageParser 									--Обличение
Paladin.spells[119072]	= SimpleDamageParser 									--Гнев небес
Paladin.spells[53595]	= SimpleDamageParser 									--Молот праведника
Paladin.spells[82327]	= SimpleHealParser 										--Святое сияние
Paladin.spells[53385]	= SimpleDamageParser 									--Божественная буря
Paladin.spells[26573]	= SimpleTimeDamageParser 								--Освящение
Paladin.spells[24275]	= SimpleDamageParser 	 								--Молот гнева
Paladin.spells[53600]	= SimpleDamageParser 									--Щит праведника
Paladin.spells[114163]	= EternalFlame 											--Вечное пламя
Paladin.spells[879]		= SimpleDamageParser 									--Экзорцизм
Paladin.spells[82326]	= SimpleHealParser 										--Свет небес
Paladin.spells[85222]	= SimpleParser:create(SpellHeal, 4) 					--Свет зари
Paladin.spells[114165]	= DoubleParser:create(SpellDamageAndHeal, 1, 3) 		--Божественная призма
Paladin.spells[114158]	= LightsHammer 											--Молот Света
Paladin.spells[114157]	= DoubleParser:create(SpellTimeDamageAndTimeHeal, 1, 3) --Смертный приговор
Paladin.spells[157048]	= SimpleDamageParser 									--Окончательный приговор
