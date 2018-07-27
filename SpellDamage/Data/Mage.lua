local L, shortNumber, matchDigit, matchDigits, printTable, strstarts, Buff, Debuff = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts, SD.Buff, SD.Debuff
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal, SpellAbsorbAndDamage = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal, SD.SpellAbsorbAndDamage
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex, ManaAndTimeMana, TimeDamageAndTimeDamage, AbsorbAndDamage = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex, SD.ManaAndTimeMana, SD.TimeDamageAndTimeDamage, SD.AbsorbAndDamage
local Glyphs = SD.Glyphs

--

local Mage = Class:create(ClassSpells)
Mage.dependFromTarget = true
SD.classes["MAGE"] = Mage

function Mage:init()
	--Буря комет:
	local CometStorm = function(data)
		data.damage = data.damage * 7
	end

	--Вихрь углей:
	local Cinderstorm = function(data)
		data.damage = data.damage * 6
		if UnitExists("target") and Debuff("target", L["conflagration"]) then
			data.damage = data.damage * 1.3
		end
	end

	--Взрывная волна:
	local BlastWave = function(data)
		if UnitExists("target") and UnitIsEnemy("player", "target") then
			data.damage = data.damage * 2
		end
	end

	--Кольцо обледенения:
	local IceNova = BlastWave

	--Сверхновая:
	local Supernova = BlastWave

	--Морозный луч:
	local RayOfFrost = function(data, description)
		data.type = SpellTimeDamage
		local matchs = matchDigits(description, getLocaleIndex({ru={2,4,1}, en={3,1,2}, de={2,1,3}, es={3,1,2}, fr={3,1,2}, it={3,1,2}, pt={3,1,2}, cn={3,1,4}, kr={2,1,3}}))
		local fin_damage = matchs[1]
		for i = matchs[1],matchs[2] do
			fin_damage = (fin_damage * 1.1) + matchs[3]
			--print(matchs[2])
			--i = i + 0.9
		end
		data.timeDamage = fin_damage
	end

	--Прилив сил:
	local Evocation = function(data)
		data.type = SpellTimeMana
		data.timeMana = UnitPowerMax("player")
	end

	--Знак Алунета:
	local MarkOfAluneth = function(data, matchs)
		data.damage = matchs[1]
		data.timeDamage = math.floor((UnitPowerMax("player") / 100) * matchs[2])
	end

	--Ледяное копье:
	local IceLance = function(data)
		if Buff("player", L["fingers_of_frost"]) then
			data.damage = data.damage * 3
		end
	end

	--Ледяная глыба:
	local IceBlock = function(data)
		data.type = SpellEmpty
		if IsPlayerSpell(11958) then 	--Холодная хватка
			data.type = SpellTimeHeal
			data.timeHeal = UnitHealthMax("player") * 0.03 * 10
		end
	end

	--Огненный столб:
	local Flamestrike = function(data)
		if IsPlayerSpell(205037) then 	--Огненный след
			local flamePatchDescr = GetSpellDescription(205037)
			if flamePatchDescr then
				local match = matchDigit(flamePatchDescr, getLocaleIndex({ru=1, de=2, cn=2, kr=2}))
				if match then
					data.type = SpellDamageAndTimeDamage
					data.timeDamage = match
				end
			end
		end
	end

		--Дыхание дракона:
	local DragonsBreath = function(data)
		if IsPlayerSpell(235870) then 	--Ярость Алекстразы
			data.damage = data.damage * 2
		end
	end

			--Дыхание дракона:
	local GreatPyroblast = function(data, match)
			data.damage = UnitHealthMax("target") * (match / 100)
	end

	self.spells[153595]	= Damage({ru=2, de =3, cn=3, kr=3}, CometStorm) 					--Буря комет
	self.spells[198929]	= Damage({ru=2}, Cinderstorm) 										--Вихрь углей
	self.spells[199786]	= Damage({ru=1}) 													--Ледовый шип
	self.spells[153561]	= DamageAndTimeDamage({ru={2,4}, de={2,5}, cn={2,5}, kr={3,5}}) 	--Метеор
	self.spells[153626]	= Damage({ru=2}) 													--Чародейский шар
	self.spells[114923]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 								--Буря Пустоты
	self.spells[44457]	= TimeDamageAndTimeDamage({ru={1,4}, en={1,3}, de={2.4}, es={1,3}, fr={1,3}, it={1,3}, pt={1,3}, cn={2,4}, kr={2,4}}) 	--Живая бомба
	self.spells[157981]	= Damage({ru=1, de=2, cn=2, kr=2}, BlastWave) 						--Взрывная волна
	self.spells[157997]	= Damage({ru=1, de=2, cn=2, kr=2}, IceNova) 						--Кольцо обледенения
	self.spells[157980]	= Damage({ru=1, de=2, cn=2, kr=2}, Supernova) 						--Сверхновая
	self.spells[205021]	= Custom(RayOfFrost) 												--Морозный луч 
	self.spells[116]	= Damage({ru=1}) 													--Ледяная стрела
	self.spells[11366]	= Damage({ru=1}) 													--Огненная глыба
	self.spells[133]	= Damage({ru=1}) 													--Огненный шар
	self.spells[2948]	= Damage({ru=1}) 													--Ожог
	self.spells[12051]	= Custom(Evocation) 												--Прилив сил
	self.spells[30451]	= Damage({ru=1}) 													--Чародейская вспышка
	self.spells[44614]	= Damage({ru=2}) 													--Шквал
--	self.spells[31661]	= Damage({ru=1}) 													--Дыхание дракона
	self.spells[31661]	= Damage({ru=1}, DragonsBreath)										--Дыхание дракона
	self.spells[120]	= Damage({ru=1}) 													--Конус холода
	self.spells[30455]	= Damage({ru=1}, IceLance) 											--Ледяное копье
	self.spells[84714]	= Damage({ru=2}) 													--Ледяной шар
	self.spells[108853]	= CriticalDamage({ru=1}) 											--Огненный взрыв
	self.spells[190356]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 								--Снежная буря
	self.spells[5143]	= Damage({ru=3, en=2, de=2, es=2, fr=2, it=2, pt=2, cn=2, kr=3}) 	--Чародейские стрелы
	self.spells[1449]	= Damage({ru=1, de=2, cn=2, kr=2}) 									--Чародейский взрыв
	self.spells[44425]	= Damage({ru=1}) 													--Чародейский обстрел
	self.spells[210726]	= self.spells[224968] 												--Знак Алунета
	self.spells[211076]	= Damage({ru=1, de=2, cn=2, kr=2}) 									--Знак Алунета
	self.spells[211088]	= Damage({ru=1}) 													--Знак Алунета
	self.spells[122]	= Damage({ru=2}) 													--Кольцо льда
	self.spells[11426]	= Absorb({ru=2, en=1, es=1, fr=1, it=1, pt=1, cn=1}) 				--Ледяная преграда
	self.spells[235313]	= AbsorbAndDamage({ru={2,3}, en={1,3}, es={1,3}, fr={1,3}, it={1,3}, pt={1,3}, cn={1,3}})	--Пылающая преграда
	self.spells[235450]	= Absorb({ru=2, en=1, es=1, fr=1, it=1, pt=1, cn=1}) 				--Призматичный барьер
	self.spells[194466]	= CriticalDamage({ru=1}) 											--Пламя феникса
	self.spells[257541] = CriticalDamage({ru=1}) 											--Пламя феникса
	self.spells[214634]	= Damage({ru=1}) 													--Полярная стрела
	self.spells[257537]	= Damage({ru=1}) 													--Полярная стрела
	self.spells[2120]	= Damage({ru=1}, Flamestrike) 										--Огненный столб
	self.spells[45438]	= Custom(IceBlock) 													--Ледяная глыба
	self.spells[203286] = Damage({ru=1}, GreatPyroblast) 									--Пламя феникса
end
