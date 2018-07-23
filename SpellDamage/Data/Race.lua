local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, TimeHealAndTimeMana, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.TimeHealAndTimeMana, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs
--

local Race = Class:create(ClassSpells)
SD.classes["Race"] = Race

function Race:init()
	--Эльф крови, Волшебный поток:
	local ArcaneTorrent = function(data, match)
		local currentSpecNum = GetSpecialization()
		if currentSpecNum then
			local currentSpecId = GetSpecializationInfo(currentSpecNum)
			if currentSpecId == 269 then 	--Танцующий с ветром/Windwalker
				data.mana = match
			elseif currentSpecId == 268 then 	--Хмелевар/Brewmaster
				data.mana = match
			elseif currentSpecId == 270 then 	--Ткач Туманов/Mistweaver
				data.mana = match * UnitPowerMax("player") / 100
			elseif currentSpecId == 256 then 	--Тьма/Shadow
				data.mana = match
			elseif currentSpecId == 70 then 	--Воздаяние/Retribution
				data.mana = match
			else 
				data.mana = match * UnitPowerMax("player") / 100
			end
		else 
			data.mana = match * UnitPowerMax("player") / 100
		end
	end

	--Дреней, Дар наару:
	local GiftOfTheNaaru = function(data, match)
		data.timeHeal = match * UnitHealthMax("player") / 100
	end

	--Нежить, Каннибализм:
	local Cannibalize = function(data, matchs)
		local times = matchs[3] / matchs[2]
		data.timeHeal = math.floor(matchs[1] * times * (UnitHealthMax("player") / 100))
		data.timeMana = math.floor(matchs[1] * times * (UnitPowerMax("player") / 100))
	end

	self.spells[28730]	= Mana({ru=3}, ArcaneTorrent) 															--Эльф крови, Волшебный поток
	self.spells[50613]	= Mana({ru=3}) 																			--Эльф крови, Волшебный поток, Рыцарь Смерти
	self.spells[25046]	= Mana({ru=3})				 															--Эльф крови, Волшебный поток, Разбойник
	self.spells[129597]	= Mana({ru=3}, ArcaneTorrent)															--Эльф крови, Волшебный поток, Монах
	self.spells[80483]	= Mana({ru=3})				 															--Эльф крови, Волшебный поток, Охотник
	self.spells[69179]	= Mana({ru=3}) 																			--Эльф крови, Волшебный поток, Воин
	self.spells[232633]	= Mana({ru=3}, ArcaneTorrent)															--Эльф крови, Волшебный поток, Рыцарь Смерти
	self.spells[202719]	= Mana({ru=3})				 															--Эльф крови, Волшебный поток, Охотник на демонов
	self.spells[155145]	= Mana({ru=3}, ArcaneTorrent)				 											--Эльф крови, Волшебный поток, Паладин
	self.spells[121093] = TimeHeal({ru=1}, GiftOfTheNaaru)														--Дреней, Дар наару
	self.spells[28880]	= self.spells[121093] 																	--Дреней, Дар наару
	self.spells[59544]	= self.spells[121093] 																	--Дреней, Дар наару
	self.spells[59548]	= self.spells[121093] 																	--Дреней, Дар наару
	self.spells[59543]	= self.spells[121093] 																	--Дреней, Дар наару
	self.spells[59542]	= self.spells[121093] 																	--Дреней, Дар наару
	self.spells[59545]	= self.spells[121093] 																	--Дреней, Дар наару
	self.spells[59547]	= self.spells[121093] 																	--Дреней, Дар наару
	self.spells[20577] = TimeHealAndTimeMana({ru={1,2,3}}, Cannibalize)											--Нежить, Каннибализм
	self.spells[69041] = Damage({ru=1})																			--Гоблин, Ракетный обстрел
	self.spells[255647] = Damage({ru=1})																		--Озаренный дреней, Правосудие Света
	self.spells[260364] = Damage({ru=1})																		--Ночнорожденные, Чародейский импульс

	
end
