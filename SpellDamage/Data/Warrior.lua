local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
local Glyphs = SD.Glyphs

--

--Кровопускание:
local Rend = MultiParser:create(SpellTimeDamage, {1, 3}, function(data, match)
	data.timeDamage = match[1] + match[3]
end)

--Вихрь:
local Whirlwind = CustomParser:create(function(data, description)
	data.type = SpellEmpty
	local currentSpecNum = GetSpecialization()
	if currentSpecNum then
		local currentSpecId = GetSpecializationInfo(currentSpecNum)
		if currentSpecId == 71 then 		--"Оружие"
			local match = matchDigit(description, 2)
			if match then
				data.type = SpellDamage
				data.damage = match
			end
		elseif currentSpecId == 72 then		--Неистовство
			local match = matchDigits(description, {2, 3})
			if match then
				data.type = SpellDamage
				data.damage = match[2] + match[3]
			end
		else
			data.type = SpellEmpty			--Защита"
		end
	end
end)

--Казнь:
local Execute = MultiParser:create(SpellDamage, {1}, function(data, match)
	data.damage = match[1]
	
	local currentSpecNum = GetSpecialization()
	if currentSpecNum then
		local currentSpecId = GetSpecializationInfo(currentSpecNum)
		if currentSpecId == 72 then		--Неистовство
			local match = matchDigit(description, 2)
			if match then
				data.damage = data.damage + match
			end
		end
	end
end)

--Реванш:
local Revenge = MultiParser:create(SpellDamageAndMana, {1, 3}, function(data, match)
	data.damage = match[1]
	data.mana = match[3]
end)

--Кровожадность:
local Bloodthirst = MultiParser:create(SpellDamageAndHeal, {1, 3}, function(data, match)
	data.damage = match[1]
	data.heal = match[3] * UnitHealthMax("player") / 100
end)

--Мощный удар щитом:
local ShieldSlam = MultiParser:create(SpellDamageAndMana, {1, 2}, function(data, match)
	data.damage = match[1]
	data.mana = match[2]
end)

--Победный раж:
local VictoryRush = MultiParser:create(SpellDamageAndHeal, {1, 2}, function(data, match)
	data.damage = match[1]
	data.heal = match[2] * UnitHealthMax("player") / 100
end)

--Вихрь клинков
local Bladestorm = CustomParser:create(function(data, description)
	local currentSpecNum = GetSpecialization()
	if currentSpecNum then
		local currentSpecId = GetSpecializationInfo(currentSpecNum)
		if currentSpecId == 72 then		--Неистовство
			local match = matchDigits(description, {2, 3, 5})
			if match then
				data.type = SpellTimeDamage
				data.timeDamage = (match[2] + match[3]) * match[5]
			end
		else 							--Оружее и Защита
			local match = matchDigits(description, {2, 4})
			if match then
				data.type = SpellTimeDamage
				data.timeDamage = match[2] * match[4]
			end
		end
	end
end)

--Безудержное восстановление:
local EnragedRegeneration = MultiParser:create(SpellHealAndTimeHeal, {1, 2}, function(data, match)
	local maxHealth = UnitHealthMax("player")
	data.heal = match[1] * maxHealth / 100
	data.timeHeal = match[2] * maxHealth / 100
end)

--Яростный выпад:
local RagingBlow = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1] + match[2]
end)

--Верная победа:
local ImpendingVictory = VictoryRush

--Рев дракона
local DragonRoar = MultiParser:create(SpellDamage, {1}, function(data, match)
	data.damage = match[1] * 2
end)

--Опустошитель:
local Ravager = MultiParser:create(SpellTimeDamage, {1, 4}, function(data, match)
	data.timeDamage = match[1] * match[4]
end)

local Warrior = Class:create(ClassSpells)
SD.Warrior = Warrior
Warrior.spells[78]		= SimpleDamageParser 	--Удар героя
Warrior.spells[100]		= SimpleManaParser2 	--Рывок
Warrior.spells[772]		= Rend 					--Кровопускание
Warrior.spells[1464]	= SimpleDamageParser 	--Мощный удар
Warrior.spells[1680]	= Whirlwind 			--Вихрь
Warrior.spells[1715]	= SimpleDamageParser 	--Подрезать сухожилия
Warrior.spells[5308]	= Execute 				--Казнь
Warrior.spells[163201]	= Execute 				--Казнь
Warrior.spells[6343]	= SimpleDamageParser2 	--Удар грома
Warrior.spells[6544]	= SimpleDamageParser2 	--Героический прыжок
Warrior.spells[6572]	= Revenge 				--Реванш
Warrior.spells[12294]	= SimpleDamageParser 	--Смертельный удар
Warrior.spells[20243]	= SimpleDamageParser 	--Сокрушение
Warrior.spells[23881]	= Bloodthirst 			--Кровожадность
Warrior.spells[23922]	= ShieldSlam 			--Мощный удар щитом
Warrior.spells[34428]	= VictoryRush 			--Победный раж
Warrior.spells[46924]	= Bladestorm 			--Вихрь клинков
Warrior.spells[46968]	= SimpleDamageParser 	--Ударная волна
Warrior.spells[55694]	= EnragedRegeneration 	--Безудержное восстановление
Warrior.spells[57755]	= SimpleDamageParser 	--Героический бросок
Warrior.spells[64382]	= SimpleDamageParser 	--Сокрушительный бросок
Warrior.spells[85288]	= RagingBlow 			--Яростный выпад
Warrior.spells[100130]	= SimpleDamageParser 	--Зверский удар
Warrior.spells[103840]	= ImpendingVictory 		--Верная победа
Warrior.spells[145585]	= SimpleDamageParser 	--Удар громовержца левой рукой
Warrior.spells[107570]	= SimpleDamageParser 	--Удар громовержца
Warrior.spells[118000]	= DragonRoar 			--Рев дракона
Warrior.spells[152277]	= Ravager 				--Опустошитель
Warrior.spells[156287]	= Ravager 				--Опустошитель
Warrior.spells[167105]	= SimpleDamageParser 	--Удар колосса
Warrior.spells[174926]	= SimpleAbsorbParser 	--Непроницаемый щит
Warrior.spells[112048]	= SimpleAbsorbParser 	--Непроницаемый щит
Warrior.spells[176289]	= SimpleDamageParser 	--Стенолом
Warrior.spells[176318]	= SimpleDamageParser 	--Стенолом – левая рука

Warrior.spells[163558]	= SimpleDamageParser 	--Внезапная казнь

--Глубокие раны ?

-------------------------------------------------------------------------------

local locale = GetLocale()

if locale == "enGB" or locale == "enUS" then
	Warrior.spells[6544]	= SimpleDamageParser 	--Героический прыжок
	return
end

if locale == "deDE" then
	--Кровопускание:
	local Rend_de = MultiParser:create(SpellTimeDamage, {2, 3}, function(data, match)
		data.timeDamage = match[2] + match[3]
	end)

	--Вихрь клинков
	local Bladestorm_de = CustomParser:create(function(data, description)
		local currentSpecNum = GetSpecialization()
		if currentSpecNum then
			local currentSpecId = GetSpecializationInfo(currentSpecNum)
			if currentSpecId == 72 then		--Неистовство
				local match = matchDigits(description, {2, 4, 5})
				if match then
					data.type = SpellTimeDamage
					data.timeDamage = (match[4] + match[5]) * match[2]
				end
			else 							--Оружее и Защита
				local match = matchDigits(description, {2, 4})
				if match then
					data.type = SpellTimeDamage
					data.timeDamage = match[4] * match[2]
				end
			end
		end
	end)

	--Рев дракона
	local DragonRoar_de = MultiParser:create(SpellDamage, {2}, function(data, match)
		data.damage = match[2] * 2
	end)

	--Опустошитель:
	local Ravager_de = MultiParser:create(SpellTimeDamage, {3, 4}, function(data, match)
		data.timeDamage = match[3] * match[4]
	end)

	Warrior.spells[100]		= SimpleManaParser 		--Рывок
	Warrior.spells[772]		= Rend_de 				--Кровопускание
	Warrior.spells[46924]	= Bladestorm_de 		--Вихрь клинков
	Warrior.spells[46968]	= SimpleDamageParser2 	--Ударная волна
	Warrior.spells[118000]	= DragonRoar_de 		--Рев дракона
	Warrior.spells[152277]	= Ravager_de 			--Опустошитель
	Warrior.spells[156287]	= Ravager_de 			--Опустошитель
	Warrior.spells[174926]	= SimpleAbsorbParser2 	--Непроницаемый щит
	Warrior.spells[112048]	= SimpleAbsorbParser2 	--Непроницаемый щит
	return
end

if locale == "esES" then
	Warrior.spells[6544]	= SimpleDamageParser 	--Героический прыжок
	return
end

if locale == "frFR" then
	Warrior.spells[6544]	= SimpleDamageParser 	--Героический прыжок
	return
end

if locale == "itIT" then
	Warrior.spells[6544]	= SimpleDamageParser 	--Героический прыжок
	return
end

if locale == "ptBR" then
	
	return
end

if locale == "zhCN" then
	----Реванш:
	local Revenge_cn = MultiParser:create(SpellDamageAndMana, {3, 5}, function(data, match)
		data.damage = match[3]
		data.mana = match[5]
	end)

	--Вихрь клинков
	local Bladestorm_cn = CustomParser:create(function(data, description)
		local currentSpecNum = GetSpecialization()
		if currentSpecNum then
			local currentSpecId = GetSpecializationInfo(currentSpecNum)
			if currentSpecId == 72 then		--Неистовство
				local match = matchDigits(description, {3, 4, 5})
				if match then
					data.type = SpellTimeDamage
					data.timeDamage = (match[3] + match[4]) * match[5]
				end
			else 							--Оружее и Защита
				local match = matchDigits(description, {3, 4})
				if match then
					data.type = SpellTimeDamage
					data.timeDamage = match[3] * match[4]
				end
			end
		end
	end)

	--Безудержное восстановление:
	local EnragedRegeneration_cn = MultiParser:create(SpellHealAndTimeHeal, {1, 3}, function(data, match)
		local maxHealth = UnitHealthMax("player")
		data.heal = match[1] * maxHealth / 100
		data.timeHeal = match[3] * maxHealth / 100
	end)

	--Рев дракона
	local DragonRoar_cn = MultiParser:create(SpellDamage, {2}, function(data, match)
		data.damage = match[2] * 2
	end)

	--Опустошитель:
	local Ravager_cn = MultiParser:create(SpellTimeDamage, {3, 4}, function(data, match)
		data.timeDamage = match[3] * match[4]
	end)

	Warrior.spells[6572]	= Revenge_cn 				--Реванш
	Warrior.spells[46924]	= Bladestorm_cn 			--Вихрь клинков
	Warrior.spells[55694]	= EnragedRegeneration_cn 	--Безудержное восстановление
	Warrior.spells[118000]	= DragonRoar_cn 			--Рев дракона
	Warrior.spells[152277]	= Ravager_cn 			--Опустошитель
	Warrior.spells[156287]	= Ravager_cn 			--Опустошитель
	return
end