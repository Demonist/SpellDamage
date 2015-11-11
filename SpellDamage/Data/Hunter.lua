local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
local Glyphs = SD.Glyphs

--

--Лечение питомца:
local MendPet = CustomParser:create(function(data, description)
	data.type = SpellTimeHeal
	data.timeHeal = 0.25 * UnitHealthMax("pet")
end)

--Отрыв:
local Disengage = CustomParser:create(function(data, description)
	if Glyphs:contains(132106) then		--Символ освобождения
		data.type = SpellHeal
		data.heal = UnitHealthMax("player") * 0.04
	else
		data.type = SpellEmpty
	end
end)

--Кормление питомца:
local FeedPet = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = UnitHealthMax("pet") * match[1] / 100
end)

--Взрывная ловушка:
local ExplosiveTrap = CustomParser:create(function(data, description)
	if not Glyphs:contains(119403) then		--Символ взрывной ловушки
		local match = matchDigits(description, {1, 3})
		if match then
			data.type = SpellDamageAndTimeDamage
			data.damage = match[1]
			data.timeDamage = match[3]
		end
	else
		data.type = SpellEmpty
	end
end)

--Разрывной выстрел:
local ExplosiveShot = MultiParser:create(SpellDamageAndTimeDamage, {1, 2}, function(data, match)
	data.damage = match[1]
	data.timeDamage = data.damage * match[2]
end)

--Убийственный выстрел:
local KillShot = MultiParser:create(SpellDamageAndHeal, {1, 3}, function(data, match)
	data.damage = match[1]
	data.heal = match[3] * UnitHealthMax("player") / 100
end)

--Выстрел химеры:
local ChimaeraShot = CustomParser:create(function(data, description)
	local match = matchDigit(description, 1)
	if match then
		data.type = SpellDamage
		data.damage = match

		if Glyphs:contains(119447) then		--Символ выстрела химеры
			data.type = SpellDamageAndHeal
			data.heal = UnitHealthMax("player") * 0.02
		end
	end
end)

--Живость:
local Exhilaration = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = UnitHealthMax("player") * match[1] / 100
end)

--Бросок глеф:
local GlaiveToss = MultiParser:create(SpellDamage, {3}, function(data, match)
	data.damage = match[3] * 8
end)

local Hunter = Class:create(ClassSpells)
SD.Hunter = Hunter
Hunter.spells[136]		= MendPet 					--Лечение питомца
Hunter.spells[781]		= Disengage 				--Отрыв
Hunter.spells[2643]		= SimpleDamageParser2 		--Залп
Hunter.spells[3044]		= SimpleDamageParser 		--Чародейский выстрел
Hunter.spells[3674]		= SimpleTimeDamageParser 	--Черная стрела
Hunter.spells[6991]		= FeedPet 					--Кормление питомца
Hunter.spells[13813]	= ExplosiveTrap			 	--Взрывная ловушка
Hunter.spells[82939]	= ExplosiveTrap			 	--Взрывная ловушка (в режиме метания)
Hunter.spells[19434]	= SimpleDamageParser 		--Прицельный выстрел
Hunter.spells[34026]	= SimpleDamageParser 		--Команда "Взять!"
Hunter.spells[53209]	= ChimaeraShot 				--Выстрел химеры
Hunter.spells[53301]	= ExplosiveShot 			--Разрывной выстрел
Hunter.spells[157708]	= KillShot 					--Убийственный выстрел
Hunter.spells[56641]	= SimpleDamageParser 		--Верный выстрел
Hunter.spells[77767]	= SimpleDamageParser 		--Выстрел кобры
Hunter.spells[109259]	= SimpleDamageParser 		--Мощный выстрел
Hunter.spells[109304]	= Exhilaration 				--Живость
Hunter.spells[117050]	= GlaiveToss 				--Бросок глеф
Hunter.spells[120360]	= SimpleDamageParser2 		--Шквал
Hunter.spells[152245]	= SimpleDamageParser 		--Сосредоточенный выстрел
Hunter.spells[163485]	= SimpleDamageParser 		--Сосредоточенный выстрел

-------------------------------------------------------------------------------

local locale = GetLocale()

if locale ~= "ruRU" then
	local GlaiveToss_notRu = MultiParser:create(SpellDamage, {1}, function(data, match)
		data.damage = match[1] * 8
	end)

	Hunter.spells[117050]	= GlaiveToss_notRu 		--Бросок глеф
end

if locale == "enGB" or locale == "enUS" then

	return
end

if locale == "deDE" then
	--Разрывной выстрел:
	local ExplosiveShot_de = MultiParser:create(SpellDamageAndTimeDamage, {1, 2}, function(data, match)
		data.damage = match[2]
		data.timeDamage = data.damage * match[1]
	end)

	Hunter.spells[3674]		= SimpleTimeDamageParser2 	--Черная стрела
	Hunter.spells[53301]	= ExplosiveShot_de 			--Разрывной выстрел
	return
end

if locale == "esES" then

	return
end

if locale == "frFR" then
	Hunter.spells[2643]		= SimpleDamageParser 		--Залп
	return
end

if locale == "itIT" then
	
	return
end

if locale == "ptBR" then
	
	return
end

if locale == "zhCN" then

	return
end
