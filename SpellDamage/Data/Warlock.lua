-- local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
-- local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
-- local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
-- local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
-- local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
-- local Glyphs = SD.Glyphs

-- --

-- local TimeDamageHauntHelper = function(index)
-- 	return MultiParser:create(SpellTimeDamage, {index}, function(data, match)
-- 		if UnitExists("target") and UnitDebuff("target", L["haunt"]) then
-- 			data.timeDamage = match[index] * 1.35
-- 		else
-- 			data.timeDamage = match[index]
-- 		end
-- 	end)
-- end
-- local TimeDamageHaunt, TimeDamageHaunt2 = TimeDamageHauntHelper(1), TimeDamageHauntHelper(2)


-- --Похищение жизни:
-- local DrainLife = MultiParser:create(SpellDamageAndTimeHeal, {1, 2}, function(data, match)
-- 	data.damage = match[1]
-- 	data.timeHeal = match[2]
-- end)

-- --Канал здоровья:
-- local HealthFunnel = CustomParser:create(function(data, description)
-- 	data.type = SpellHeal

-- 	if Glyphs:contains(56238) then		--Символ канала здоровья
-- 		data.heal = UnitHealthMax("pet") * 0.15
-- 	else
-- 		data.heal = UnitHealthMax("pet") * 0.36
-- 	end
-- end)

-- --Жизнеотвод:
-- local LifeTap = CustomParser:create(function(data, description)
-- 	local match = nil
	
-- 	if Glyphs:contains(63320) then		--Символ жизнеотвода
-- 		match = matchDigit(description, 2)
-- 	else
-- 		match = matchDigit(description, 1)
-- 	end

-- 	if match then
-- 		data.type = SpellMana
-- 		data.mana = match
-- 	end
-- end)

-- --Ожог души:
-- local SoulFire = MultiParser:create(SpellDamage, {1}, function(data, match)
-- 	data.damage = match[1] * 2
-- end)

-- --Лик тлена:
-- local MortalCoil = MultiParser:create(SpellHeal, {1}, function(data, match)
-- 	data.heal = match[1] * UnitHealthMax("player") / 100
-- end)

-- --Углеотвод:
-- local EmberTap = MultiParser:create(SpellHeal, {1}, function(data, match)
-- 	data.heal = match[1] * UnitHealthMax("player") / 100
-- end)

-- --Стрела Хаоса:
-- local ChaosBolt = MultiParser:create(SpellDamage, {1}, function(data, match)
-- 	data.damage = match[1] * 2
-- end)

-- local Warlock = Class:create(ClassSpells)
-- SD.Warlock = Warlock
-- Warlock.dependFromTarget = true
-- Warlock.spells[172]		= TimeDamageHaunt 										--Порча
-- Warlock.spells[348]		= DoubleDamageParser 									--Жертвенный огонь
-- Warlock.spells[108686]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3) 	--Жертвенный огонь
-- Warlock.spells[686]		= SimpleDamageParser 									--Стрела Тьмы
-- Warlock.spells[689]		= DrainLife 		 									--Похищение жизни
-- Warlock.spells[755]		= HealthFunnel 											--Канал здоровья
-- Warlock.spells[980]		= TimeDamageHaunt 										--Агония
-- Warlock.spells[1122]	= SimpleDamageParser 									--Призыв инфернала
-- Warlock.spells[1454]	= LifeTap 												--Жизнеотвод
-- Warlock.spells[1949]	= TimeDamageHaunt2 										--Адское пламя
-- Warlock.spells[5740]	= TimeDamageHaunt 										--Огненный ливень
-- Warlock.spells[104232]	= TimeDamageHaunt 										--Огненный ливень
-- Warlock.spells[6353]	= SoulFire 												--Ожог души
-- Warlock.spells[6789]	= MortalCoil 											--Лик тлена
-- Warlock.spells[17877]	= SimpleDamageParser 									--Ожог Тьмы
-- Warlock.spells[17962]	= SimpleDamageParser 									--Поджигание
-- Warlock.spells[108685]	= SimpleDamageParser2 									--Поджигание
-- Warlock.spells[27243]	= TimeDamageHaunt 										--Семя порчи
-- Warlock.spells[29722]	= SimpleDamageParser 									--Испепеление
-- Warlock.spells[114654]	= SimpleDamageParser 									--Испепеление
-- Warlock.spells[30108]	= TimeDamageHaunt 										--Нестабильное колдовство
-- Warlock.spells[48181]	= SimpleDamageParser 									--Блуждающий дух
-- Warlock.spells[103103]	= TimeDamageHaunt 										--Похищение души
-- Warlock.spells[105174]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3) 	--Рука Гул'дана
-- Warlock.spells[114635]	= EmberTap 												--Углеотвод
-- Warlock.spells[116858]	= ChaosBolt 											--Стрела Хаоса
-- Warlock.spells[152108]	= SimpleDamageParser 	 								--Катаклизм
-- Warlock.spells[157695]	= SimpleDamageParser 									--Демонический заряд

-- Warlock.spells[603]	= SimpleTimeDamageParser 									--Рок
-- Warlock.spells[103964]	= SimpleDamageParser 									--Касание Хаоса
-- Warlock.spells[104025]	= SimpleTimeDamageParser 								--Жар преисподней
-- Warlock.spells[104027]	= SoulFire 												--Ожог души
-- Warlock.spells[124916]	= SimpleDamageParser2 									--Волна Хаоса

-- -------------------------------------------------------------------------------

-- local locale = GetLocale()

-- if locale == "enGB" or locale == "enUS" then
-- 	Warlock.spells[108685]	= SimpleDamageParser 									--Поджигание
-- 	return
-- end

-- if locale == "deDE" then
-- 	--Похищение жизни:
-- 	local DrainLife_de = MultiParser:create(SpellDamageAndTimeHeal, {2, 3}, function(data, match)
-- 		data.damage = match[2]
-- 		data.timeHeal = match[3]
-- 	end)

-- 	Warlock.spells[172]		= TimeDamageHaunt2 										--Порча
-- 	Warlock.spells[348]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Жертвенный огонь
-- 	Warlock.spells[108686]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 4) 	--Жертвенный огонь
-- 	Warlock.spells[689]		= DrainLife_de 		 									--Похищение жизни
-- 	Warlock.spells[980]		= TimeDamageHaunt2 										--Агония
-- 	Warlock.spells[5740]	= TimeDamageHaunt2 										--Огненный ливень
-- 	Warlock.spells[104232]	= TimeDamageHaunt2 										--Огненный ливень
-- 	Warlock.spells[27243]	= TimeDamageHaunt2 										--Семя порчи
-- 	Warlock.spells[114654]	= SimpleDamageParser2 									--Испепеление
-- 	Warlock.spells[30108]	= TimeDamageHaunt2 										--Нестабильное колдовство
-- 	Warlock.spells[103103]	= TimeDamageHaunt2 										--Похищение души
-- 	Warlock.spells[105174]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 4) 	--Рука Гул'дана
-- 	Warlock.spells[152108]	= SimpleDamageParser2 	 								--Катаклизм

-- 	Warlock.spells[603]	= SimpleTimeDamageParser2 									--Рок
-- 	Warlock.spells[104025]	= SimpleTimeDamageParser2 								--Жар преисподней
-- 	return
-- end

-- if locale == "esES" then
-- 	Warlock.spells[108685]	= SimpleDamageParser 									--Поджигание
-- 	return
-- end

-- if locale == "frFR" then
-- 	Warlock.spells[108685]	= SimpleDamageParser 									--Поджигание
-- 	return
-- end

-- if locale == "itIT" then
-- 	Warlock.spells[108685]	= SimpleDamageParser 									--Поджигание

-- 	Warlock.spells[124916]	= SimpleDamageParser 									--Волна Хаоса
-- 	return
-- end

-- if locale == "ptBR" then
-- 	Warlock.spells[108685]	= SimpleDamageParser 									--Поджигание
-- 	return
-- end

-- if locale == "zhCN" then
-- 	--Похищение жизни:
-- 	local DrainLife_cn = MultiParser:create(SpellDamageAndTimeHeal, {2, 3}, function(data, match)
-- 		data.damage = match[2]
-- 		data.timeHeal = match[3]
-- 	end)

-- 	Warlock.spells[172]		= TimeDamageHaunt2 										--Порча
-- 	Warlock.spells[348]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Жертвенный огонь
-- 	Warlock.spells[108686]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 4) 	--Жертвенный огонь
-- 	Warlock.spells[689]		= DrainLife_cn 		 									--Похищение жизни
-- 	Warlock.spells[980]		= TimeDamageHaunt2 										--Агония
-- 	Warlock.spells[5740]	= TimeDamageHaunt2 										--Огненный ливень
-- 	Warlock.spells[104232]	= TimeDamageHaunt2 										--Огненный ливень
-- 	Warlock.spells[27243]	= TimeDamageHaunt2 										--Семя порчи
-- 	Warlock.spells[114654]	= SimpleDamageParser2 									--Испепеление
-- 	Warlock.spells[30108]	= TimeDamageHaunt2 										--Нестабильное колдовство
-- 	Warlock.spells[103103]	= TimeDamageHaunt2 										--Похищение души
-- 	Warlock.spells[152108]	= SimpleDamageParser2 	 								--Катаклизм

-- 	Warlock.spells[603]	= SimpleTimeDamageParser2 									--Рок
-- 	Warlock.spells[104025]	= SimpleTimeDamageParser2 								--Жар преисподней
-- 	Warlock.spells[124916]	= SimpleDamageParser 									--Волна Хаоса
-- 	return
-- end
