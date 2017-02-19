local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex, TimeDamageAndTimeDamage = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex, SD.TimeDamageAndTimeDamage
local Glyphs = SD.Glyphs

--

local Warrior = Class:create(ClassSpells)
Warrior.dependFromTarget = true
Warrior.dependFromPower = true
Warrior.dependPowerTypes["RAGE"] = true
SD.classes["WARRIOR"] = Warrior

function Warrior:init()
	--Боевой крик:
	local BattleCry = function(data)
		if IsPlayerSpell(202751) then 	--Безудержная энергия
			data.type = SpellMana
			data.mana = 100
		else
			data.type = SpellEmpty
		end
	end

	--Деморализующий крик:
	local DemoralizingShout = function(data)
		if IsPlayerSpell(202743) then 	--Луженая глотка
			data.type = SpellMana
			data.mana = 50
		else
			data.type = SpellEmpty
		end
	end

	--Верная победа:
	local ImpendingVictory = function(data)
		data.type = SpellDamageAndHeal
		data.heal = UnitHealthMax("player") * 0.15
	end

	--Вихрь:
	local Whirlwind = function(data)
		if IsPlayerSpell(215537) or IsPlayerSpell(215538) then 	--Травма
			data.type = SpellDamageAndTimeDamage
			data.timeDamage = data.damage * 0.2
		end
	end

	--Казнь:
	local Execute = function(data, match)
		local power = UnitPower("player", SPELL_POWER_RAGE) 
		if power > 30 then power = 30; end
		data.damage = match[1] + match[2] * power / 30
	end

	--Кровожадность:
	local Bloodthirst = function(data)
		local factor = 0.04
		data.type = SpellDamageAndHeal
		if IsPlayerSpell(200859) then 	--Кровавое безумие
			factor = 0.05
		end
		if UnitBuff("player", L["enraged_regeneration"]) then
			factor = factor + 0.2
		end
		data.heal = UnitHealthMax("player") * factor
	end

	--Перехват:
	local Intercept = function(data)
		if IsPlayerSpell(103828) then 	--Вестник войны
			local warbringerDescr = GetSpellDescription(103828)
			if warbringerDescr then
				local match = matchDigit(warbringerDescr, getLocaleIndex({ru=1, de=2, cn=2, kr=2}))
				if match then
					data.type = SpellDamageAndMana
					data.damage  = match
				end
			end
		end
	end

	--Победный раж:
	local VictoryRush = function(data)
		data.type = SpellDamageAndHeal
		data.heal = UnitHealthMax("player") * 0.3
	end

	--Смертельный удар:
	local MortalStrike = function(data)
		if IsPlayerSpell(215550) and UnitExists("target") and (UnitHealth("target") / UnitHealthMax("target")) < 0.2 then 	--Добивание
			data.type = SpellDamageAndMana
			data.mana = 20
		end
	end

	--Сокрушение:
	local Devastate = function(data)
		if IsPlayerSpell(115767) then 	--Глубокие раны
			local deepWoundsDescr = GetSpellDescription(115767)
			if deepWoundsDescr then
				local match = matchDigit(description, getLocaleIndex({ru=1, de=2, cn=2, kr=2}))
				if match then
					data.type = SpellDamageAndTimeDamage
					data.timeDamage = match
				end
			end
		end
	end

	--Рывок:
	local Charge = function(data)
		if IsPlayerSpell(200856) then 	--Неуправляемая ярость
			data.mana = data.mana + 5
		end
	end

	---Мощный удар:
	local Slam = Whirlwind


	self.spells[1719]	= Custom(BattleCry) 												--Боевой крик
	self.spells[46924]	= TimeDamage({ru=2, de=3, cn=3, kr=3}) 								--Вихрь клинков
	self.spells[152277]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 								--Опустошитель
	self.spells[228920]	= self.spells[152277] 												--Опустошитель
	self.spells[118000]	= CriticalDamage({ru=1, de=2, cn=2, kr=2}) 							--Рев дракона
	self.spells[1160]	= Custom(DemoralizingShout) 										--Деморализующий крик
	self.spells[772]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 								--Кровопускание
	self.spells[202168]	= Damage({ru=1}, ImpendingVictory) 									--Верная победа
	self.spells[7384]	= Damage({ru=1}) 													--Превосходство
	self.spells[107570]	= TimeDamage({ru=1}) 												--Удар громовержца
	self.spells[46968]	= Damage({ru=1, de=2, kr=2}) 										--Ударная волна
	self.spells[184367]	= Damage({ru=3}) 													--Буйство
	self.spells[1680]	= Damage({ru=2, it=1}, Whirlwind) 									--Вихрь
	self.spells[190411]	= Damage({ru=2, it=1}, Whirlwind) 									--Вихрь
	self.spells[227847]	= Damage({ru=2, de=3, cn=3, kr=3}) 									--Вихрь клинков
	self.spells[5308]	= Damage({ru=1}) 													--Казнь
	self.spells[163201]	= DamageAndDamage({ru={1,3}}, Execute) 								--Казнь
	self.spells[23881]	= Damage({ru=1}, Bloodthirst) 										--Кровожадность
	self.spells[100130]	= Damage({ru=1}) 													--Неистовый удар сплеча
	self.spells[198304]	= Mana({ru=6}, Intercept) 											--Перехват
	self.spells[34428]	= Damage({ru=1}, VictoryRush) 										--Победный раж
	self.spells[1715]	= Damage({ru=1}) 													--Подрезать сухожилия
	self.spells[845]	= Damage({ru=1}) 													--Рассекающий удар
	self.spells[6572]	= Damage({ru=1}) 													--Реванш
	self.spells[206572]	= Damage({ru=1}) 													--Рывок дракона
	self.spells[12294]	= Damage({ru=1}, MortalStrike) 										--Смертельный удар
	self.spells[20243]	= Damage({ru=1}, Devastate) 										--Сокрушение
	self.spells[190456]	= Absorb({ru=2, cn=1, kr=1}) 										--Стойкость к боли
	self.spells[167105]	= Damage({ru=1}) 													--Удар колосса
	self.spells[85288]	= DamageAndMana({ru={1,2}}) 										--Яростный выпад
	self.spells[57755]	= Damage({ru=1}) 													--Героический бросок
	self.spells[6544]	= Damage({ru=2, en=1, es=1, fr=1, it=1, pt=1}) 						--Героический прыжок
	self.spells[209577]	= Damage({ru=1}) 													--Миротворец
	self.spells[100]	= Mana({ru=2, de=1}, Charge) 										--Рывок
	self.spells[203524]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 								--Ярость Нелтариона
	self.spells[203526]	= self.spells[203524] 												--Ярость Нелтариона
	self.spells[205545]	= DamageAndTimeDamage({ru={2,3}, de={3,5}, cn={3,5}, kr={3,5}}) 	--Ярость Одина
	self.spells[205546]	= self.spells[205545] 												--Ярость Одина
	self.spells[205547]	= self.spells[205545] 												--Ярость Одина
	self.spells[23922]	= DamageAndMana({ru={1,3}}) 										--Мощный удар щитом
	self.spells[1464]	= Damage({ru=1}, Slam) 												--Мощный удар
	self.spells[6343]	= DamageAndMana({ru={2,5}}) 										--Удар грома
end
