local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Paladin = Class:create(ClassSpells)
Paladin.dependFromTarget = true
SD.classes["PALADIN"] = Paladin

function Paladin:init()
	--Возложение рук:
	local LayOnHands = function(data)
		data.type = SpellHeal
		data.heal = UnitHealthMax("player")

		if Glyphs:contains(54939) then 	--Символ божественности
			data.type = SpellHealAndMana
			data.mana = UnitManaMax("player") * 0.1
		end
	end

	--Шок небес:
	local HolyShock = function(data, matchs)
		data.damage = matchs[1]
		if UnitExists("target") and UnitIsFriend("player", "target") then
			data.type = SpellHeal
			data.heal = matchs[2]
		end
	end

	--Священный щит:
	local SacredShield = function(data, match)
		data.absorb = match * 5
	end

	--Божественная буря:
	local DivineStorm = function(data)
		if Glyphs:contains(63220) then		--Символ божественной бури
			data.type = SpellDamageAndHeal
			data.heal = UnitHealthMax("player") * 0.04
		end
	end

	--Торжество:
	local WordOfGlory = function(data, match, description)
		if Glyphs:contains(54938) and UnitExists("target") and UnitIsEnemy("player", "target") then		--Символ резких слов
			local damage = matchDigit(description, 3)
			if damage then
				data.type = SpellDamage
				data.damage = damage
			end
		end
	end

	--Молот Света:
	local LightsHammer = function(data, matchs)
		data.timeDamage = matchs[1] * 7
		data.timeHeal = matchs[2] * 7
	end

	--Вечное пламя:
	local EternalFlame = function(data, matchs)
		data.heal = matchs[1]
		data.timeHeal = matchs[2] * 15

		if not UnitExists("target") or UnitIsPlayer("target") then
			data.timeHeal = data.timeHeal * 1.5
		end
	end

	--Божественная призма:
	local HolyPrism = function(data, matchs)
		if UnitExists("target") and UnitIsFriend("player", "target") then
			data.heal = matchs[3]
			data.damage = matchs[4]
		else
			data.damage = matchs[1]
			data.heal = matchs[2]
		end
	end

	--Гнев карателя:
	local AvengingWrath = function(data)
		if Glyphs:contains(54927) then		--Символ гнева карателя
			data.type = SpellTimeHeal
			data.timeHeal = UnitHealthMax("player") * 0.01 * 5
		else
			data.type = SpellEmpty
		end
	end

	self.spells[633] 	= Custom(LayOnHands) 																	--Возложение рук
	self.spells[879]	= Damage({ru=1}) 																		--Экзорцизм
	self.spells[2812]	= Damage({ru=1}) 																		--Обличение
	self.spells[19750]	= Heal({ru=1}) 	 																		--Вспышка Света
	self.spells[20271]	= Damage({ru=1}) 																		--Правосудие
	self.spells[20473]	= Damage({ru={1,2}}, HolyShock)															--Шок небес
	self.spells[20925]	= Absorb({ru=2, de=3, cn=3, tw=3, kr=3}, SacredShield)									--Священный щит
	self.spells[148039]	= self.spells[20925] 																	--Священный щит
	self.spells[24275]	= Damage({ru=1}) 	 																	--Молот гнева
	self.spells[26573]	= TimeDamage({ru=1}) 																	--Освящение
	self.spells[31935]	= Damage({ru=1}) 																		--Щит мстителя
	self.spells[35395]	= Damage({ru=1}) 																		--Удар воина Света
	self.spells[53385]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}, DivineStorm) 									--Божественная буря
	self.spells[53595]	= Damage({ru=1})  																		--Молот праведника
	self.spells[53600]	= Damage({ru=1}) 																		--Щит праведника
	self.spells[82326]	= Heal({ru=1}) 																			--Свет небес
	self.spells[82327]	= Heal({ru=1}) 																			--Святое сияние
	self.spells[85222]	= Heal({ru=4, es=2, fr=2, it=2, pt=2}) 													--Свет зари
	self.spells[85256]	= Damage({ru=1}) 																		--Вердикт храмовника
	self.spells[85673]	= Heal({ru=2}, WordOfGlory) 															--Торжество
	self.spells[136494]	= self.spells[85673] 																	--Торжество
	self.spells[114157]	= TimeDamageAndTimeHeal({ru={1,3}, de={2,4}, cn={2,4}, tw={2,4}, kr={2,4}}) 			--Смертный приговор
	self.spells[114158]	= TimeDamageAndTimeHeal({ru={4,8}, fr={4,7}}, LightsHammer) 							--Молот Света
	self.spells[114163]	= HealAndTimeHeal({ru={2,3}, de={2,5}, cn={2,4}, tw={2,4}, kr={2,5}}, EternalFlame) 	--Вечное пламя
	self.spells[114165]	= DamageAndHeal({ru={1,2,5,6}, cn={1,4,5,8}, tw={1,4,5,8}, kr={1,4,5,8}}, HolyPrism) 	--Божественная призма
	self.spells[119072]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}) 												--Гнев небес
	self.spells[130552]	= self.spells[85673] 																	--Резкое слово
	self.spells[157048]	= Damage({ru=1}) 																		--Окончательный приговор
	self.spells[31884]	= Custom(AvengingWrath) 																--Гнев карателя
end
