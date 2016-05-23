local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Warlock = Class:create(ClassSpells)
Warlock.dependFromTarget = true
SD.classes["WARLOCK"] = Warlock

function Warlock:init()
	local HauntComputeFunc = function(data)
		if UnitExists("target") and UnitDebuff("target", L["haunt"]) then
			data.timeDamage = data.timeDamage * 1.35
		end
	end

	local TimeDamageHaunt = function(indexes)
		return TimeDamage(indexes, HauntComputeFunc)
	end

	--Канал здоровья:
	local HealthFunnel = function(data)
		data.type = SpellHeal

		if Glyphs:contains(56238) then		--Символ канала здоровья
			data.heal = UnitHealthMax("pet") * 0.15
		else
			data.heal = UnitHealthMax("pet") * 0.36
		end
	end

	--Жизнеотвод:
	local LifeTap = function(data, description)
		local match = nil
		
		if Glyphs:contains(63320) then		--Символ жизнеотвода
			match = matchDigit(description, 2)
		else
			match = matchDigit(description, 1)
		end

		if match then
			data.type = SpellMana
			data.mana = match
		end
	end

	--Углеотвод:
	local EmberTap = function(data, match)
		data.heal = match * UnitHealthMax("player") / 100
	end

	--Стрела Хаоса:
	local ChaosBolt = function(data)
		data.damage = data.damage * 2 * (100 + GetRangedCritChance()) / 100
	end

	self.spells[172]	= TimeDamageHaunt({ru=1, de=2, cn=2, tw=2, kr=2}) 							--Порча
	self.spells[348]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}) 	--Жертвенный огонь
	self.spells[108686]	= DamageAndTimeDamage({ru={2,3}, de={2,4}, cn={2,4}, tw={2,4}, kr={2,4}}) 	--Жертвенный огонь
	self.spells[686]	= Damage({ru=1}) 															--Стрела Тьмы
	self.spells[689]	= DamageAndTimeHeal({ru={1,2}, de={2,3}, cn={2,3}, tw={2,3}, kr={2,3}}) 	--Похищение жизни
	self.spells[755]	= Custom(HealthFunnel) 														--Канал здоровья
	self.spells[980]	= TimeDamageHaunt({ru=1, de=2, cn=2, tw=2, kr=2}) 							--Агония
	self.spells[1122]	= Damage({ru=1, it=2})  													--Призыв инфернала
	self.spells[1454]	= Custom(LifeTap) 															--Жизнеотвод
	self.spells[1949]	= TimeDamageHaunt({ru=2, kr=3}) 											--Адское пламя
	self.spells[5740]	= TimeDamageHaunt({ru=1, de=2, cn=2, tw=2, kr=2}) 							--Огненный ливень
	self.spells[104232]	= TimeDamageHaunt({ru=1, tw=2, kr=2}) 										--Огненный ливень
	self.spells[6353]	= CriticalDamage({ru=1}) 													--Ожог души
	self.spells[104027]	= self.spells[6353] 														--Ожог души
	self.spells[6789]	= Heal({ru=2}) 																--Лик тлена
	self.spells[17877]	= Damage({ru=1, en=2, de=2, es=2, fr=2, it=2, pt=2, cn=2, tw=2, kr=2}) 		--Ожог Тьмы
	self.spells[17962]	= Damage({ru=1}) 															--Поджигание
	self.spells[108685]	= Damage({ru=2, en=1, en=1, fr=1, it=1, pt=1}) 								--Поджигание
	self.spells[27243]	= TimeDamageHaunt({ru=1, de=2, cn=2, tw=2, kr=2}) 							--Семя порчи
	self.spells[29722]	= Damage({ru=1}) 															--Испепеление
	self.spells[114654]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}) 									--Испепеление
	self.spells[30108]	= TimeDamageHaunt({ru=1, de=2, cn=2, tw=2, kr=2}) 							--Нестабильное колдовство
	self.spells[48181]	= TimeDamage({ru=1}) 														--Блуждающий дух
	self.spells[103103]	= TimeDamageHaunt({ru=1, cn=2, kr=2}) 										--Похищение души
	self.spells[105174]	= DamageAndTimeDamage({ru={2,3}, de={2,4}, tw={2,4}, kr={2,4}}) 			--Рука Гул'дана
	self.spells[114635]	= Heal({ru=1}, EmberTap) 													--Углеотвод
	self.spells[116858]	= Damage({ru=1}, ChaosBolt) 												--Стрела Хаоса
	self.spells[157701]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}, ChaosBolt) 						--Стрела Хаоса
	self.spells[152108]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}) 	 								--Катаклизм
	self.spells[157695]	= Damage({ru=1}) 															--Демонический заряд
	self.spells[603]	= TimeDamage({ru=1}) 														--Рок
	self.spells[103964]	= Damage({ru=1}) 															--Касание Хаоса
	self.spells[104025]	= TimeDamage({ru=1}) 														--Жар преисподней
	self.spells[124916]	= Damage({ru=2, it=1}) 														--Волна Хаоса
end
