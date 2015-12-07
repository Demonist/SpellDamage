local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex, TimeDamageAndTimeDamage = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex, SD.TimeDamageAndTimeDamage
local Glyphs = SD.Glyphs

--

local Warrior = Class:create(ClassSpells)
SD.classes["WARRIOR"] = Warrior

function Warrior:init()
	--Рывок:
	local Charge = function(data)
		data.mana = 20
	end

	--Кровопускание:
	local Rend = function(data, matchs)
		data.timeDamage = matchs[1] + matchs[2]
	end

	--Вихрь:
	local Whirlwind = function(data, description)
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
				local matchs = matchDigits(description, {2,3})
				if matchDigits then
					data.type = SpellDamage
					data.damage = matchs[1] + matchs[2]
				end
			else
				data.type = SpellEmpty			--Защита"
			end
		end
	end

	--Казнь:
	local Execute = function(data, match, description)
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

		if Glyphs:contains(146971) then 	--Символ палача
			data.type = SpellDamageAndMana
			data.mana = 30
		end
	end

	--Кровожадность:
	local Bloodthirst = function(data, matchs)
		data.heal = matchs[2] * UnitHealthMax("player") / 100
	end

	--Мощный удар щитом:
	local ShieldSlam = function(data)
		data.mana = 20
	end

	--Победный раж:
	local VictoryRush = function(data, matchs)
		data.heal = matchs[2] * UnitHealthMax("player") / 100
	end

	--Вихрь клинков
	local Bladestorm = function(data, description)
		local currentSpecNum = GetSpecialization()
		if currentSpecNum then
			local currentSpecId = GetSpecializationInfo(currentSpecNum)
			if currentSpecId == 72 then		--Неистовство
				local matchs = matchDigits(description, getLocaleIndex({ru={2,3}, de={4,5}, cn={3,4}, tw={3,4}, kr={4,5}}))
				if matchs then
					data.type = SpellTimeDamage
					data.timeDamage = (matchs[1] + matchs[2]) * 6
				end
			else 							--Оружее и Защита
				local match = matchDigit(description, getLocaleIndex({ru=2, de=4, cn=3, tw=3, kr=4}))
				if match then
					data.type = SpellTimeDamage
					data.timeDamage = match * 6
				end
			end
		else
			data.type = SpellEmpty
		end
	end

	--Безудержное восстановление:
	local EnragedRegeneration = function(data, matchs)
		local maxHealth = UnitHealthMax("player")
		data.heal = matchs[1] * maxHealth / 100
		data.timeHeal = matchs[2] * maxHealth / 100
	end

	--Опустошитель:
	local Ravager = function(data, match)
		data.timeDamage = match * 10
	end

	self.spells[78]		= Damage({ru=1}) 																	--Удар героя
	self.spells[100]	= Mana({ru=1}, Charge)																--Рывок
	self.spells[772]	= TimeDamageAndTimeDamage({ru={1,3}, de={2,3}, cn={2,3}, tw={2,3}, kr={2,3}}, Rend) --Кровопускание
	self.spells[1464]	= Damage({ru=1}) 																	--Мощный удар
	self.spells[1680]	= Custom(Whirlwind) 																--Вихрь
	self.spells[1715]	= Damage({ru=1}) 																	--Подрезать сухожилия
	self.spells[5308]	= Damage({ru=1}, Execute) 															--Казнь
	self.spells[163201]	= self.spells[5308]																	--Казнь
	self.spells[6343]	= Damage({ru=2})																	--Удар грома
	self.spells[6544]	= Damage({ru=2, en=1, es=1, fr=1, it=1}) 											--Героический прыжок
	self.spells[6572]	= DamageAndMana({ru={1, 3}, cn={1, 5}}) 											--Реванш
	self.spells[12294]	= Damage({ru=1}) 																	--Смертельный удар 
	self.spells[20243]	= Damage({ru=1}) 																	--Сокрушение
	self.spells[23881]	= DamageAndHeal({ru={1,3}}, Bloodthirst)											--Кровожадность
	self.spells[23922]	= DamageAndMana({ru={1,2}}, ShieldSlam) 											--Мощный удар щитом
	self.spells[34428]	= DamageAndHeal({ru={1,2}}, VictoryRush) 											--Победный раж
	self.spells[46924]	= Custom(Bladestorm) 																--Вихрь клинков
	self.spells[46968]	= Damage({ru=1, de=2, kr=2})														--Ударная волна
	self.spells[55694]	= HealAndTimeHeal({ru={1,2}, cn={1,3}, tw={1,3}, kr={1,3}}, EnragedRegeneration) 	--Безудержное восстановление
	self.spells[57755]	= Damage({ru=1})																	--Героический бросок
	self.spells[64382]	= Damage({ru=1})																	--Сокрушительный бросок
	self.spells[85288]	= DamageAndDamage({ru={1,2}}) 														--Яростный выпад
	self.spells[100130]	= Damage({ru=1})																	--Зверский удар
	self.spells[103840]	= self.spells[34428] 																--Верная победа
	self.spells[145585]	= Damage({ru=1})																	--Удар громовержца левой рукой
	self.spells[107570]	= Damage({ru=1})																	--Удар громовержца
	self.spells[118000]	= CriticalDamage({ru=1, de=2, cn=2, tw=2, kr=2}) 									--Рев дракона
	self.spells[152277]	= TimeDamage({ru=1, de=3, kr=3}, Ravager)											--Опустошитель
	self.spells[156287]	= self.spells[152277] 																--Опустошитель
	self.spells[167105]	= Damage({ru=1})																	--Удар колосса
	self.spells[174926]	= Absorb({ru=1}) 																	--Непроницаемый щит
	self.spells[112048]	= self.spells[174926] 																--Непроницаемый щит
	self.spells[176289]	= Damage({ru=1})																	--Стенолом
	self.spells[176318]	= self.spells[176289]																--Стенолом – левая рука
	self.spells[163558]	= self.spells[5308] 																--Внезапная казнь
end
