-- local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
-- local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
-- local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
-- local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
-- local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
-- local Glyphs = SD.Glyphs

-- --

-- --Ледяные оковы:
-- local ChainsOfIce = CustomParser:create(function(data, description)
-- 	if Glyphs:contains(58620) then	--Символ ледяных оков
-- 		local match = matchDigit(description, 1)
-- 		if match then
-- 			data.type = SpellDamage
-- 			data.damage = match
-- 		end
-- 	else
-- 		data.type = SpellEmpty
-- 	end
-- end)

-- --Лик смерти:
-- local DeathCoil = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
-- 	data.damage = match[1]

-- 	if UnitExists("target") and UnitIsFriend("player", "target") and UnitRace("target") == "Scourge" then
-- 		data.type = SpellHeal
-- 		data.heal = match[2]
-- 	end
-- end)

-- --Усиление рунического оружия:
-- local EmpowerRuneWeapon = MultiParser:create(SpellMana, {1}, function(data, match)
-- 	data.mana = match[1]

-- 	if Glyphs:contains(159421) then	--Символ усиления
-- 		data.type = SpellHealAndMana
-- 		data.heal = UnitHealthMax("player") * 0.3
-- 	end
-- end)

-- --Смертельный союз:
-- local DeathPact = MultiParser:create(SpellHeal, {1}, function(data, match)
-- 	data.heal = match[1] * UnitHealthMax("player") / 100
-- end)

-- --Удар Плети:
-- local ScourgeStrike = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
-- 	data.damage = match[1] + match[2]
-- end)

-- --Смертельное поглощение:
-- local DeathSiphon = MultiParser:create(SpellDamageAndHeal, {1, 2}, function(data, match)
-- 	data.damage = match[1]
-- 	data.heal = data.damage * match[2] / 100
-- end)

-- --Преобразование:
-- local Conversion = MultiParser:create(SpellTimeHeal, {1}, function(data, match)
-- 	data.heal = UnitHealthMax("player") * 0.02
-- end)

-- local DeathKnight = Class:create(ClassSpells)
-- SD.DeathKnight = DeathKnight
-- DeathKnight.spells[43265]	= SimpleTimeDamageParser 							--Смерть и разложение
-- DeathKnight.spells[45462]	= SimpleDamageParser 								--Удар чумы
-- DeathKnight.spells[45477]	= SimpleDamageParser 								--Ледяное прикосновение
-- DeathKnight.spells[45524]	= ChainsOfIce 										--Ледяные оковы
-- DeathKnight.spells[47541]	= DeathCoil 										--Лик смерти
-- DeathKnight.spells[47568]	= EmpowerRuneWeapon 								--Усиление рунического оружия
-- DeathKnight.spells[48743]	= DeathPact 										--Смертельный союз
-- DeathKnight.spells[49020]	= SimpleDamageParser 								--Уничтожение
-- DeathKnight.spells[49143]	= SimpleDamageParser 								--Ледяной удар
-- DeathKnight.spells[49184]	= SimpleDamageParser 								--Воющий ветер
-- DeathKnight.spells[49998]	= DoubleParser:create(SpellDamageAndHeal, 1, 2)		--Удар смерти
-- DeathKnight.spells[50842]	= SimpleDamageParser 								--Вскипание крови
-- DeathKnight.spells[55090]	= ScourgeStrike 									--Удар Плети
-- DeathKnight.spells[85948]	= SimpleDamageParser 								--Удар разложения
-- DeathKnight.spells[108196]	= DeathSiphon			 							--Смертельное поглощение
-- DeathKnight.spells[114866]	= SimpleDamageParser 								--Жнец душ
-- DeathKnight.spells[130735]	= SimpleDamageParser 								--Жнец душ
-- DeathKnight.spells[130736]	= SimpleDamageParser 								--Жнец душ
-- DeathKnight.spells[119975]	= Conversion 										--Преобразование
-- DeathKnight.spells[152279]	= SimpleTimeDamageParser 							--Дыхание Синдрагосы
-- DeathKnight.spells[152280]	= SimpleTimeDamageParser2 							--Осквернение

-- DeathKnight.spells[53717]	= SimpleDamageParser2 								--Взрыв трупа

-- -- Антимагический панцирь ?

-- -------------------------------------------------------------------------------

-- local locale = GetLocale()

-- if locale == "enGB" or locale == "enUS" then
-- 	DeathKnight.spells[53717]	= SimpleDamageParser 								--Взрыв трупа
-- 	return
-- end

-- if locale == "deDE" then
-- 	DeathKnight.spells[43265]	= SimpleTimeDamageParser2 							--Смерть и разложение
-- 	return
-- end

-- if locale == "esES" then
-- 	DeathKnight.spells[53717]	= SimpleDamageParser 								--Взрыв трупа
-- 	return
-- end

-- if locale == "frFR" then
-- 	DeathKnight.spells[53717]	= SimpleDamageParser 								--Взрыв трупа
-- 	return
-- end

-- if locale == "itIT" then
-- 	DeathKnight.spells[152280]	= SimpleTimeDamageParser 							--Осквернение
-- 	DeathKnight.spells[53717]	= SimpleDamageParser 								--Взрыв трупа
-- 	return
-- end

-- if locale == "ptBR" then
-- 	DeathKnight.spells[53717]	= SimpleDamageParser 								--Взрыв трупа
-- 	return
-- end

-- if locale == "zhCN" then
-- 	DeathKnight.spells[43265]	= SimpleTimeDamageParser2 							--Смерть и разложение
-- 	return
-- end
