local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Combo, ComboDamage, ComboTimeDamage, getComboPoints = SD.Combo, SD.ComboDamage, SD.ComboTimeDamage, SD.Combo.getComboPoints
local Glyphs = SD.Glyphs

--

local Druid = Class:create(ClassSpells)
Druid.dependFromPower = true
Druid.dependPowerTypes["COMBO_POINTS"] = true
SD.classes["DRUID"] = Druid

function Druid:init()
	--Спокойствие:
	local Tranquility = function(data)
		data.timeHeal = data.timeHeal * 4
	end

	--Восстановление:
	local Regrowth = function(data, description)
		if Glyphs:contains(116218) then	--Символ восстановления
			local match = matchDigit(description, 1)
			if match then
				data.type = SpellHeal
				data.heal = match * 2
			end
		else
			local matchs = matchDigits(description, getLocaleIndex({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}))
			if matchs then
				data.type = SpellHealAndTimeHeal
				data.heal = matchs[1]
				data.timeHeal = matchs[2]
			end
		end
	end

	--Свирепый укус:
	local FerociousBite = function(data, description)
		local list = {4, 6, 8, 10, 12}
		if Glyphs:contains(67598) then	--Символ свирепого укуса
			list = {6, 8, 10, 12, 14}
		end
		
		local match = matchDigit(description, list[getComboPoints()])
		if match then
			data.type = SpellDamage
			data.damage = match
		end
	end

	--Жизнецвет:
	local Lifebloom = function(data, matchs)
		data.type = SpellTimeHeal
		data.timeHeal = matchs[1] + matchs[2]
	end

	--Сила Природы:
	local ForceOfNature1 = function(data, match)
		data.timeDamage = match * 7
	end

	--Сила Природы:
	local ForceOfNature2 = function(data, match)
		data.timeHeal = match * 3
		local heal = matchDigit(GetSpellDescription(18562), 1)	--Быстрое восстановление
		if heal then
			data.type = SpellHealAndTimeHeal
			data.heal = heal
		end
	end

	--Увечье:
	local Mangle = function(data)
		data.type = SpellDamageAndMana
		data.mana = 10
	end

	--Обновление
	local Renewal = function(data, match)
		data.heal = match * UnitHealthMax("player") / 100
	end

	--Дикий гриб:
	local WildMushroom = function(data, match)
		data.timeHeal = match * 15
	end

	--Звездопад:
	local Starfall = function(data)
		data.timeDamage = data.timeDamage * 10
	end

	self.spells[740]	= TimeHeal({ru=1, en=2, de=4, cn=3, tw=3, kr=4}, Tranquility) 				--Спокойствие
	self.spells[770]	= Damage({ru=1}) 															--Волшебный огонь
	self.spells[774]	= TimeHeal({ru=1, de=2, cn=2, tw=2, kr=2}) 									--Омоложение
	self.spells[1079]	= ComboTimeDamage({ru={3,2}})												--Разорвать
	self.spells[1822]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}) 	--Глубокая рана
	self.spells[2912]	= Damage({ru=1}) 															--Звездный огонь
	self.spells[5176]	= Damage({ru=1}) 															--Гнев
	self.spells[5185]	= Heal({ru=1}) 	 															--Целительное прикосновение
	self.spells[5217]	= Mana({ru=3}) 																--Тигриное неистовство
	self.spells[5221]	= Damage({ru=1}) 															--Полоснуть
	self.spells[6807]	= Damage({ru=1}) 															--Трепка
	self.spells[8921]	= DamageAndTimeDamage({ru={1,2}, cn={1,3}, tw={1,3}, kr={1,3}}) 			--Лунный огонь
	self.spells[164812]	= self.spells[8921] 														--Лунный огонь
	self.spells[8936]	= Custom(Regrowth)  														--Восстановление
	self.spells[18562]	= Heal({ru=1}) 																--Быстрое восстановление
	self.spells[22568]	= Custom(FerociousBite) 													--Свирепый укус
	self.spells[22570]	= ComboTimeDamage({ru={2, 5, 8, 11, 14}})									--Калечение
	self.spells[22842]	= Heal({ru=2}) 																--Неистовое восстановление
	self.spells[33745]	= DamageAndTimeDamage({ru={1,2}, tw={1,3}, kr={1,3}}) 						--Растерзать
	self.spells[33763]	= HealAndTimeHeal({ru={1,3}, de={2,3}, cn={2,3}, tw={2,3}, kr={2,3}}, Lifebloom) 	--Жизнецвет
	self.spells[33831]	= TimeDamage({ru=3, en=2, es=2, fr=2, it=2, pt=2, cn=4}, ForceOfNature1) 	--Сила Природы
	self.spells[102693]	= TimeHeal({ru=1, cn=2}, ForceOfNature2) 									--Сила Природы
	self.spells[102703]	= TimeDamage({ru=2, de=3, cn=4, tw=3, kr=3}, ForceOfNature1)				--Сила Природы
	self.spells[102706]	= TimeDamage({ru=1, de=2, cn=3, tw=2, kr=2}, ForceOfNature1) 				--Сила Природы
	self.spells[33917]	= Damage({ru=1}, Mangle) 													--Увечье
	self.spells[48438]	= TimeHeal({ru=3, de=4, es=1, pt=1, cn=4, tw=4, kr=4}) 						--Буйный рост
	self.spells[77758]	= DamageAndTimeDamage({ru={2,3}, de={2,4}, tw={2,4}, kr={2,4}}) 			--Взбучка
	self.spells[106830]	= self.spells[77758] 														--Взбучка
	self.spells[78674]	= Damage({ru=1}) 															--Звездный поток
	self.spells[80313]	= Damage({ru=2}) 															--Раздавить
	self.spells[102351]	= TimeHeal({ru=2, de=3, cn=3, tw=3, kr=3})									--Щит Кенария
	self.spells[106785]	= Damage({ru=1}) 															--Размах
	self.spells[108238]	= Heal({ru=1}, Renewal) 													--Обновление
	self.spells[145205]	= TimeHeal({ru=4, en=2, de=5, es=2, fr=2, it=2, pt=2, cn=5, kr=6}, WildMushroom) 	--Дикий гриб
	self.spells[152221]	= DamageAndTimeDamage({ru={1,2}, cn={1,3}, tw={1,3}, kr={1,3}}) 			--Звездная вспышка
	self.spells[164815]	= DamageAndTimeDamage({ru={1,2}, cn={1,3}, tw={1,3}, kr={1,3}}) 			--Солнечный огонь
	self.spells[48505]	= DamageAndTimeDamage({ru={1,2}, de={3,4}, cn={3,4}, kr={3,4}}, Starfall) 	--Звездопад
end

-- Полоснуть, Трепка, Размах ? незаметность и кровотечение
