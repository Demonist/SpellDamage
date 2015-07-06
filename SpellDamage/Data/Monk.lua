local SPELL_POWER_LIGHT_FORCE = 12

--Пламенное дыхание:
local BreathOfFire = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1]
	if UnitDebuff("target", "Хмельная дымка") then
		data.type = SpellDamageAndTimeDamage
		data.timeDamage = match[2]
	end
end)

--Устранение вреда:
local ExpelHarm = MultiParser:create(SpellDamageAndHeal, {1, 2, 4}, function(data, match)
	data.heal = (match[1] + match[2]) / 2
	data.damage = data.heal * match[4] / 100
end)

--Сфера дзен:
local ZenSphere = MultiParser:create(SpellTimeDamageAndTimeHeal, {1, 2}, function(data, match)
	data.timeHeal = match[1] * 8
	data.timeDamage = match[2] * 8
end)

--Маначай:
local ManaTea = MultiParser:create(SpellTimeHeal, {3}, function(data, match)
	local spirit = UnitStat("player", 5)
	data.timeHeal = match[3] * spirit
end)

--Танцующий журавль:
local SpinningCraneKick = CustomParser:create(function(data, description)
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

--Дыхание Змеи:
local BreathOfTheSerpent = MultiParser:create(SpellTimeHeal, {2, 4}, function(data, match)
	data.timeHeal = match[2] * match[4]
end)

--Ураганный удар:
local HurricaneStrike = MultiParser:create(SpellTimeDamage, {2, 3}, function(data, match)
	data.timeDamage = (match[2] + match[3]) / 2
end)

--Взрыв ци:
local ChiExplosion1 = MultiParser:create(SpellDamage, {3, 4, 6}, function(data, match)
	local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
	data.heal = match[3] + (chi * match[4])
	if chi > 0 then 
		data.type = SpellDamageAndTimeDamage
		data.timeDamage = match[6]
	end
end)

--Взрыв ци:
local ChiExplosion2 = MultiParser:create(SpellHeal, {3, 4, 6}, function(data, match)
	local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
	data.damage = match[3] + (chi * match[4])
	if chi > 0 then 
		data.type = SpellHealAndTimeHeal
		data.timeHeal = match[6]
	end
end)

--Взрыв ци:
local ChiExplosion3 = MultiParser:create(SpellDamage, {3, 4}, function(data, match)
	local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE)
	data.damage = match[3] + (chi * match[4])
end)

Monk = Class:create(ClassSpells)
Monk.dependFromTarget = true
Monk.dependFromPower = true
Monk.dependPowerTypes["CHI"] = true
Monk.spells[100780] = SimpleAverageParser 							--Дзуки
Monk.spells[108557] = SimpleAverageParser 							--Дзуки
Monk.spells[115698] = SimpleAverageParser 							--Дзуки
Monk.spells[115695] = SimpleAverageParser 							--Дзуки
Monk.spells[100787] = SimpleAverageParser 							--Лапа тигра
Monk.spells[100784] = SimpleAverageParser 							--Нокаутирующий удар
Monk.spells[113656] = SimpleTimeDamageParser 						--Неистовые кулаки
Monk.spells[115175] = SimpleTimeHealParser2 						--Успокаивающий туман
Monk.spells[121253] = SimpleAverageParser 							--Удар бочонком
Monk.spells[116694] = SimpleHealParser 								--Благотворный туман
Monk.spells[124682] = SimpleTimeHealParser2 						--Окутывающий туман
Monk.spells[115181] = BreathOfFire 									--Пламенное дыхание
Monk.spells[101545] = SimpleDamageParser2 							--Удар летящего змея
Monk.spells[115151] = SimpleTimeHealParser2 						--Заживляющий туман
Monk.spells[115295] = SimpleParser:create(SpellAbsorb, 2) 			--Защита
Monk.spells[115072] = ExpelHarm 									--Устранение вреда
Monk.spells[115098] = DoubleParser:create(SpellDamageAndHeal, 1, 2)	--Волна ци
Monk.spells[123986] = DoubleParser:create(SpellDamageAndHeal, 2, 3) --Выброс ци
Monk.spells[124081]	= ZenSphere 									--Сфера дзен
Monk.spells[115288] = SimpleTimeManaParser							--Будоражащий отвар
Monk.spells[101546] = SpinningCraneKick 							--Танцующий журавль
Monk.spells[116849] = SimpleAbsorbParser 							--Исцеляющий кокон
Monk.spells[117952] = SimpleTimeDamageParser 						--Сверкающая нефритовая молния
Monk.spells[107428] = SimpleAverageParser 							--Удар восходящего солнца
Monk.spells[115294]	= ManaTea 										--Маначай
Monk.spells[116670] = SimpleHealParser 								--Духовный подъем
Monk.spells[15310]	= SimpleHealParser2 							--Восстановление сил
Monk.spells[116847] = SimpleTimeDamageParser 						--Порыв нефритового ветра
Monk.spells[152174] = ChiExplosion1 								--Взрыв ци
Monk.spells[157675] = ChiExplosion2 								--Взрыв ци
Monk.spells[157676] = ChiExplosion3 								--Взрыв ци
Monk.spells[157535]	= BreathOfTheSerpent 							--Дыхание Змеи
Monk.spells[152175] = HurricaneStrike 								--Ураганный удар
