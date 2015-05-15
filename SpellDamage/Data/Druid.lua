--Обновление
local Renewal = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = match[1] * UnitHealthMax("player") / 100
end)

--Жизнецвет:
local Lifebloom = MultiParser:create(SpellTimeHeal, {1, 3}, function(data, match)
	data.timeHeal = match[1] + match[3]
end)

--Сила Природы:
local ForceOfNature = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
	data.timeHeal = match[3] * 7
end)

--Звездопад:
local Starfall = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
	data.timeHeal = match[3] * 10
end)

--Дикий гриб:
local WildMushroom = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
	data.timeHeal = match[4] * 15
end)

Druid = Class:create()
Druid.dependFromPower = true
Druid.dependPowerTypes["COMBO_POINTS"] = true
Druid.spells[5176]		= SimpleDamageParser 		--Гнев
Druid.spells[8921]		= DoubleDamageParser 		--Лунный огонь
Druid.spells[164812]	= DoubleDamageParser 		--Лунный огонь
Druid.spells[774]		= SimpleTimeHealParser 		--Омоложение
Druid.spells[1822]		= DoubleDamageParser 		--Глубокая рана
Druid.spells[5221]		= SimpleDamageParser 		--Полоснуть
Druid.spells[22568]		= comboHelper(SpellDamage, "damage", {4, 6, 8, 10, 12})			--Свирепый укус
Druid.spells[33917]		= SimpleDamageParser 		--Увечье
Druid.spells[2912]		= SimpleDamageParser 		--Звездный огонь
Druid.spells[18562]		= SimpleHealParser 			--Быстрое восстановление
Druid.spells[6807]		= SimpleDamageParser 		--Трепка
Druid.spells[78674]		= SimpleDamageParser 		--Звездный поток
Druid.spells[8936]		= DoubleParser:create(SpellHealAndTimeHeal, 1, 2) 				--Восстановление
Druid.spells[164815]	= DoubleDamageParser 		--Солнечный огонь
Druid.spells[1079]		= comboHelper(SpellTimeDamage, "timeDamage", {3, 5, 7, 9, 11})	--Разорвать
Druid.spells[106785]	= SimpleDamageParser 		--Размах
Druid.spells[5185]		= SimpleHealParser 	 		--Целительное прикосновение
Druid.spells[770]		= SimpleDamageParser 		--Волшебный огонь
Druid.spells[77758]		= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3)  	--Взбучка
Druid.spells[106830]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3) 	--Взбучка
Druid.spells[108238]	= Renewal 					--Обновление
Druid.spells[102351]	= SimpleTimeHealParser2		--Щит Кенария
Druid.spells[33763]		= Lifebloom 				--Жизнецвет
Druid.spells[33745]		= DoubleDamageParser 		--Растерзать
Druid.spells[33831]		= ForceOfNature 			--Сила Природы
Druid.spells[102693]	= SimpleTimeHealParser 		--Сила Природы
Druid.spells[102703]	= ForceOfNature				--Сила Природы
Druid.spells[102706]	= ForceOfNature 			--Сила Природы
Druid.spells[22842]		= SimpleHealParser2 		--Неистовое восстановление
Druid.spells[740]		= SimpleTimeHealParser 		--Спокойствие
Druid.spells[48438]		= SimpleParser:create(SpellTimeHeal, 3) 				--Буйный рост
Druid.spells[48505]		= Starfall 				 	--Звездопад
Druid.spells[22570]		= comboHelper(SpellDamage, "damage", {2, 5, 8, 11, 14})	--Калечение
Druid.spells[145205]	= WildMushroom 				--Дикий гриб
Druid.spells[152221]	= DoubleDamageParser 		--Звездная вспышка
Druid.spells[80313]		= SimpleDamageParser2 		--Раздавить
