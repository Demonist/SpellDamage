local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Hunter = Class:create(ClassSpells)
Hunter.dependFromTarget = true
SD.classes["HUNTER"] = Hunter

function Hunter:init()
	--Пронзающий выстрел:
	local PiercingShot = function(data)
		local power = UnitPower("player", SPELL_POWER_FOCUS)
		if power < 20 then
			data.type = SpellEmpty
		else
			data.damage = power * data.damage / 100
		end
	end

	--Камуфляж:
	local Camouflage = function(data)
		data.type = SpellTimeHeal
		data.timeHeal = UnitHealthMax("player") * 0.02 * 60
	end

	--Шипы:
	local Caltrops = function(data)
		data.timeDamage = data.timeDamage * 15
	end

	--Метательные топоры:
	local ThrowingAxes = function(data)
		data.damage = data.damage * 3
	end

	--Живость
	local Exhilaration1 = function(data)
		data.type = SpellHeal
		data.heal = 0.3 * UnitHealthMax("player")
	end

	--Живость
	local Exhilaration2 = function(data)
		data.type = SpellHeal
		data.heal = 0.5 * UnitHealthMax("player")
	end

	--Обходной удар:
	local FlankingStrike = function(data, match)
		if UnitExists("target-target") then
			if UnitIsUnit("target-target", "player") then
				data.damage = match[1] + match[2] * 2
			elseif UnitIsUnit("target-target", "pet") then
				data.damage = match[1] * 2 + match[2]
			end
		end
	end

	--Гром титанов:
	local TitansThunder = function(data)
		data.timeDamage = data.timeDamage * 8
	end


	self.spells[198670]	= Damage({ru=1}, PiercingShot) 							--Пронзающий выстрел
	self.spells[214579]	= DamageAndMana({ru={1,2}}) 							--Рогатые гремучие змеи
	self.spells[194855]	= TimeDamage({ru=1, cn=2, kr=2}) 						--Граната пламени дракона
	self.spells[212436]	= Damage({ru=1}) 										--Свежевание туш
	self.spells[131894]	= TimeDamage({ru=2, en=1, es=1, fr=1, it=1, pt=1}) 		--Стая воронов
	self.spells[120360]	= Damage({ru=2}) 										--Шквал
	self.spells[199483]	= Custom(Camouflage) 									--Камуфляж
	self.spells[162488]	= TimeDamage({ru=2, de=3, cn=3, kr=3}) 					--Капкан
	self.spells[212431]	= Damage({ru=1, de=2, cn=2, kr=2}) 						--Разрывной выстрел
	self.spells[194277]	= Damage({ru=2, de=3, cn=3, kr=4}, Caltrops) 			--Шипы
	self.spells[53209]	= Damage({ru=1}) 										--Выстрел химеры
	self.spells[199530]	= Damage({ru=1}) 										--Топот
	self.spells[194599]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 					--Черная стрела
	self.spells[200163]	= Damage({ru=2}, ThrowingAxes) 							--Метательные топоры
	self.spells[193265]	= Damage({ru=1}) 										--Бросок топорика
	self.spells[191433]	= DamageAndTimeDamage({ru={1,3}, de={1,4}, it={1,2}, cn={1,4}, kr={2,4}}) 	--Взрывная ловушка
	self.spells[186387]	= Damage({ru=2, it=1}) 									--Взрывной выстрел
	self.spells[193455]	= Damage({ru=1}) 										--Выстрел кобры
	self.spells[109304]	= Custom(Exhilaration1) 								--Живость
	--self.spells[194291]	= Custom(Exhilaration2) 								--Живость
	self.spells[2643]	= Damage({ru=2}) 										--Залп
	self.spells[34026]	= Damage({ru=1}) 										--Команда "Взять!"
	self.spells[202800]	= DamageAndDamage({ru={1,2}}, FlankingStrike) 			--Обходной удар
	self.spells[19434]	= Damage({ru=1}) 										--Прицельный выстрел
	self.spells[185901]	= Damage({ru=1}) 										--Прицельный залп
	self.spells[187708]	= Damage({ru=1}) 										--Разделка туши
	self.spells[185855]	= TimeDamage({ru=1}) 									--Режущий удар
	self.spells[186270]	= Damage({ru=1}) 										--Удар ящера
	self.spells[190928]	= Damage({ru=1}) 										--Укус мангуста
	self.spells[185358]	= DamageAndMana({ru={1,2}}) 							--Чародейский выстрел
	self.spells[207068]	= TimeDamage({ru=1, de=3, cn=2, kr=3}, TitansThunder) 	--Гром титанов
	self.spells[207097]	= TimeDamage({ru=1, de=3, cn=2, kr=3}, TitansThunder) 	--Гром титанов
	self.spells[212621]	= Damage({ru=1}) 										--Прицельный залп
	self.spells[204147]	= Damage({ru=1}) 										--Шквальный ветер
	self.spells[203413]	= Damage({ru=1}) 										--Ярость орла
	self.spells[203415]	= Damage({ru=1}) 										--Ярость орла
end
