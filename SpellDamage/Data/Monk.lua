local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex, AverageDamage = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex, SD.AverageDamage
local Glyphs = SD.Glyphs

--

local Monk = Class:create(ClassSpells)
Monk.dependFromTarget = true
Monk.dependFromPower = true
Monk.dependPowerTypes["CHI"] = true
SD.classes["MONK"] = Monk

function Monk:init()
	local SPELL_POWER_LIGHT_FORCE = 12
	local Chi = function()
		local chi = UnitPower("player", SPELL_POWER_LIGHT_FORCE) or 0
		if chi > 4 then chi = 4 end
		return chi
	end

	--Танцующий журавль:
	local SpinningCraneKick = function(data, description)
		data.type = SpellEmpty
		
		local stanceIndex = GetShapeshiftForm()
		if stanceIndex ~= 0 then
			if 115070 == select(5, GetShapeshiftFormInfo(stanceIndex)) then 	--Стойка мудрой змеи
				data.type = SpellUnknown
				local match = matchDigit(description, getLocaleIndex({ru=3, de=4, fr=1, pt=1, cn=4, tw=4, kr=4}))
				if match then
					data.type = SpellTimeHeal
					data.timeHeal = match
				end
				return
			end
		end

		local match = matchDigit(description, getLocaleIndex({ru=1, de=3, cn=2, tw=2, kr=2}))
		if match then
			data.type = SpellTimeDamage
			data.timeDamage = match
		end
	end

	--Устранение вреда:
	local ExpelHarm = function(data, matchs)
		data.heal = (matchs[1] + matchs[2]) / 2
		data.damage = data.heal * 0.33
	end

	--Пламенное дыхание:
	local BreathOfFire = function(data)
		if UnitExists("target") and UnitDebuff("target", L["dizzying_haze"]) then
			data.type = SpellDamageAndTimeDamage
		else
			data.type = SpellDamage
		end
	end

	--Маначай:
	local ManaTea = function(data)
		data.type = SpellTimeMana
		local spirit = UnitStat("player", 5)
		data.timeMana = spirit * 3
	end

	--Призыв Сюэня, Белого Тигра:
	local InvokeXuenTheWhiteTiger = function(data)
		data.timeDamage = data.timeDamage * 45
	end

	--Сфера дзен:
	local ZenSphere = function(data, matchs)
		data.timeHeal = matchs[1] * 8 + matchs[4]
		data.timeDamage = matchs[2] * 8 + matchs[3]
	end

	--Взрыв ци:
	local ChiExplosion1 = function(data, matchs)
		local chi = Chi()
		data.damage = matchs[1] + (chi * matchs[2])

		if chi >= 2 then 
			data.timeDamage = data.damage * 0.5
		else
			data.type = SpellDamage
		end
	end

	--Взрыв ци:
	local ChiExplosion2 = function(data, matchs)
		local chi = Chi()
		data.heal = matchs[1] + (chi * matchs[2])

		if chi >= 2 then 
			data.timeHeal = data.heal * 0.5
		else
			data.type = SpellHeal
		end
	end

	--Взрыв ци:
	local ChiExplosion3 = function(data, description)
		local matchs = matchDigits(description, getLocaleIndex({ru={3,4}}))
		if matchs then
			data.type = SpellDamage
			data.damage = matchs[1] + (Chi() * matchs[2])
		end
	end

	--Дыхание Змеи:
	local BreathOfTheSerpent = function(data, match)
		data.timeHeal = match * 10
	end

	--Смертельное касание:
	local TouchOfDeath = function(data)
		data.type = SpellDamage
		data.damage = UnitHealthMax("player")
	end

	self.spells[100780] = AverageDamage({ru={1,2}}) 																			--Дзуки
	self.spells[108557] = self.spells[100780] 																					--Дзуки
	self.spells[108967] = Damage({ru=1}) 																						--Дзуки
	self.spells[109079] = Damage({ru=1}) 																						--Дзуки
	self.spells[115687] = self.spells[100780] 																					--Дзуки
	self.spells[115693] = self.spells[100780] 																					--Дзуки
	self.spells[115695] = self.spells[100780] 																					--Дзуки
	self.spells[115698] = self.spells[100780] 																					--Дзуки
	self.spells[130257] = Damage({ru=1}) 																						--Дзуки
	self.spells[100784] = AverageDamage({ru={1,2}}) 																			--Нокаутирующий удар
	self.spells[100787] = AverageDamage({ru={1,2}}) 																			--Лапа тигра
	self.spells[101545] = Damage({ru=2, de=3, cn=3, tw=3, kr=3}) 																--Удар летящего змея
	self.spells[101546] = Custom(SpinningCraneKick) 																			--Танцующий журавль
	self.spells[107428] = AverageDamage({ru={1,2}}) 																			--Удар восходящего солнца
	self.spells[113656] = TimeDamage({ru=1, de=4, cn=2, tw=2, kr=2}) 															--Неистовые кулаки
	self.spells[115008] = DamageAndHeal({ru={1,2}}) 																			--Ци-полет
	self.spells[115072] = DamageAndHeal({ru={1,2}}, ExpelHarm) 																	--Устранение вреда
	self.spells[115098] = DamageAndHeal({ru={1,2}})																				--Волна ци
	self.spells[115151] = TimeHeal({ru=1, de=2, cn=2, tw=2, kr=2}) 																--Заживляющий туман
	self.spells[115175] = TimeHeal({ru=2, en=1, es=1, fr=1, it=1, pt=1}) 														--Успокаивающий туман
	self.spells[115181] = DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1.3}, kr={1,3}}, BreathOfFire) 				--Пламенное дыхание
	self.spells[115288] = TimeMana({ru=1, de=4, cn=2, tw=2, kr=2})																--Будоражащий отвар
	self.spells[115294]	= Custom(ManaTea) 																						--Маначай
	self.spells[115295] = Absorb({ru=2, en=1, de=1, es=1, fr=1, it=1, pt=1, tw=1, kr=1}) 										--Защита
	self.spells[115310]	= Heal({ru=2, es=1, fr=1, pt=1}) 																		--Восстановление сил
	self.spells[116670] = Heal({ru=1}) 																							--Духовный подъем
	self.spells[116694] = Heal({ru=1}) 																							--Благотворный туман
	self.spells[116847] = TimeDamage({ru=1, de=3, cn=3, tw=3, kr=3}) 															--Порыв нефритового ветра
	self.spells[116849] = Absorb({ru=1}) 																						--Исцеляющий кокон
	self.spells[117952] = TimeDamage({ru=1, de=2, cn=2, tw=2, kr=2}) 															--Сверкающая нефритовая молния
	self.spells[121253] = AverageDamage({ru={1,2}, de={2,3}, cn={2,3}, tw={2,3},kr={2,3}}) 										--Удар бочонком
	self.spells[123904] = TimeDamage({ru=4, en=5, de=5, es=5, fr=5, it=5, pt=5, cn=5, tw=5, kr=5}, InvokeXuenTheWhiteTiger) 	--Призыв Сюэня, Белого Тигра
	self.spells[123986] = DamageAndHeal({ru={2,3}}) 																			--Выброс ци
	self.spells[124081]	= TimeDamageAndTimeHeal({ru={1,2,7,8}, en={1,2,6,7}, de={2,4,7,8}, es={1,2,6,7}, fr={1,2,6,7}, it={1,2,6,7}, pt={1,2,6,7}, cn={2,4,7,8}, tw={2,4,7,8}, kr={2,4,7,8}}, ZenSphere) 	--Сфера дзен
	self.spells[124682] = TimeHeal({ru=2, en=1, es=1, fr=1, it=1, pt=1}) 														--Окутывающий туман
	self.spells[152174] = DamageAndTimeDamage({ru={3,4}}, ChiExplosion1) 														--Взрыв ци
	self.spells[157675] = HealAndTimeHeal({ru={3,4}}, ChiExplosion2) 															--Взрыв ци
	self.spells[157676] = Custom(ChiExplosion3) 																				--Взрыв ци
	self.spells[152175] = AverageDamage({ru={2,3}, de={3,4}, cn={3,4}, tw={3,4}, kr={3,4}}) 									--Ураганный удар
	self.spells[157535]	= TimeHeal({ru=2, de=3, cn=3, tw=3}, BreathOfTheSerpent) 												--Дыхание Змеи
	self.spells[115080]	= Custom(TouchOfDeath) 																					--Смертельное касание
end
