local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
local Glyphs = SD.Glyphs

--

local SPELL_POWER_LIGHT_FORCE = 12

--Танцующий журавль:
local SpinningCraneKick = CustomParser:create(function(data, description)
	data.type = SpellEmpty
	
	local match = matchDigit(description, 1)
	if match then
		data.type = SpellTimeDamage
		data.timeDamage = match
	end

	local stanceIndex = GetShapeshiftForm()
	if stanceIndex ~= 0 then
		if 115070 == select(5, GetShapeshiftFormInfo(stanceIndex)) then 	--Стойка мудрой змеи
			data.type = SpellUnknown
			local match = matchDigit(description, 3)
			if match then
				data.type = SpellTimeHeal
				data.timeHeal = match
			end
		end
	end
end)

--Устранение вреда:
local ExpelHarm = MultiParser:create(SpellDamageAndHeal, {1, 2, 4}, function(data, match)
	data.heal = (match[1] + match[2]) / 2
	data.damage = data.heal * match[4] / 100
end)

--Пламенное дыхание:
local BreathOfFire = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1]
	if UnitExists("target") and UnitDebuff("target", L["dizzying_haze"]) then
		data.type = SpellDamageAndTimeDamage
		data.timeDamage = match[2]
	end
end)

--Маначай:
local ManaTea = MultiParser:create(SpellTimeMana, {3}, function(data, match)
	local spirit = UnitStat("player", 5)
	data.timeMana = spirit * 3
end)

--Призыв Сюэня, Белого Тигра:
local InvokeXuenTheWhiteTiger = MultiParser:create(SpellTimeDamage, {4}, function(data, match)
	data.timeDamage = match[4] * 45
end)

--Сфера дзен:
local ZenSphere = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 2, 7, 8}, function(data, match)
	data.timeHeal = match[1] * 8 + match[8]
	data.timeDamage = match[2] * 8 + match[7]
end)

--Взрыв ци:
local ChiExplosion1 = MultiParser:create(SpellDamage, {3, 4}, function(data, match)
	local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
	if chi > 4 then chi = 4 end
	data.damage = match[3] + (chi * match[4])

	if chi >= 2 then 
		data.type = SpellDamageAndTimeDamage
		data.timeDamage = data.damage * 0.5
	end
end)

--Взрыв ци:
local ChiExplosion2 = MultiParser:create(SpellHeal, {3, 4}, function(data, match)
	local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
	if chi > 4 then chi = 4 end
	data.heal = match[3] + (chi * match[4])

	if chi >= 2 then 
		data.type = SpellHealAndTimeHeal
		data.timeHeal = data.heal * 0.5
	end
end)

--Взрыв ци:
local ChiExplosion3 = MultiParser:create(SpellDamage, {3, 4}, function(data, match)
	local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
	if chi > 4 then chi = 4 end
	data.damage = match[3] + (chi * match[4])
end)

--Ураганный удар:
local HurricaneStrike = MultiParser:create(SpellTimeDamage, {2, 3}, function(data, match)
	data.timeDamage = (match[2] + match[3]) / 2
end)

--Дыхание Змеи:
local BreathOfTheSerpent = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
	data.timeHeal = match[2] * 10
end)

--Смертельное касание:
local TouchOfDeath = CustomParser:create(function(data, description)
	data.type = SpellDamage
	data.damage = UnitHealthMax("player")
end)

local Monk = Class:create(ClassSpells)
SD.Monk = Monk
Monk.dependFromTarget = true
Monk.dependFromPower = true
Monk.dependPowerTypes["CHI"] = true
Monk.spells[100780] = SimpleAverageParser 							--Дзуки
Monk.spells[108557] = SimpleAverageParser 							--Дзуки
Monk.spells[108967] = SimpleAverageParser 							--Дзуки
Monk.spells[109079] = SimpleAverageParser 							--Дзуки
Monk.spells[115687] = SimpleAverageParser 							--Дзуки
Monk.spells[115693] = SimpleAverageParser 							--Дзуки
Monk.spells[115695] = SimpleAverageParser 							--Дзуки
Monk.spells[115698] = SimpleAverageParser 							--Дзуки
Monk.spells[125661] = SimpleAverageParser 							--Дзуки
Monk.spells[128678] = SimpleAverageParser 							--Дзуки
Monk.spells[130257] = SimpleAverageParser 							--Дзуки
Monk.spells[100784] = SimpleAverageParser 							--Нокаутирующий удар
Monk.spells[100787] = SimpleAverageParser 							--Лапа тигра
Monk.spells[101545] = SimpleDamageParser2 							--Удар летящего змея
Monk.spells[101546] = SpinningCraneKick 							--Танцующий журавль
Monk.spells[107428] = SimpleAverageParser 							--Удар восходящего солнца
Monk.spells[113656] = SimpleTimeDamageParser 						--Неистовые кулаки
Monk.spells[115008] = DoubleParser:create(SpellDamageAndHeal, 1, 2) --Ци-полет
Monk.spells[115072] = ExpelHarm 									--Устранение вреда
Monk.spells[115098] = DoubleParser:create(SpellDamageAndHeal, 1, 2)	--Волна ци
Monk.spells[115151] = SimpleTimeHealParser 							--Заживляющий туман
Monk.spells[115175] = SimpleTimeHealParser2 						--Успокаивающий туман
Monk.spells[115181] = BreathOfFire 									--Пламенное дыхание
Monk.spells[115288] = SimpleTimeManaParser							--Будоражащий отвар
Monk.spells[115294]	= ManaTea 										--Маначай
Monk.spells[115295] = SimpleAbsorbParser2 							--Защита
Monk.spells[15310]	= SimpleHealParser2 							--Восстановление сил
Monk.spells[116670] = SimpleHealParser 								--Духовный подъем
Monk.spells[116694] = SimpleHealParser 								--Благотворный туман
Monk.spells[116847] = SimpleTimeDamageParser 						--Порыв нефритового ветра
Monk.spells[116849] = SimpleAbsorbParser 							--Исцеляющий кокон
Monk.spells[117952] = SimpleTimeDamageParser 						--Сверкающая нефритовая молния
Monk.spells[121253] = SimpleAverageParser 							--Удар бочонком
Monk.spells[123904] = InvokeXuenTheWhiteTiger 						--Призыв Сюэня, Белого Тигра
Monk.spells[123986] = DoubleParser:create(SpellDamageAndHeal, 2, 3) --Выброс ци
Monk.spells[124081]	= ZenSphere 									--Сфера дзен
Monk.spells[124682] = SimpleTimeHealParser2 						--Окутывающий туман
Monk.spells[152174] = ChiExplosion1 								--Взрыв ци
Monk.spells[157675] = ChiExplosion2 								--Взрыв ци
Monk.spells[157676] = ChiExplosion3 								--Взрыв ци
Monk.spells[152175] = HurricaneStrike 								--Ураганный удар
Monk.spells[157535]	= BreathOfTheSerpent 							--Дыхание Змеи
Monk.spells[115080]	= TouchOfDeath 									--Смертельное касание

-------------------------------------------------------------------------------

local locale = GetLocale()

if locale ~= "ruRU" then
	--Призыв Сюэня, Белого Тигра:
	local InvokeXuenTheWhiteTiger_notRu = MultiParser:create(SpellTimeDamage, {5}, function(data, match)
		data.timeDamage = match[5] * 45
	end)

	Monk.spells[123904] = InvokeXuenTheWhiteTiger_notRu 			--Призыв Сюэня, Белого Тигра
end

if locale == "enGB" or locale == "enUS" then
	--Устранение вреда:
	local ExpelHarm_en = MultiParser:create(SpellDamageAndHeal, {1, 2, 3}, function(data, match)
		data.heal = (match[1] + match[2]) / 2
		data.damage = data.heal * match[3] / 100
	end)

	--Сфера дзен:
	local ZenSphere_en = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 2, 6, 7}, function(data, match)
		data.timeHeal = match[1] * 8 + match[7]
		data.timeDamage = match[2] * 8 + match[6]
	end)

	Monk.spells[115072] = ExpelHarm_en 								--Устранение вреда
	Monk.spells[115175] = SimpleTimeHealParser 						--Успокаивающий туман
	Monk.spells[115295] = SimpleAbsorbParser 						--Защита
	Monk.spells[124081]	= ZenSphere_en 								--Сфера дзен
	Monk.spells[124682] = SimpleTimeHealParser 						--Окутывающий туман
	return
end

if locale == "deDE" then
	--Танцующий журавль:
	local SpinningCraneKick_de = CustomParser:create(function(data, description)
		local match = matchDigit(description, 3)
		if match then
			data.type = SpellTimeDamage
			data.timeDamage = match
		end

		local stanceIndex = GetShapeshiftForm()
		if stanceIndex ~= 0 then
			if 115070 == select(5, GetShapeshiftFormInfo(stanceIndex)) then 	--Стойка мудрой змеи
				data.type = SpellUnknown
				local match = matchDigit(description, 4)
				if match then
					data.type = SpellTimeHeal
					data.timeHeal = match
				end
			end
		end
	end)

	--Сфера дзен:
	local ZenSphere_de = MultiParser:create(SpellTimeDamageAndTimeHeal, {2, 4, 7, 8}, function(data, match)
		data.timeHeal = match[2] * 8 + match[8]
		data.timeDamage = match[4] * 8 + match[7]
	end)

	--Ураганный удар:
	local HurricaneStrike_de = MultiParser:create(SpellTimeDamage, {3, 4}, function(data, match)
		data.timeDamage = (match[3] + match[4]) / 2
	end)

	--Дыхание Змеи:
	local BreathOfTheSerpent_de = MultiParser:create(SpellTimeHeal, {3}, function(data, match)
		data.timeHeal = match[3] * 10
	end)

	Monk.spells[101545] = DoubleParser:create(SpellDamage, 3) 		--Удар летящего змея
	Monk.spells[101546] = SpinningCraneKick_de 						--Танцующий журавль
	Monk.spells[113656] = SimpleTimeDamageParser2 					--Неистовые кулаки
	Monk.spells[115151] = SimpleTimeHealParser2 					--Заживляющий туман
	Monk.spells[115288] = SimpleTimeManaParser2						--Будоражащий отвар
	Monk.spells[115295] = SimpleAbsorbParser 						--Защита
	Monk.spells[116847] = SimpleParser:create(SpellTimeDamage, 3) 	--Порыв нефритового ветра
	Monk.spells[117952] = SimpleTimeDamageParser2 					--Сверкающая нефритовая молния
	Monk.spells[121253] = AverageParser:create(2, 3) 				--Удар бочонком
	Monk.spells[124081]	= ZenSphere_de 								--Сфера дзен
	Monk.spells[152175] = HurricaneStrike_de 						--Ураганный удар
	Monk.spells[157535]	= BreathOfTheSerpent_de 					--Дыхание Змеи
	return
end

if locale == "esES" then
	--Устранение вреда:
	local ExpelHarm_es = MultiParser:create(SpellDamageAndHeal, {1, 2, 3}, function(data, match)
		data.heal = (match[1] + match[2]) / 2
		data.damage = data.heal * match[3] / 100
	end)

	--Сфера дзен:
	local ZenSphere_es = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 2, 6, 7}, function(data, match)
		data.timeHeal = match[1] * 8 + match[7]
		data.timeDamage = match[2] * 8 + match[6]
	end)

	Monk.spells[115072] = ExpelHarm_es 								--Устранение вреда
	Monk.spells[115175] = SimpleTimeHealParser 						--Успокаивающий туман
	Monk.spells[115295] = SimpleAbsorbParser 						--Защита
	Monk.spells[15310]	= SimpleHealParser 							--Восстановление сил
	Monk.spells[124081]	= ZenSphere_es 								--Сфера дзен
	Monk.spells[124682] = SimpleTimeHealParser 						--Окутывающий туман
	return
end

if locale == "frFR" then
	--Танцующий журавль:
	local SpinningCraneKick_fr = CustomParser:create(function(data, description)
		local match = matchDigit(description, 1)
		if match then
			data.type = SpellTimeDamage
			data.timeDamage = match
		end

		local stanceIndex = GetShapeshiftForm()
		if stanceIndex ~= 0 then
			if 115070 == select(5, GetShapeshiftFormInfo(stanceIndex)) then 	--Стойка мудрой змеи
				data.type = SpellTimeHeal
				data.timeHeal = match
			end
		end
	end)

	--Устранение вреда:
	local ExpelHarm_fr = MultiParser:create(SpellDamageAndHeal, {1, 2, 3}, function(data, match)
		data.heal = (match[1] + match[2]) / 2
		data.damage = data.heal * match[3] / 100
	end)

	--Сфера дзен:
	local ZenSphere_fe = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 2, 6, 7}, function(data, match)
		data.timeHeal = match[1] * 8 + match[7]
		data.timeDamage = match[2] * 8 + match[6]
	end)

	Monk.spells[101546] = SpinningCraneKick_fr 						--Танцующий журавль
	Monk.spells[115072] = ExpelHarm_fr 								--Устранение вреда
	Monk.spells[115175] = SimpleTimeHealParser 						--Успокаивающий туман
	Monk.spells[115295] = SimpleAbsorbParser 						--Защита
	Monk.spells[15310]	= SimpleHealParser 							--Восстановление сил
	Monk.spells[124081]	= ZenSphere_fr 								--Сфера дзен
	Monk.spells[124682] = SimpleTimeHealParser 						--Окутывающий туман
	return
end

if locale == "itIT" then
	--Сфера дзен:
	local ZenSphere_it = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 2, 6, 7}, function(data, match)
		data.timeHeal = match[1] * 8 + match[7]
		data.timeDamage = match[2] * 8 + match[6]
	end)

	Monk.spells[115175] = SimpleTimeHealParser 						--Успокаивающий туман
	Monk.spells[115295] = SimpleAbsorbParser 						--Защита
	Monk.spells[124081]	= ZenSphere_it 								--Сфера дзен
	Monk.spells[124682] = SimpleTimeHealParser 						--Окутывающий туман
	return
end

if locale == "ptBR" then
	--Танцующий журавль:
	local SpinningCraneKick_pt = CustomParser:create(function(data, description)
		local match = matchDigit(description, 1)
		if match then
			data.type = SpellTimeDamage
			data.timeDamage = match
		end

		local stanceIndex = GetShapeshiftForm()
		if stanceIndex ~= 0 then
			if 115070 == select(5, GetShapeshiftFormInfo(stanceIndex)) then 	--Стойка мудрой змеи
				data.type = SpellTimeHeal
				data.timeHeal = match
			end
		end
	end)

	--Устранение вреда:
	local ExpelHarm_pt = MultiParser:create(SpellDamageAndHeal, {1, 2, 3}, function(data, match)
		data.heal = (match[1] + match[2]) / 2
		data.damage = data.heal * match[3] / 100
	end)

	--Сфера дзен:
	local ZenSphere_pt = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 2, 6, 7}, function(data, match)
		data.timeHeal = match[1] * 8 + match[7]
		data.timeDamage = match[2] * 8 + match[6]
	end)

	Monk.spells[101546] = SpinningCraneKick_pt 						--Танцующий журавль
	Monk.spells[115072] = ExpelHarm_pt 								--Устранение вреда
	Monk.spells[115175] = SimpleTimeHealParser 						--Успокаивающий туман
	Monk.spells[115295] = SimpleAbsorbParser 						--Защита
	Monk.spells[15310]	= SimpleHealParser 							--Восстановление сил
	Monk.spells[124081]	= ZenSphere_pt 								--Сфера дзен
	Monk.spells[124682] = SimpleTimeHealParser 						--Окутывающий туман
	return
end

if locale == "zhCN" then
	--Танцующий журавль:
	local SpinningCraneKick_cn = CustomParser:create(function(data, description)
		local match = matchDigit(description, 2)
		if match then
			data.type = SpellTimeDamage
			data.timeDamage = match
		end

		local stanceIndex = GetShapeshiftForm()
		if stanceIndex ~= 0 then
			if 115070 == select(5, GetShapeshiftFormInfo(stanceIndex)) then 	--Стойка мудрой змеи
				data.type = SpellUnknown
				local match = matchDigit(description, 4)
				if match then
					data.type = SpellTimeHeal
					data.timeHeal = match
				end
			end
		end
	end)

	--Сфера дзен:
	local ZenSphere_cn = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 3, 6, 8}, function(data, match)
		data.timeHeal = match[1] * 8 + match[8]
		data.timeDamage = match[3] * 8 + match[6]
	end)

	--Взрыв ци:
	local ChiExplosion1_cn = MultiParser:create(SpellDamage, {3, 5}, function(data, match)
		local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
		if chi > 4 then chi = 4 end
		data.damage = match[3] + (chi * match[5])

		if chi >= 2 then 
			data.type = SpellDamageAndTimeDamage
			data.timeDamage = data.damage * 0.5
		end
	end)

	--Взрыв ци:
	local ChiExplosion2_cn = MultiParser:create(SpellHeal, {3, 5}, function(data, match)
		local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
		if chi > 4 then chi = 4 end
		data.heal = match[3] + (chi * match[5])

		if chi >= 2 then 
			data.type = SpellHealAndTimeHeal
			data.timeHeal = data.heal * 0.5
		end
	end)

	--Взрыв ци:
	local ChiExplosion3_cn = MultiParser:create(SpellDamage, {3, 5}, function(data, match)
		local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
		if chi > 4 then chi = 4 end
		data.damage = match[3] + (chi * match[5])
	end)

	--Ураганный удар:
	local HurricaneStrike_cn = MultiParser:create(SpellTimeDamage, {3, 4}, function(data, match)
		data.timeDamage = (match[3] + match[4]) / 2
	end)

	--Дыхание Змеи:
	local BreathOfTheSerpent_cn = MultiParser:create(SpellTimeHeal, {3}, function(data, match)
		data.timeHeal = match[3] * 10
	end)

	Monk.spells[101545] = DoubleParser:create(SpellDamage, 3) 		--Удар летящего змея
	Monk.spells[101546] = SpinningCraneKick_cn 						--Танцующий журавль
	Monk.spells[113656] = SimpleTimeDamageParser2 					--Неистовые кулаки
	Monk.spells[115151] = SimpleTimeHealParser2 					--Заживляющий туман
	Monk.spells[115288] = SimpleTimeManaParser2						--Будоражащий отвар
	Monk.spells[116847] = SimpleParser:create(SpellTimeDamage, 3) 	--Порыв нефритового ветра
	Monk.spells[117952] = SimpleTimeDamageParser2 					--Сверкающая нефритовая молния
	Monk.spells[121253] = AverageParser:create(2, 3) 				--Удар бочонком
	Monk.spells[124081]	= ZenSphere_cn 								--Сфера дзен
	Monk.spells[152174] = ChiExplosion1_cn 							--Взрыв ци
	Monk.spells[157675] = ChiExplosion2_cn 							--Взрыв ци
	Monk.spells[157676] = ChiExplosion3_cn 							--Взрыв ци
	Monk.spells[152175] = HurricaneStrike_cn 						--Ураганный удар
	Monk.spells[157535]	= BreathOfTheSerpent_cn 					--Дыхание Змеи
	return
end
