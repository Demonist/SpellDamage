-- local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
-- local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
-- local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
-- local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
-- local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
-- local Glyphs = SD.Glyphs

-- --

-- --Восстановление:
-- local Regrowth = CustomParser:create(function(data, description)
-- 	if Glyphs:contains(116218) then	--Символ восстановления
-- 		local match = matchDigit(description, 1)
-- 		if match then
-- 			data.type = SpellHeal
-- 			data.heal = match * 2
-- 		end
-- 	else
-- 		local match = matchDigits(description, {1, 2})
-- 		if match then
-- 			data.type = SpellHealAndTimeHeal
-- 			data.heal = match[1]
-- 			data.timeHeal = match[2]
-- 		end
-- 	end
-- end)

-- --Свирепый укус:
-- local FerociousBite = CustomParser:create(function(data, description)
-- 	local list = {4, 6, 8, 10, 12}
-- 	local match = matchDigits(description, list)
-- 	local index = comboMatch(list)
-- 	if match then
-- 		if index then
-- 			data.type = SpellDamage
-- 			data.damage = match[index]

-- 			if Glyphs:contains(67598) then	--Символ свирепого укуса
-- 				data.type = SpellDamageAndHeal
-- 				local energy = matchDigit(description, 1)
-- 				data.heal = UnitHealthMax("player") * 0.015 * math.floor(energy / 10)
-- 			end
-- 		else
-- 			data.type = SpellEmpty
-- 		end
-- 	end
-- end)

-- --Жизнецвет:
-- local Lifebloom = MultiParser:create(SpellTimeHeal, {1, 3}, function(data, match)
-- 	data.timeHeal = match[1] + match[3]
-- end)

-- --Сила Природы:
-- local ForceOfNature1 = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
-- 	data.timeHeal = match[3] * 7
-- end)

-- --Сила Природы:
-- local ForceOfNature2 = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 	data.timeHeal = match[2] * 7
-- end)

-- --Увечье:
-- local Mangle = MultiParser:create(SpellDamageAndMana, {1}, function(data, match)
-- 	data.damage = match[1]
-- 	data.mana = 20
-- end)

-- --Обновление
-- local Renewal = MultiParser:create(SpellHeal, {1}, function(data, match)
-- 	data.heal = match[1] * UnitHealthMax("player") / 100
-- end)

-- --Дикий гриб:
-- local WildMushroom = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
-- 	data.timeHeal = match[4] * 15
-- end)

-- --Звездопад:
-- local Starfall = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 	data.timeHeal = match[2] * 10
-- end)

-- local Druid = Class:create(ClassSpells)
-- SD.Druid = Druid
-- Druid.dependFromPower = true
-- Druid.dependPowerTypes["COMBO_POINTS"] = true
-- Druid.spells[740]		= SimpleTimeHealParser 											--Спокойствие
-- Druid.spells[770]		= SimpleDamageParser 											--Волшебный огонь
-- Druid.spells[774]		= SimpleTimeHealParser 											--Омоложение
-- Druid.spells[1079]		= comboHelper(SpellTimeDamage, "timeDamage", {3, 5, 7, 9, 11})	--Разорвать
-- Druid.spells[1822]		= DoubleDamageParser 											--Глубокая рана
-- Druid.spells[2912]		= SimpleDamageParser 											--Звездный огонь
-- Druid.spells[5176]		= SimpleDamageParser 											--Гнев
-- Druid.spells[5185]		= SimpleHealParser 	 											--Целительное прикосновение
-- Druid.spells[5217]		= SimpleParser:create(SpellMana, 3) 							--Тигриное неистовство
-- Druid.spells[5221]		= SimpleDamageParser 											--Полоснуть
-- Druid.spells[6807]		= SimpleDamageParser 											--Трепка
-- Druid.spells[8921]		= DoubleDamageParser 											--Лунный огонь
-- Druid.spells[164812]	= DoubleDamageParser 											--Лунный огонь
-- Druid.spells[8936]		= Regrowth  													--Восстановление
-- Druid.spells[18562]		= SimpleHealParser 												--Быстрое восстановление
-- Druid.spells[22568]		= FerociousBite 												--Свирепый укус
-- Druid.spells[22570]		= comboHelper(SpellDamage, "damage", {2, 5, 8, 11, 14})			--Калечение
-- Druid.spells[22842]		= SimpleHealParser2 											--Неистовое восстановление
-- Druid.spells[33745]		= DoubleDamageParser 											--Растерзать
-- Druid.spells[33763]		= Lifebloom 													--Жизнецвет
-- Druid.spells[33831]		= ForceOfNature1 												--Сила Природы
-- Druid.spells[102693]	= SimpleTimeHealParser 											--Сила Природы
-- Druid.spells[102703]	= ForceOfNature2												--Сила Природы
-- Druid.spells[102706]	= ForceOfNature 												--Сила Природы
-- Druid.spells[33917]		= Mangle 														--Увечье
-- Druid.spells[48438]		= SimpleParser:create(SpellTimeHeal, 3) 						--Буйный рост
-- Druid.spells[77758]		= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3)  			--Взбучка
-- Druid.spells[106830]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3) 			--Взбучка
-- Druid.spells[78674]		= SimpleDamageParser 											--Звездный поток
-- Druid.spells[80313]		= SimpleDamageParser2 											--Раздавить
-- Druid.spells[102351]	= SimpleTimeHealParser2											--Щит Кенария
-- Druid.spells[106785]	= SimpleDamageParser 											--Размах
-- Druid.spells[108238]	= Renewal 														--Обновление
-- Druid.spells[145205]	= WildMushroom 													--Дикий гриб
-- Druid.spells[152221]	= DoubleDamageParser 											--Звездная вспышка
-- Druid.spells[164815]	= DoubleDamageParser 											--Солнечный огонь

-- Druid.spells[48505]		= Starfall 				 										--Звездопад

-- -- Полоснуть, Трепка, Размах ? незаметность и кровотечение

-- -------------------------------------------------------------------------------

-- local locale = GetLocale()

-- if locale == "enGB" or locale == "enUS" then
-- 	--Сила Природы:
-- 	local ForceOfNature_en = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 7
-- 	end)

-- 	--Дикий гриб:
-- 	local WildMushroom_en = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 15
-- 	end)

-- 	Druid.spells[33831]		= ForceOfNature_en 											--Сила Природы
-- 	Druid.spells[145205]	= WildMushroom_ 											--Дикий гриб
-- 	return
-- end

-- if locale == "deDE" then
-- 	--Восстановление:
-- 	local Regrowth_de = CustomParser:create(function(data, description)
-- 		if Glyphs:contains(116218) then	--Символ восстановления
-- 			local match = matchDigit(description, 1)
-- 			if match then
-- 				data.type = SpellHeal
-- 				data.heal = match * 2
-- 			end
-- 		else
-- 			local match = matchDigits(description, {1, 3})
-- 			if match then
-- 				data.type = SpellHealAndTimeHeal
-- 				data.heal = match[1]
-- 				data.timeHeal = match[3]
-- 			end
-- 		end
-- 	end)

-- 	--Жизнецвет:
-- 	local Lifebloom_de = MultiParser:create(SpellTimeHeal, {2, 3}, function(data, match)
-- 		data.timeHeal = match[2] + match[3]
-- 	end)

-- 	--Дикий гриб:
-- 	local WildMushroom_de = MultiParser:create(SpellTimeHeal, {5}, function(data, match)
-- 		data.timeHeal = match[5] * 15
-- 	end)

-- 	--Звездопад:
-- 	local Starfall_de = MultiParser:create(SpellTimeDamage, {4}, function(data, match)
-- 		data.timeHeal = match[4] * 10
-- 	end)

-- 	Druid.spells[740]		= SimpleParser:create(SpellTimeHeal, 3) 					--Спокойствие
-- 	Druid.spells[774]		= SimpleTimeHealParser2 									--Омоложение
-- 	Druid.spells[1822]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 		--Глубокая рана
-- 	Druid.spells[8936]		= Regrowth_de  												--Восстановление
-- 	Druid.spells[33763]		= Lifebloom_de 												--Жизнецвет
-- 	Druid.spells[102703]	= ForceOfNature1											--Сила Природы
-- 	Druid.spells[48438]		= SimpleParser:create(SpellTimeHeal, 4) 					--Буйный рост
-- 	Druid.spells[77758]		= DoubleParser:create(SpellDamageAndTimeDamage, 2, 4)  		--Взбучка
-- 	Druid.spells[106830]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 4) 		--Взбучка
-- 	Druid.spells[102351]	= SimpleParser:create(SpellTimeHeal, 3)						--Щит Кенария
-- 	Druid.spells[145205]	= WildMushroom_de 											--Дикий гриб
-- 	Druid.spells[48505]		= Starfall_de 		 										--Звездопад
-- 	return
-- end

-- if locale == "esES" then
-- 	--Сила Природы:
-- 	local ForceOfNature_es = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 7
-- 	end)

-- 	--Дикий гриб:
-- 	local WildMushroom_es = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 15
-- 	end)

-- 	Druid.spells[33831]		= ForceOfNature_es 											--Сила Природы
-- 	Druid.spells[48438]		= SimpleTimeHealParser 										--Буйный рост
-- 	Druid.spells[145205]	= WildMushroom_es 											--Дикий гриб
-- 	return
-- end

-- if locale == "frFR" then
-- 	--Сила Природы:
-- 	local ForceOfNature_fr = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 7
-- 	end)

-- 	--Дикий гриб:
-- 	local WildMushroom_fr = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 15
-- 	end)

-- 	Druid.spells[33831]		= ForceOfNature_fr 											--Сила Природы
-- 	Druid.spells[145205]	= WildMushroom_fr 											--Дикий гриб
-- 	return
-- end

-- if locale == "itIT" then
-- 	--Сила Природы:
-- 	local ForceOfNature_it = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 7
-- 	end)

-- 	--Дикий гриб:
-- 	local WildMushroom_it = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 15
-- 	end)

-- 	Druid.spells[33831]		= ForceOfNature_it 											--Сила Природы
-- 	Druid.spells[145205]	= WildMushroom_it 											--Дикий гриб
-- 	return
-- end

-- if locale == "ptBR" then
-- 	--Сила Природы:
-- 	local ForceOfNature_pt = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 7
-- 	end)

-- 	--Дикий гриб:
-- 	local WildMushroom_pt = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
-- 		data.timeHeal = match[2] * 15
-- 	end)

-- 	Druid.spells[33831]		= ForceOfNature_pt 											--Сила Природы
-- 	Druid.spells[48438]		= SimpleTimeHealParser 										--Буйный рост
-- 	Druid.spells[145205]	= WildMushroom_pt 											--Дикий гриб
-- 	return
-- end

-- if locale == "zhCN" then
-- 	--Восстановление:
-- 	local Regrowth_cn = CustomParser:create(function(data, description)
-- 		if Glyphs:contains(116218) then	--Символ восстановления
-- 			local match = matchDigit(description, 1)
-- 			if match then
-- 				data.type = SpellHeal
-- 				data.heal = match * 2
-- 			end
-- 		else
-- 			local match = matchDigits(description, {1, 3})
-- 			if match then
-- 				data.type = SpellHealAndTimeHeal
-- 				data.heal = match[1]
-- 				data.timeHeal = match[3]
-- 			end
-- 		end
-- 	end)

-- 	--Жизнецвет:
-- 	local Lifebloom_cn = MultiParser:create(SpellTimeHeal, {2, 3}, function(data, match)
-- 		data.timeHeal = match[2] + match[3]
-- 	end)

-- 	--Сила Природы:
-- 	local ForceOfNature_cn = MultiParser:create(SpellTimeDamage, {4}, function(data, match)
-- 		data.timeHeal = match[4] * 7
-- 	end)

-- 	--Дикий гриб:
-- 	local WildMushroom_cn = MultiParser:create(SpellTimeHeal, {5}, function(data, match)
-- 		data.timeHeal = match[5] * 15
-- 	end)

-- 	--Звездопад:
-- 	local Starfall_cn = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
-- 		data.timeHeal = match[3] * 10
-- 	end)

-- 	Druid.spells[740]		= SimpleParser:create(SpellTimeHeal, 3) 					--Спокойствие
-- 	Druid.spells[774]		= SimpleTimeHealParser2 									--Омоложение
-- 	Druid.spells[1822]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 		--Глубокая рана
-- 	Druid.spells[8921]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 		--Лунный огонь
-- 	Druid.spells[164812]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 		--Лунный огонь
-- 	Druid.spells[8936]		= Regrowth_cn  												--Восстановление
-- 	Druid.spells[33763]		= Lifebloom_cn 												--Жизнецвет
-- 	Druid.spells[33831]		= ForceOfNature_cn 											--Сила Природы
-- 	Druid.spells[102703]	= ForceOfNature_cn											--Сила Природы
-- 	Druid.spells[102351]	= SimpleParser:create(SpellTimeHeal, 3)						--Щит Кенария
-- 	Druid.spells[145205]	= WildMushroom_cn 											--Дикий гриб
-- 	Druid.spells[164815]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 		--Солнечный огонь
-- 	Druid.spells[48505]		= Starfall_cn 		 										--Звездопад
-- 	return
-- end
