local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex, ManaAndTimeMana, TimeDamageAndTimeDamage = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex, SD.ManaAndTimeMana, SD.TimeDamageAndTimeDamage
local Glyphs = SD.Glyphs

--

--Взрывная волна:
local BlastWave = Supernova

--Кольцо обледенения:
local IceNova = Supernova

local Mage = Class:create(ClassSpells)
Mage.dependFromTarget = true
SD.classes["MAGE"] = Mage

function Mage:init()
	--Чародейские стрелы:
	local ArcaneMissiles = function(data, match)
		data.timeDamage = match * 5
	end

	--Прилив сил:
	local Evocation = function(data, matchs)
		local maxMana = UnitManaMax("player")
		data.mana = matchs[1] * maxMana / 100
		data.timeMana = matchs[2] * maxMana / 100
	end

	--Ледяное копье:
	local IceLance = function(data, match)
		data.damage = match

		if UnitExists("target") and UnitBuff("target", L["frost_bomb"]) then
			local description = GetSpellDescription(112948)	--Ледяная бомба
			if description then
				local match = matchDigit(description, getLocaleIndex({ru=3, cn=2, kr=2}))
				if match then
					data.damage = data.damage + match
				end
			end
		end
	end

	--Ледяная глыба:
	local IceBlock = function(data, description)
		if Glyphs:contains(159486) then		--Символ возрождающего льда
			local match = matchDigit(description, getLocaleIndex({ru=1}))
			if match then
				data.type = SpellTimeHeal
				data.timeHeal = UnitHealthMax("player") * 0.04 * match
			end
		else
			data.type = SpellEmpty
		end
	end

	--Метеор:
	local Meteor = function(data, description)
		local matchs = matchDigits(description, getLocaleIndex({ru={2,4}}))
		if matchs then
			data.type = SpellTimeDamage
			data.timeDamage = matchs[1] + matchs[2] * 8
		end
	end

	--Буря комет:
	local CometStorm = function(data, match)
		data.damage = match * 7
	end

	--Сверхновая:
	local Supernova = function(data)
		if UnitExists("target") and UnitIsEnemy("player", "target") then
			data.damage = data.damage * 2
		end
	end

	self.spells[10]		= TimeDamage({ru=1}) 																--Снежная буря
	self.spells[116]	= TimeDamage({ru=1}) 																--Ледяная стрела
	self.spells[120]	= Damage({ru=1})																	--Конус холода
	self.spells[122]	= Damage({ru=2})																	--Кольцо льда
	self.spells[133]	= Damage({ru=1})																	--Огненный шар
	self.spells[1449]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}) 											--Чародейский взрыв
	self.spells[2120]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}})			--Огненный столб
	self.spells[2136]	= Damage({ru=1})																	--Огненный взрыв
	self.spells[2948]	= Damage({ru=1}) 																	--Ожог
	self.spells[5143]	= Damage({ru=3, en=2, de=2, es=2, fr=2, it=2, pt=2, cn=2, tw=2}, ArcaneMissiles) 	--Чародейские стрелы
	self.spells[11366]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}})			--Огненная глыба
	self.spells[11426]	= Absorb({ru=1, en=2, de=2, es=2, fr=2, it=2, cn=2, tw=2, kr=2}) 					--Ледяная преграда
	self.spells[12051]	= ManaAndTimeMana({ru={1,2}, de={1,3}, cn={1,3}, tw={1,3}, kr={1,3}}, Evocation) 	--Прилив сил
	self.spells[30451]	= Damage({ru=1})																	--Чародейская вспышка
	self.spells[30455]	= Damage({ru=1}, IceLance) 															--Ледяное копье
	self.spells[31661]	= Damage({ru=1}) 																	--Дыхание дракона
	self.spells[44425]	= Damage({ru=1})																	--Чародейский обстрел
	self.spells[44457]	= TimeDamageAndTimeDamage({ru={1,4}, en={1,3}, de={2,4}, es={1,3}, fr={1,3}, it={1,3}, pt={1,3}, cn={2,4}, tw={2,4}, kr={2,4}}) 	--Живая бомба
	self.spells[44614]	= Damage({ru=1})																	--Стрела ледяного огня
	self.spells[45438]	= Custom(IceBlock) 																	--Ледяная глыба
	self.spells[84714]	= TimeDamage({ru=1, de=2, kr=2}) 													--Ледяной шар
	self.spells[108853]	= CriticalDamage({ru=1}) 															--Пламенный взрыв
	self.spells[114923]	= TimeDamage({ru=1, de=2, cn=2, tw=2}) 												--Буря Пустоты
	self.spells[153561]	= Custom(Meteor)																	--Метеор
	self.spells[153595]	= Damage({ru=2, kr=3}, CometStorm)													--Буря комет
	self.spells[153626]	= TimeDamage({ru=2})																--Чародейский шар
	self.spells[157980]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}, Supernova) 								--Сверхновая
	self.spells[157981]	= self.spells[157980] 																--Взрывная волна
	self.spells[157997]	= self.spells[157980] 																--Кольцо обледенения
end

-------------------------------------------------------------------------------

--Возгорание:
local Combustion = function(data, description)
	data.type = SpellEmpty

	if StatusTextFrameLabel then
		local text = StatusTextFrameLabel:GetText()
		if text then
			local match = text:match("Tick : %d+")
			if match then
				data.type = SpellTimeDamage
				data.timeDamage = tonumber(string.sub(match, string.len("Tick : ")))
			end
		end
	end
end

function Mage:onLoad()
	if IsAddOnLoaded("CombustionHelper") then
		self.onUpdateSpells[11129] = Custom(Combustion) 	--Возгорание
	end
end
