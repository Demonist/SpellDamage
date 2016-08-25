local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Shaman = Class:create(ClassSpells)
Shaman.dependFromTarget = true
SD.classes["SHAMAN"] = Shaman

function Shaman:init()
	--Тотем жидкой магмы:
	local LiquidMagmaTotem = function(data, match)
		data.type = SpellTimeDamage
		data.timeDamage = match[1] * match[2]
	end

	--Гнев Воздуха:
	local FuryOfAir = LiquidMagmaTotem

	--Выброс лавы:
	local LavaBurst = function(data)
		if UnitExists("target") and UnitDebuff("target", L["flame_shock"]) then
			if IsSpellKnown(60188) then 	--Неистовство стихий
				data.damage = data.damage * 2.5
			else
				data.damage = data.damage * 2
			end
		end

		local currentSpecNum = GetSpecialization()
		if currentSpecNum then
			local currentSpecId = GetSpecializationInfo(currentSpecNum)
			if currentSpecId == 262 then 	--Стихии/Elemental
				data.type = SpellDamageAndMana
				data.mana = 12
			end
		end

	end

	--Тотем исцеляющего потока:
	local HealingStreamTotem = function(data, match)
		data.type = SpellTimeHeal
		data.timeHeal = match[1] * match[2]
	end

	--Земной шок:
	local EarthShock = function(data)
		local power = UnitPower("player", SPELL_POWER_DARK_FORCE)
		if power < 10 then
			data.type = SpellEmpty
		else
			data.damage = power * data.damage / 100
		end
	end

	--Ледяной шок:
	local FrostShock = function(data)
		local power = UnitPower("player", SPELL_POWER_DARK_FORCE)
		if power > 20 then power = 20; end
		data.damage = data.damage + (data.damage * power / 20)
	end

	--Молния:
	local LightningBolt = function(data)
		if UnitExists("target") and UnitDebuff("target", L["lightning_rod"]) then
			data.damage = data.damage * 1.4
		end
	end

	--Тотем целительного прилива:
	local HealingTideTotem = function(data, match)
		data.type = SpellTimeHeal
		data.timeHeal = match[1] * match[2] / 2
	end


	self.spells[188089]	= Damage({ru=1}) 																--Земляной шип
	self.spells[197995]	= Heal({ru=1}) 																	--Родник
	self.spells[192222]	= DamageAndDamage({ru={1,4}, de={1,3}, es={1,3}, fr={1,3}, it={1,3}, pt={1,3}}, LiquidMagmaTotem) 	--Тотем жидкой магмы
	self.spells[197211]	= DamageAndDamage({ru={2,5}, de={3,4}, cn={3,5}, kr={3,4}}, FuryOfAir) 			--Гнев Воздуха
	self.spells[197214]	= Damage({ru=1}) 																--Раскол
	self.spells[192246]	= TimeDamage({ru=2, en=1, es=1, fr=1, it=1, pt=1}) 								--Сокрушающая буря
	self.spells[210714]	= DamageAndMana({ru={1,4}}) 													--Ледяная ярость
	self.spells[198838]	= Absorb({ru=1, it=2, kr=2}) 													--Тотем земного щита
	self.spells[117014]	= Damage({ru=1}) 																--Удар духов стихии
	self.spells[215864]	= TimeHeal({ru=1, de=3, cn=3, kr=3}) 											--Ливень
	self.spells[196884]	= Damage({ru=1}) 																--Свирепый выпад
	self.spells[201898]	= Damage({ru=1}) 																--Песнь ветра
	self.spells[201897]	= Damage({ru=1}) 																--Тяжелый кулак
	self.spells[61295]	= HealAndTimeHeal({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 					--Быстрина
	self.spells[51505]	= Damage({ru=1}, LavaBurst) 													--Выброс лавы
	self.spells[8004]	= Heal({ru=1}) 																	--Исцеляющий всплеск
	self.spells[403]	= Damage({ru=1}) 																--Молния
	self.spells[5394]	= HealAndTimeHeal({ru={2,4}, en={1,3}, de={1,4}, es={1,3}, fr={1,3}, it={1,3}, pt={1,3}, cn={1,4}, kr={1,4}}, HealingStreamTotem) 	--Тотем исцеляющего потока
	self.spells[17364]	= Damage({ru=1}) 																--Удар бури
	self.spells[421]	= Damage({ru=1}) 																--Цепная молния
	self.spells[77472]	= Heal({ru=1}) 																	--Волна исцеления
	self.spells[60103]	= Damage({ru=1}) 																--Вскипание лавы
	self.spells[51490]	= Damage({ru=1, de=2, cn=2, kr=2}) 												--Гром и молния
	self.spells[8042]	= Damage({ru=1}, EarthShock) 													--Земной шок
	self.spells[188070]	= Heal({ru=1}) 																	--Исцеляющий всплеск
	self.spells[193786]	= DamageAndMana({ru={1,2}}) 													--Камнедробитель
	self.spells[196834]	= Damage({ru=1}) 																--Ледяное клеймо
	self.spells[196840]	= Damage({ru=1}, FrostShock) 													--Ледяной шок
	self.spells[187837]	= Damage({ru=1}) 																--Молния
	self.spells[188196]	= DamageAndMana({ru={1,2}}, LightningBolt) 										--Молния
	self.spells[188389]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Огненный шок
	self.spells[188838]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Огненный шок
	self.spells[187874]	= Damage({ru=1}) 																--Сокрушающая молния
	self.spells[61882]	= TimeDamage({ru=2, de=3, cn=3, kr=3}) 											--Тотем землетрясения
	self.spells[108280]	= HealAndTimeHeal({ru={1,4}, es={1,3}, fr={1,3}, it={1,3}}, HealingTideTotem) 	--Тотем целительного прилива
	self.spells[188443]	= DamageAndMana({ru={1,3}}, LightningBolt) 										--Цепная молния
	self.spells[1064]	= Heal({ru=1}) 																	--Цепное исцеление
	self.spells[193796]	= Damage({ru=1}) 																--Язык пламени
	self.spells[207778]	= Heal({ru=3, en=2, es=1, pt=1}) 												--Дар королевы
	
end
