local L, shortNumber, matchDigit, matchDigits, printTable, strstarts, Buff, Debuff = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts, SD.Buff, SD.Debuff
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
	--Гнев небес:
	local HolyWrath = function(data)
		data.type = SpellDamage
		data.damage = (UnitHealthMax("player") - UnitHealth("player")) * 2
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

	--Длань защитника:
	local HandOfTheProtector = function(data, match)
		data.heal = math.floor(((UnitHealthMax("player") - UnitHealth("player")) / (UnitHealthMax("player") / 100)) * 0.02 * match + match)
	end

	--Отмщение вершителя правосудия:
	local JusticarsVengeance = function(data)
		data.type = SpellDamageAndHeal
		data.heal = data.damage
	end

	--Божественный молот:
	local DivineHammer = function(data)
		data.type = SpellDamageAndTimeDamage
		data.timeDamage = data.damage * 6
	end

	--Молот Света:
	local LightsHammer = function(data)
		data.timeDamage = data.timeDamage * 7
		data.timeHeal = data.timeHeal * 7
	end

	--Освящение:
	local Consecration = function(data)
		if IsPlayerSpell(204054) then 	--Освященная земля
			local consecratedGroundDescr = GetSpellDescription(204054)
			if consecratedGroundDescr then
				local match = matchDigit(consecratedGroundDescr, getLocaleIndex({ru=2, de=3, fr=1, cn=3, kr=3}))
				if match then
					data.type = SpellTimeDamageAndTimeHeal
					data.timeHeal = match * 12
				end
			end
		end
	end

	--Божественная буря:
	local DivineStorm = function(data)
		if IsPlayerSpell(193058) then 	--Исцеляющая буря
			local consecratedGroundDescr = GetSpellDescription(193058)
			if consecratedGroundDescr then
				local match = matchDigit(consecratedGroundDescr, getLocaleIndex({ru=1, en=2, de=2, fr=2, it=2, pt=2, cn=2, kr=2}))
				if match then
					data.type = SpellDamageAndHeal
					data.heal = match
				end
			end
		end
	end

	--Свет защитника:
	local LightOfTheProtector = HandOfTheProtector

	--Шок небес:
	local HolyShock = function(data)
		if UnitExists("target") and UnitIsFriend("player", "target") then
			data.type = SpellHeal
		else
			data.type = SpellDamage
		end
	end

	--Избавление Тира:
	local TyrDeliverance = function(data)
		data.timeHeal = data.timeHeal * 10
	end

	--Правосудие:
	local Judgment = function(data, description)
		local d1 = matchDigit(description, 1) or 0
		local d2 = matchDigit(description, 2) or 0
		data.type = SpellDamage
		data.damage = math.max(d1,d2)
	end

	--Возложение рук:
	local LayOnHands = function(data)
		data.type = SpellHeal
		data.heal = UnitHealthMax("player")
	end

	--Покаяние:
	local Repentance = function(data)
		if UnitExists("target") and not UnitIsFriend("player", "target") then
			data.type = SpellTimeDamage
			data.timeDamage = UnitHealthMax("target") * 0.25
		else
			data.type = SpellEmpty
		end
	end


	self.spells[210220]	= Custom(HolyWrath) 																--Гнев небес
	self.spells[114165]	= DamageAndHeal({ru={1,2,5,6}, cn={1,4,5,8}, kr={1,4,5,8}}, HolyPrism) 				--Божественная призма
	self.spells[213652]	= Heal({ru=1}, HandOfTheProtector) 													--Длань защитника
	self.spells[215661]	= Damage({ru=1}, JusticarsVengeance) 												--Отмщение вершителя правосудия
	self.spells[210191]	= Heal({ru=1, en=3, de=3, it=3, cn=3, kr=3}) 										--Торжество
	self.spells[198034]	= Damage({ru=2, de=4, pt=1}, DivineHammer) 											--Божественный молот
	self.spells[204019]	= Damage({ru=1}) 																	--Благословенный молот
	self.spells[217020]	= Damage({ru=1}) 																	--Фанатизм
	self.spells[223306]	= TimeHeal({ru=1}) 																	--Дарование веры
	self.spells[114158]	= TimeDamageAndTimeHeal({ru={1,3}, es={4,5}, fr={4,5}, pt={4,5}}, LightsHammer) 	--Молот Света
	self.spells[205228]	= TimeDamage({ru=1, de=2, cn=2, kr=2}, Consecration) 								--Освящение
	self.spells[267798]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 												--Смертный приговор
	self.spells[85222]	= Heal({ru=1, en=3, de=3, fr=3, pt=3, cn=3, kr=3}) 									--Свет зари
	self.spells[53385]	= Damage({ru=1}) 																	--Божественная буря
	self.spells[203538]	= Absorb({ru=1, en=3, de=3, es=2, it=2, pt=2, cn=2, kr=3}) 							--Великое благословение королей
	self.spells[85256]	= Damage({ru=1}) 																	--Вердикт храмовника
	self.spells[19750]	= Heal({ru=1}) 																		--Вспышка Света
	self.spells[184575]	= Damage({ru=1}) 																	--Клинок Справедливости
	self.spells[53595]	= Damage({ru=1}) 																	--Молот праведника
	self.spells[26573]	= TimeDamage({ru=1})			 													--Освящение
	self.spells[184092]	= Heal({ru=1}, LightOfTheProtector) 												--Свет защитника
	self.spells[183998]	= Heal({ru=1}) 																		--Свет мученика
	self.spells[82326]	= Heal({ru=1}) 																		--Свет небес
	self.spells[20473]	= DamageAndHeal({ru={1,2}}, HolyShock) 												--Шок небес
	self.spells[31935]	= Damage({ru=1}) 																	--Щит мстителя
	self.spells[184662]	= Absorb({ru=1, de=2, kr=2}) 														--Щит мстителя
	self.spells[53600]	= Damage({ru=1}) 																	--Щит праведника
	self.spells[200652]	= TimeHeal({ru=3, en=4, de=5, fr=5, it=4, pt=4, cn=4, kr=5}, TyrDeliverance) 		--Избавление Тира
	self.spells[200654]	= self.spells[200652] 																--Избавление Тира
	self.spells[205273]	= Damage({ru=2, de=3, cn=3, kr=3}) 													--Испепеляющий след
	self.spells[218001]	= self.spells[205273] 																--Испепеляющий след
	self.spells[209122]	= self.spells[205273]																--Испепеляющий след
	self.spells[255937]	= Damage({ru=1})																	--Испепеляющий след
	self.spells[209202]	= Damage({ru=2}) 																	--Око Тира
--	self.spells[20271]	= Custom(Judgment) 																	--Правосудие
	self.spells[35395]	= Damage({ru=1}) 																	--Удар воина Света
	self.spells[633]	= Custom(LayOnHands) 																--Возложение рук
--	self.spells[20066]	= Custom(Repentance) 																--Покаяние
	self.spells[24275]	= Damage({ru=1}) 																	--Молот гнева
	self.spells[275779]	= Damage({ru=1}) 																	--Правосудие
	self.spells[20271]	= Damage({ru=1}) 																	--Правосудие
	self.spells[275773]	= Damage({ru=1}) 																	--Правосудие
	--self.spells[114158]	= self.spells[114158]															--Молот Света
end
