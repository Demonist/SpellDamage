local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local DeathKnight = Class:create(ClassSpells)
SD.classes["DEATHKNIGHT"] = DeathKnight

function DeathKnight:init()
	--Ледяные оковы:
	local ChainsOfIce = function(data, description)
		if Glyphs:contains(58620) then	--Символ ледяных оков
			local match = matchDigit(description, 1)
			if match then
				data.type = SpellDamage
				data.damage = match
			end
		else
			data.type = SpellEmpty
		end
	end

	--Лик смерти:
	local DeathCoil = function(data, matchs)
		data.type = SpellDamage
		data.damage = matchs[1]

		if UnitExists("target") and UnitIsFriend("player", "target") and UnitRace("target") == "Scourge" then
			data.type = SpellHeal
			data.heal = matchs[2]

			if Glyphs:contans(58677) then 	--Символ объятий смерти
				data.type = SpellHealAndMana
				data.mana = 20
			end
		end
	end

	--Усиление рунического оружия:
	local EmpowerRuneWeapon = function(data, match)
		if Glyphs:contains(159421) then	--Символ усиления
			data.type = SpellHealAndMana
			data.heal = UnitHealthMax("player") * 0.3
		end
	end

	--Смертельный союз:
	local DeathPact = function(data, match)
		data.heal = match * UnitHealthMax("player") / 100
	end

	--Смертельное поглощение:
	local DeathSiphon = function(data, matchs)
		data.damage = matchs[1]
		data.heal = data.damage * matchs[2] / 100
	end

	--Преобразование:
	local Conversion = function(data)
		data.type = SpellHeal
		data.heal = UnitHealthMax("player") * 0.02 * UnitMana("player") / 5
	end

	--Осквернение:
	local Defile = function(data)
		data.timeDamage = data.timeDamage * 10
	end

	self.spells[43265]	= TimeDamage({ru=1, de=2, cn=2, tw=2, kr=2}) 	--Смерть и разложение
	self.spells[45462]	= Damage({ru=1}) 								--Удар чумы
	self.spells[45477]	= Damage({ru=1}) 								--Ледяное прикосновение
	self.spells[45524]	= Custom(ChainsOfIce) 							--Ледяные оковы
	self.spells[47541]	= DamageAndHeal({ru={1,2}}, DeathCoil) 			--Лик смерти
	self.spells[47568]	= Mana({ru=1}, EmpowerRuneWeapon) 				--Усиление рунического оружия
	self.spells[48743]	= Heal({ru=1}, DeathPact) 						--Смертельный союз
	self.spells[49020]	= Damage({ru=1}) 								--Уничтожение
	self.spells[49143]	= Damage({ru=1}) 								--Ледяной удар
	self.spells[49184]	= Damage({ru=1}) 								--Воющий ветер
	self.spells[49998]	= DamageAndHeal({ru={1,2}})						--Удар смерти
	self.spells[50842]	= Damage({ru=1, de=2, cn=2, tw=2, kr=2}) 		--Вскипание крови
	self.spells[55090]	= DamageAndDamage({ru={1,2}}) 					--Удар Плети
	self.spells[85948]	= Damage({ru=1}) 								--Удар разложения
	self.spells[108196]	= DamageAndHeal({ru={1,2}}, DeathSiphon)		--Смертельное поглощение
	self.spells[114866]	= DamageAndTimeDamage({ru={1,5}}) 				--Жнец душ
	self.spells[130735]	= DamageAndTimeDamage({ru={1,4}}) 				--Жнец душ
	self.spells[130736]	= DamageAndTimeDamage({ru={1,4}}) 				--Жнец душ
	self.spells[119975]	= Custom(Conversion) 							--Преобразование
	self.spells[152279]	= TimeDamage({ru=1}) 							--Дыхание Синдрагосы
	self.spells[152280]	= TimeDamage({ru=2}, Defile) 					--Осквернение
	self.spells[53717]	= Damage({ru=2, en=1, es=1, fr=1, it=1, pt=1}) 	--Взрыв трупа

	-- Антимагический панцирь ?
end
