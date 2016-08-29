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
	--Смерть с небес:
	local DeathFromAbove = function(data)
		if IsPlayerSpell(32645) then 	--Отравление
			local localData = Rogue.spells[32645]:getData(GetSpellDescription(32645))
			if localData then
				data.type = SpellDamageAndTimeDamage
				data.timeDamage = localData.timeDamage * 1.5
			end
		elseif IsPlayerSpell(2098) then 	--Круговая атака
			local localData = Rogue.spells[2098]:getData(GetSpellDescription(2098))
			if localData then
				data.damage = data.damage + localData.damage * 1.5
			end
		else
			local localData = Rogue.spells[196819]:getData(GetSpellDescription(196819))	--Потрошение
			if localData then
				data.damage = data.damage + localData.damage * 1.5
			end
		end
	end

	--Череда убийств:
	local KillingSpree = function(data)
		data.damage = data.damage * 7
	end

	--Вендетта:
	local Vendetta = function(data)
		if IsPlayerSpell(192428) then 	--Из тени
			local fromTheShadowsDescr = GetSpellDescription(192428)
			if fromTheShadowsDescr then
				local match = matchDigit(fromTheShadowsDescr, getLocaleIndex({ru=1, de=2, cn=2, kr=2}))
				if match then
					data.type = SpellTimeDamage
					data.timeDamage = match
				end
			end
		else
			data.type = SpellEmpty
		end
	end

	--Удар по почкам:
	local KidneyShot = function(data)
		if IsPlayerSpell(154904) then 	--Внутреннее кровотечение
			local internalBleedingDescr = GetSpellDescription(154904)
			if internalBleedingDescr then
				local match = matchDigit(internalBleedingDescr, getLocaleIndex({ru=1, de=2, cn=2, kr=2}))
				local combo = UnitPower("player", SD.SPELL_COMBO_POINTS)
				if match then
					if combo == 0 then combo = 1; end
					if combo > 5 then combo = 5; end
					data.type = SpellDamage
					data.damage = match * combo
				end
			end
		else
			data.type = SpellEmpty
		end
	end


	self.spells[152150]	= Damage({ru=1, de=2, fr=2, cn=2, kr=3}, DeathFromAbove) 		--Смерть с небес
	self.spells[185767]	= Damage({ru=1, cn=2, kr=2}) 									--Обстрел ядрами
	self.spells[51690]	= DamageAndDamage({ru={3,4}, en={4,5}, de={4,5}, es={4,5}, fr={4,5}, it={4,5}, pt={4,5}, cn={4,5}, kr={4,5}}, KillingSpree) 	--Череда убийств
	self.spells[200758]	= Damage({ru=1}) 												--Клинок мрака
	self.spells[16511]	= Damage({ru=1}) 												--Кровоизлияние
	self.spells[196937]	= Damage({ru=1}) 												--Призрачный удар
	self.spells[703]	= Damage({ru=1, de=2, cn=2, kr=2}) 								--Гаррота
	self.spells[32645]	= ComboTimeDamage({ru={3,3}}) 									--Отравление
	self.spells[1943]	= ComboTimeDamage({ru={2,3}, cn={3,3}, tw={3,3}, kr={3,3}}) 	--Рваная рана
	self.spells[114014]	= Damage({ru=1}) 												--Бросок сюрикэна
	self.spells[51723]	= Damage({ru=2}) 												--Веер клинков
	self.spells[8676]	= Damage({ru=1}) 												--Внезапный удар
	self.spells[185763]	= Damage({ru=1}) 												--Выстрел из пистоли
	self.spells[2098]	= ComboDamage({ru={2,2}}) 										--Круговая атака
	self.spells[195452]	= ComboTimeDamage({ru={4,3}, cn={5,3}, kr={5,3}}) 				--Ночной клинок
	self.spells[185565]	= Damage({ru=1}) 												--Отравленный нож
	self.spells[196819]	= ComboDamage({ru={2,2}}) 										--Потрошение
	self.spells[199804]	= ComboDamage({ru={2,3}}) 										--Промеж глаз
	self.spells[1329]	= Damage({ru=1}) 												--Расправа
	self.spells[53]		= Damage({ru=1}) 												--Удар в спину
	self.spells[193315]	= Damage({ru=1}) 												--Удар саблей
	self.spells[185438]	= Damage({ru=1}) 												--Удар Тьмы
	self.spells[197835]	= Damage({ru=2}) 												--Шквал сюрикэнов
	self.spells[192759]	= DamageAndTimeDamage({ru={1,2}, cn={1,3}, kr={1,3}}) 			--Погибель королей
	self.spells[209782]	= Damage({ru=1}) 												--Укус Кровавой Пасти
	self.spells[79140]	= Custom(Vendetta) 												--Вендетта
	self.spells[408]	= Custom(KidneyShot) 											--Удар по почкам
end
