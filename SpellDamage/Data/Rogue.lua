local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Combo, ComboDamage, ComboTimeDamage, getComboPoints = SD.Combo, SD.ComboDamage, SD.ComboTimeDamage, SD.Combo.getComboPoints
local Glyphs = SD.Glyphs

--

local Rogue = Class:create(ClassSpells)
Rogue.dependFromPower = true
Rogue.dependPowerTypes["COMBO_POINTS"] = true
SD.classes["ROGUE"] = Rogue

function Rogue:init()
	function IsUseDaggers()
		local slotId = GetInventorySlotInfo("MainHandSlot")
		if slotId then
			local mainHandLink = GetInventoryItemLink("player", slotId)
			if mainHandLink then
				local _, _, _, _, _, _, itemType = GetItemInfo(mainHandLink)
				if itemType == L["daggers"] then return true;  end
			end
		end
		return false
	end

	--Внезапный удар:
	local Ambush = function(data)
		if IsUseDaggers() then data.damage = data.damage * 1.4; end
	end

	--Кровоизлияние:
	local Hemorrhage = function(data)
		if IsUseDaggers() then data.damage = data.damage * 1.4; end
	end

	--Череда убийств:
	local KillingSpree = function(data)
		data.damage = data.damage * 7
	end

	--Заживление ран:
	local Recuperate = function(data, match)
		local heal = match * UnitHealthMax("player") / 100
		data.timeHeal = getComboPoints() * 2 * heal
	end

	--Кровавый вихрь:
	local CrimsonTempest = function(data)
		data.type = SpellDamageAndTimeDamage
		data.timeDamage = data.damage * 2.4
	end

	--Смерть с небес:
	local DeathFromAbove = function(data)
		if IsPlayerSpell(32645) then 	--Отравление
			local localData = Rogue.spells[32645]:getData(GetSpellDescription(32645))
			if localData then
				data.type = SpellDamageAndTimeDamage
				data.timeDamage = localData.timeDamage * 1.5
			end
		else
			local descr = GetSpellDescription(2098)
			local localData = Rogue.spells[2098]:getData(descr)	--Потрошение
			if localData then
				data.damage = data.damage + localData.timeDamage * 1.5
			end
		end
	end

	self.spells[53]		= Damage({ru=1}) 																		--Удар в спину
	self.spells[703]	= Damage({ru=1, en=2, de=3, es=2, fr=2, it=2, pt=2, cn=3, tw=3, kr=3}) 					--Гаррота
	self.spells[1329]	= DamageAndDamage({ru={1,2}}) 															--Расправа
	self.spells[1752]	= Damage({ru=1}) 																		--Коварный удар
	self.spells[1943]	= ComboTimeDamage({ru={2,3}, cn={3,3}, tw={3,3}, kr={3,3}}) 							--Рваная рана
	self.spells[2098]	= ComboDamage({ru={2,2}}) 																--Потрошение
	self.spells[5938]	= Damage({ru=1})																		--Отравляющий укол
	self.spells[8676]	= Damage({ru=1}, Ambush) 																--Внезапный удар
	self.spells[16511]	= DamageAndTimeDamage({ru={1,3}, de={1,4}, cn={1,4}, tw={1,4}, kr={1,4}}, Hemorrhage) 	--Кровоизлияние
	self.spells[26679]	= ComboDamage({ru={4,2}})																--Смертельный бросок
	self.spells[32645]	= ComboTimeDamage({ru={3,3}}) 															--Отравление
	self.spells[51690]	= DamageAndDamage({ru={3,4}, en={4,5}, de={4,5}, es={4,5}, fr={4,5}, it={4,5}, pt={4,5}, cn={4,5}, tw={4,5}, kr={4,5}}, KillingSpree) 	--Череда убийств
	self.spells[51723]	= Damage({ru=2}) 																		--Веер клинков
	self.spells[73651]	= TimeHeal({ru=1, de=2, cn=2, tw=2, kr=2}, Recuperate) 									--Заживление ран
	self.spells[84617]	= Damage({ru=1}) 																		--Пробивающий удар
	self.spells[111240]	= Damage({ru=2}) 																		--Устранение
	self.spells[114014]	= Damage({ru=1}) 																		--Бросок сюрикена
	self.spells[121411]	= ComboDamage({ru={5,2}}, CrimsonTempest)												--Кровавый вихрь
	self.spells[152150]	= Damage({ru=1, de=2, cn=2, tw=2, kr=3}, DeathFromAbove) 								--Смерть с небес
end
