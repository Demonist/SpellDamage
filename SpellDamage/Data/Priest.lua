local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Priest = Class:create(ClassSpells)
Priest.dependFromTarget = true
SD.classes["PRIEST"] = Priest

function Priest:init()
	--Слово силы: Утешение:
	local PowerWordSolace = function(data)
		data.type = SpellDamageAndMana
		data.mana = UnitManaMax("player") * 0.0075
	end

	--Тело и разум:
	local BodyAndMind = function(data)
		data.timeHeal = data.timeHeal * 4
	end

	--Прикосновение вампира:
	local VampiricTouch = function(data)
		data.type = SpellDamageAndHeal
		data.heal = data.damage * 0.5
	end

	--Исповедь:
	local Penance = function(data)
		if IsPlayerSpell(200347) 	--Исповедник
			and UnitExists("target") and UnitIsFriend("player", "target") then
			local thePenitentDescr = GetSpellDescription(200347)
			if thePenitentDescr then
				local match = matchDigit(thePenitentDescr, getLocaleIndex({ru=1, de=2, cn=2, kr=2}))
				if match then
					data.type = SpellTimeHeal
					data.timeHeal = match
				end
			end
		end
	end

	--Молитва восстановления:
	local PrayerOfMending = function(data)
		data.timeHeal = data.timeHeal * 5
	end

	--Молитва отчаяния:
	local DesperatePrayer = function(data)
		data.type = SpellHeal
		data.heal = UnitHealthMax("player") * 0.2
	end


	self.spells[204883]	= Heal({ru=1, en=3, de=3, pt=3, cn=3, kr=3}) 						--Круг исцеления
	self.spells[204197]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 	--Очищение зла
	self.spells[73510]	= Damage({ru=1}) 													--Пронзание разума
	self.spells[204065]	= Heal({ru=3, es=1}) 												--Темный завет
	self.spells[110744]	= DamageAndHeal({ru={2,3}}) 										--Божественная звезда
	self.spells[120517]	= DamageAndHeal({ru={2,3}}) 										--Сияние
	self.spells[205385]	= Damage({ru=1, de=2, cn=2, kr=2}) 									--Темное сокрушение
	self.spells[152118]	= Absorb({ru=1, en=2, de=2, es=2, fr=2, it=2, pt=2, cn=2, kr=2}) 	--Ясность воли
	self.spells[32546]	= Heal({ru=1, en=2, de=2, it=2, pt=2, cn=2, kr=2}) 					--Связующее исцеление
	self.spells[129250]	= Damage({ru=1}, PowerWordSolace) 									--Слово силы: Утешение
	self.spells[214121]	= TimeHeal({ru=1, de=2, cn=2, kr=3}, BodyAndMind) 					--Тело и разум
	self.spells[228260]	= Damage({ru=1}) 													--Извержение Бездны
	--self.spells[48045]	= TimeDamage({ru=1, de=3, cn=2, kr=3}) 								--Иссушение разума
	self.spells[132157]	= Damage({ru=1, de=2, cn=2, kr=2}) 									--Кольцо света
	self.spells[596]	= Heal({ru=1, en=3, de=3, fr=3, pt=3, cn=3, kr=3}) 					--Молитва исцеления
	self.spells[34914]	= Damage({ru=1, de=2, cn=2, kr=2}, VampiricTouch) 					--Прикосновение вампира
	self.spells[14914]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 	--Священный огонь
	self.spells[88625]	= Damage({ru=1}) 													--Слово Света: Наказание
	self.spells[194509]	= Heal({ru=2, fr=1, pt=1}) 											--Слово силы: Сияние
	self.spells[32379]	= Damage({ru=1}) 													--Слово Тьмы: Смерть
	self.spells[205448]	= Damage({ru=1}) 													--Стрела Бездны
	self.spells[186263]	= Heal({ru=1}) 														--Темное восстановление
	self.spells[585]	= Damage({ru=1}) 													--Кара
	self.spells[205065]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 								--Поток Бездны
	self.spells[208065]	= Heal({ru=1}) 														--Свет Т'ууре
	self.spells[207946]	= Damage({ru=2}) 													--Ярость Света
	self.spells[207948]	= self.spells[207946] 												--Ярость Света
	self.spells[47540]	= TimeDamage({ru=1, de=2, cn=2, kr=2}, Penance) 					--Исповедь
	self.spells[200829]	= Heal({ru=1}) 														--Мольба
	self.spells[17]	= Absorb({ru=1, en=2, de=2, es=2, fr=2, it=2, pt=2, cn=2, kr=2}) 		--Слово силы: Щит
	self.spells[589]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 	--Слово Тьмы: Боль
	self.spells[214621]	= Damage({ru=1}) 													--Схизма
	self.spells[64843]	= TimeHeal({ru=2, de=3, es=5, fr=5, pt=5, cn=3, kr=3}) 				--Божественный гимн
	self.spells[2061]	= Heal({ru=1}) 														--Быстрое исцеление
	self.spells[2060]	= Heal({ru=1}) 														--Исцеление
	self.spells[33076]	= TimeHeal({ru=1}, PrayerOfMending) 								--Молитва восстановления
	self.spells[139]	= HealAndTimeHeal({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 		--Обновление
	self.spells[2050]	= Heal({ru=1}) 														--Слово Света: Безмятежность
	self.spells[34861]	= Heal({ru=1, en=3, de=3, it=3, cn=3, kr=3}) 						--Слово Света: Освящение
	self.spells[19236]	= Custom(DesperatePrayer) 											--Молитва отчаяния
	self.spells[8092]	= Damage({ru=1}) 													--Взрыв разума
	self.spells[205351]	= Damage({ru=1}) 													--Слово Тьмы: Бездна
	self.spells[15407]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 								--Пытка разума
end
