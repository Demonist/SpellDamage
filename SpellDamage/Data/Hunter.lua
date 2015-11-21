local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Hunter = Class:create(ClassSpells)
SD.classes["HUNTER"] = Hunter

function Hunter:init()
	--Лечение питомца:
	local MendPet = function(data)
		data.type = SpellTimeHeal
		data.timeHeal = 0.25 * UnitHealthMax("pet")
	end

	--Отрыв:
	local Disengage = function(data)
		if Glyphs:contains(132106) then		--Символ освобождения
			data.type = SpellHeal
			data.heal = UnitHealthMax("player") * 0.04
		else
			data.type = SpellEmpty
		end
	end

	--Кормление питомца:
	local FeedPet = function(data, match)
		data.heal = UnitHealthMax("pet") * match / 100
	end

	--Взрывная ловушка:
	local ExplosiveTrap = function(data, description)
		if not Glyphs:contains(119403) then		--Символ взрывной ловушки
			local matchs = matchDigits(description, getLocaleIndex({['ru']={1, 3}, ['tw']={2, 4}}))
			if matchs then
				data.type = SpellDamageAndTimeDamage
				data.damage = matchs[1]
				data.timeDamage = matchs[2]
			end
		else
			data.type = SpellEmpty
		end
	end

	--Выстрел химеры:
	local ChimaeraShot = function(data)
		if Glyphs:contains(119447) then		--Символ выстрела химеры
			data.type = SpellDamageAndHeal
			data.heal = UnitHealthMax("player") * 0.02
		end
	end

	--Разрывной выстрел:
	local ExplosiveShot = function(data, matchs)
		data.damage = matchs[1]
		data.timeDamage = data.damage * matchs[2]
	end

	--Убийственный выстрел:
	local KillShot = function(data, matchs)
		data.damage = matchs[1]
		data.heal = matchs[2] * UnitHealthMax("player") / 100
	end

	--Живость:
	local Exhilaration = function(data, match)
		data.heal = UnitHealthMax("player") * match / 100
	end

	--Бросок глеф:
	local GlaiveToss = function(data, match)
		data.damage = match * 8
	end

	self.spells[136]	= TimeHeal({['ru']=1, ['de']=2, ['cn']=2, ['tw']=2, ['ko']=2}, MendPet)	--Лечение питомца
	self.spells[781]	= Custom(Disengage) 													--Отрыв
	self.spells[2643]	= Damage({['ru']=2, ['fr']=1})											--Залп
	self.spells[3044]	= Damage({['ru']=1})													--Чародейский выстрел
	self.spells[3674]	= TimeDamage({['ru']=1, ['de']=2, ['cn']=2, ['tw']=2, ['ko']=2})		--Черная стрела
	self.spells[6991]	= Heal({['ru']=1}, FeedPet)												--Кормление питомца
	self.spells[13813]	= Custom(ExplosiveTrap)													--Взрывная ловушка
	self.spells[82939]	= self.spells[13813]													--Взрывная ловушка (в режиме метания)
	self.spells[19434]	= Damage({['ru']=1})													--Прицельный выстрел
	self.spells[34026]	= Damage({['ru']=1})													--Команда 'Взять!'
	self.spells[53209]	= Damage({['ru']=1}, ChimaeraShot)										--Выстрел химеры
	self.spells[53301]	= DamageAndTimeDamage({['ru']={1, 2}, ['ko']={3, 1}}, ExplosiveShot)	--Разрывной выстрел
	self.spells[157708]	= DamageAndHeal({['ru']={1, 3}}, KillShot) 								--Убийственный выстрел
	self.spells[56641]	= DamageAndMana({['ru']={1, 2}})										--Верный выстрел
	self.spells[77767]	= DamageAndMana({['ru']={1, 2}})										--Выстрел кобры
	self.spells[109259]	= Damage({['ru']=1})													--Мощный выстрел
	self.spells[109304]	= Heal({['ru']=1}, Exhilaration)										--Живость
	self.spells[117050]	= Damage({['ru']=3, ['en']=1, ['de']=1, ['es']=1, ['fr']=1, ['it']=1, ['pt']=1, ['cn']=1, ['tw']=1, ['ko']=1}, GlaiveToss)	--Бросок глеф
	self.spells[120360]	= TimeDamage({['ru']=2})												--Шквал
	self.spells[152245]	= DamageAndMana({['ru']={1, 2}})										--Сосредоточенный выстрел
	self.spells[163485]	= self.spells[152245]													--Сосредоточенный выстрел
end
