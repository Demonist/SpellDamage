local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Priest = Class:create(ClassSpells)
SD.classes["PRIEST"] = Priest
Priest.dependFromTarget = true

function Priest:init()
	--Слово силы: Щит:
	local PowerWordShield = function(data)
		if Glyphs:contains(55672) then		--Символ слова силы: Щит
			data.type = SpellAbsorbAndHeal
			data.heal = data.absorb * 0.2
		end
	end

	--Обновление:
	local Renew = function(data, description)
		if UnitLevel("player") >= 64 then
			local matchs = matchDigits(description, getLocaleIndex({ru={1,2}, de={1,3}, tw={1,3}, kr={1,3}}))
			if matchs then
				data.type = SpellHealAndTimeHeal
				data.heal = matchs[1]
				data.timeHeal = matchs[2]
			else
				data.type = SpellEmpty
			end
		else
			local match = matchDigit(description, getLocaleIndex({ru=1, de=2, tw=2, kr=2}))
			if match then
				data.type = SpellTimeHeal
				data.timeHeal = match
			end
		end
	end

	--Кара:
	local Smite = function(data)
		if UnitExists("target")
			and UnitIsEnemy("player", "target")
			and Glyphs:contains(55692) 	--Символ кары
			and (UnitDebuff("target", L["holy_fire"]) or UnitDebuff("target", L["power_word_solace"])) then 	--'Священный огонь' или 'Слово силы: Утешение'
				data.damage = data.damage * 1.2
		end
	end

	--Всепожирающая чума:
	local DevouringPlague = function(data)
		data.heal = data.heal * 2
	end

	--Исповедь:
	local Penance = function(data, description)
		if UnitExists("target") and UnitIsFriend("player", "target") then
			local match = matchDigit(description, getLocaleIndex({ru=2, de=3, cn=3, tw=3, kr=3}))
			if match then
				data.type = SpellTimeHeal
				data.timeHeal = match
			end
		else
			local match = matchDigit(description, getLocaleIndex({ru=1, tw=2, kr=2}))
			if match then
				data.type = SpellDamage
				data.damage = match
			end
		end
	end

	--Божественный оплот:
	local AngelicBulwark = function(data)
		data.type = SpellAbsorb
		data.absorb = UnitHealthMax("player") * 0.15
	end

	--Слово Света: Святилище:
	local HolyWordSanctuary = function(data, match)
		data.timeHeal = match * 15
	end

	self.spells[17]		= Absorb({ru=1}, PowerWordShield) 														--Слово силы: Щит
	self.spells[139]	= Custom(Renew) 																		--Обновление
	self.spells[585]	= Damage({ru=1}, Smite) 																--Кара
	self.spells[589]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}) 				--Слово Тьмы: Боль
	self.spells[596]	= Heal({ru=2, es=1, fr=1, pt=1}) 														--Молитва исцеления
	self.spells[2060]	= Heal({ru=1}) 																			--Исцеление
	self.spells[2061]	= Heal({ru=1}) 																			--Быстрое исцеление
	self.spells[2944]	= DamageAndHeal({ru={2,2}}, DevouringPlague) 											--Всепожирающая чума
	self.spells[8092]	= Damage({ru=1}) 																		--Взрыв разума
	self.spells[14914]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}) 				--Священный огонь
	self.spells[15407]	= TimeDamage({ru=1, de=2, cn=2, tw=2, kr=2}) 											--Пытка разума
	self.spells[19236]	= Heal({ru=1}) 																			--Молитва отчаяния
	self.spells[32379]	= Damage({ru=1}) 																		--Слово Тьмы: Смерть
	self.spells[32546]	= Heal({ru=1}) 																			--Связующее исцеление
	self.spells[33076]	= TimeHeal({ru=1}) 																		--Молитва восстановления
	self.spells[34861]	= Heal({ru=3, es=1, fr=1, it=1}) 														--Круг исцеления
	self.spells[34914]	= TimeDamage({ru=1}) 																	--Прикосновение вампира
	self.spells[47540]	= Custom(Penance) 																		--Исповедь
	self.spells[48045]	= TimeDamage({ru=1, de=2, cn=2, kr=2})  							 					--Иссушение разума
	self.spells[64843]	= TimeHeal({ru=2, de=3, es=1, fr=1, pt=1, tw=3, kr=3}) 				 					--Божественный гимн
	self.spells[73510]	= Damage({ru=1}) 																		--Пронзание разума
	self.spells[88625]	= Damage({ru=1}) 																		--Слово Света: Воздаяние
	self.spells[88684]	= Heal({ru=1}) 																			--Слово Света: Безмятежность
	self.spells[110744]	= Heal({ru=2}) 																			--Божественная звезда
	self.spells[122121]	= Damage({ru=2}) 																		--Божественная звезда
	self.spells[120517]	= Heal({ru=2}) 																			--Сияние
	self.spells[120644]	= Damage({ru=2}) 																		--Сияние
	self.spells[121135]	= Heal({ru=1}) 																			--Каскад
	self.spells[127632]	= Damage({ru=1}) 																		--Каскад
	self.spells[126135]	= TimeHeal({ru=3, de=4, es=2, fr=2, it=2, pt=2, cn=4, tw=4, kr=4})						--Колодец Света
	self.spells[129250]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}) 				--Слово силы: Утешение
	self.spells[132157]	= DamageAndHeal({ru={1,3}, en={1,5}, de={2,5}, it={1,5}, cn={2,5}, tw={2,5}, kr={2,5}}) --Кольцо света
	self.spells[152116]	= Heal({ru=1}) 																			--Спасительная сила
	self.spells[152118]	= Absorb({ru=1, de=2, cn=2, tw=2, kr=2}) 												--Ясность воли
	self.spells[155245]	= Heal({ru=1}) 																			--Ясная цель
	self.spells[155361]	= TimeDamage({ru=1}) 					 												--Энтропия Бездны
	self.spells[129197]	= TimeDamage({ru=1, de=2, cn=2, tw=2, kr=2}) 											--Безумие
	self.spells[179338]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 													--Полное безумие
	self.spells[108945]	= Custom(AngelicBulwark) 																--Божественный оплот
	self.spells[88685]	= TimeHeal({ru=2, de=4, es=1, cn=3, pt=1, tw=3, kr=3}, HolyWordSanctuary) 				--Слово Света: Святилище
end

-- Подчиняющий разум ?
