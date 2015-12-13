local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Shaman = Class:create(ClassSpells)
SD.classes["SHAMAN"] = Shaman

function Shaman:init()
	--Тотем исцеляющего потока:
	local HealingStreamTotem = function(data, match)
		data.timeHeal = match * 7
	end

	--Земной шок:
	local EarthShock = function(data, match)
		local name, _, _, count = UnitBuff("player", L["lightning_shield"])
		if IsSpellKnown(88766) == true and name and count > 1 then	--Сверкание
			local damage = matchDigit(GetSpellDescription(324), 1)	--Щит молний
			if damage then
				data.damage = data.damage + (damage * (count - 1))
			end
		end
	end

	--Тотем магмы:
	local MagmaTotem = function(data, match)
		data.timeDamage = match * 30
	end

	--Водный щит:
	local WaterShield = function(data, match)
		data.timeMana = match * 720
	end

	--Тотем каменной преграды:
	local StoneBulwarkTotem = function(data, description)
		local matchs = matchDigits(description, getLocaleIndex({ru={3,5}, de={4,6}}))
		if matchs then
			data.type = SpellAbsorb
			data.absorb = matchs[1] + matchs[2] * 6
		end
	end

	--Тотем целительного прилива:
	local HealingTideTotem = function(data, match)
		data.timeHeal = match * 5
	end

	self.spells[324]	= TimeDamage({ru=1}) 																--Щит молний
	self.spells[403]	= Damage({ru=1}) 																	--Молния
	self.spells[421]	= Damage({ru=1}) 																	--Цепная молния
	self.spells[974]	= TimeHeal({ru=2}) 																	--Щит земли
	self.spells[1064]	= Heal({ru=1})  																	--Цепное исцеление
	self.spells[1535]	= Damage({ru=2, de=3, cn=2, tw=2, kr=2}) 											--Кольцо огня
	self.spells[3599]	= TimeDamage({ru=4, tw=3}) 															--Опаляющий тотем
	self.spells[5394]	= TimeHeal({ru=3, de=4, es=2, it=4, pt=2, cn=6, tw=4, kr=4}, HealingStreamTotem) 	--Тотем исцеляющего потока
	self.spells[8004]	= Heal({ru=1}) 																		--Исцеляющий всплеск
	self.spells[8042]	= Damage({ru=1}, EarthShock) 														--Земной шок
	self.spells[8050]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}) 			--Огненный шок
	self.spells[8056]	= Damage({ru=1}) 																	--Ледяной шок
	self.spells[8190]	= TimeDamage({ru=4, en=3, de=5, es=3, fr=3, it=3, pt=2, cn=5}, MagmaTotem) 			--Тотем магмы
	self.spells[17364]	= DamageAndDamage({ru={1,2}}) 														--Удар бури
	self.spells[51490]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}) 											--Гром и молния
	self.spells[51505]	= CriticalDamage({ru=1}) 															--Выброс лавы
	self.spells[52127]	= TimeMana({ru=1, de=2, cn=2, tw=2, kr=2}, WaterShield) 							--Водный щит
	self.spells[60103]	= Damage({ru=1}) 																	--Вскипание лавы
	self.spells[61295]	= HealAndTimeHeal({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}) 				--Быстрина
	self.spells[61882]	= TimeDamage({ru=2, en=1, de=3, es=1, fr=1, it=1, pt=1, cn=3, tw=3, kr=3}) 			--Землетрясение
	self.spells[73899]	= Damage({ru=1}) 																	--Стихийный удар
	self.spells[73920]	= TimeHeal({ru=1, de=3, cn=2, tw=3, kr=3}) 											--Целительный ливень
	self.spells[77472]	= Heal({ru=1}) 																		--Волна исцеления
	self.spells[108270]	= Custom(StoneBulwarkTotem) 														--Тотем каменной преграды
	self.spells[108280]	= TimeHeal({ru=5, es=4, fr=4, it=4}, HealingTideTotem) 								--Тотем целительного прилива
	self.spells[117014]	= Damage({ru=1}) 	 																--Удар духов стихии
	self.spells[73685]	= Heal({ru=1}) 																		--Высвободить чары жизни
end
