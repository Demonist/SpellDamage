local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local DemonHunter = Class:create(ClassSpells)
SD.classes["DEMONHUNTER"] = DemonHunter

function DemonHunter:init()
	--Раскалывание душ:
	local SoulCleave = function(data)
		local energy = UnitPower("player")
		if energy > 60 then energy = 60;
		elseif energy < 30 then energy = 30; end
		data.damage = data.damage * energy / 60
		data.heal = data.heal * energy / 60
	end

	--Бросок боевого клинка:
	local ThrowGlaive = function(data)
		if IsPlayerSpell(206473) then 	--Кровопускание
			local bloodletDescr = GetSpellDescription(206473)
			if bloodletDescr then
				local match = matchDigit(bloodletDescr, getLocaleIndex({ru=1, de=2, cn=2}))
				if match then
					data.type = SpellDamageAndTimeDamage
					data.timeDamage = match / 100 * data.damage
				end
			end
		end
	end


	self.spells[211053]	= Damage({ru=1}) 														--Обстрел Скверны
	self.spells[210152] 	= Damage({ru=1})														--Смертоносный взмах
	self.spells[201427] 	= Damage({ru=1})														--Аннигиляция
	self.spells[227225]	= Absorb({ru=1, en=2, de=2, es=2, fr=2, it=2, pt=2, kr=2}) 				--Призрачный барьер
	self.spells[218679]	= Damage({ru=1}) 														--Взрывная душа
	self.spells[212084]	= TimeDamageAndTimeHeal({ru={1,3}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Опустошение Скверны
	self.spells[211881]	= Damage({ru=1}) 														--Извержение Скверны
	self.spells[209795]	= Damage({ru=1}) 														--Трещина
	self.spells[213241]	= Damage({ru=1}) 														--Клинок Скверны
	self.spells[204157]	= Damage({ru=1}) 														--Бросок боевого клинка
	self.spells[178740]	= DamageAndTimeDamage({ru={1,3}, de={2,3}, cn={2,3}, kr={2,4}}) 		--Жар преисподней
	self.spells[189110]	= Damage({ru=1, de=2, cn=2, kr=2}) 										--Инфернальный удар
	self.spells[203782]	= Damage({ru=1}) 														--Иссечение
	self.spells[204021]	= Damage({ru=1}) 														--Огненное клеймо
	self.spells[228477]	= DamageAndHeal({ru={1,2}}, SoulCleave) 								--Раскалывание душ
	self.spells[185123]	= Damage({ru=1}, ThrowGlaive) 											--Бросок боевого клинка
	self.spells[179057]	= Damage({ru=2}) 														--Кольцо Хаоса
	self.spells[191427]	= Damage({ru=1, de=2, cn=2, kr=2}) 										--Метаморфоза
	self.spells[198013]	= CriticalDamage({ru=1}) 												--Пронзающий взгляд
	self.spells[207407]	= DamageAndTimeDamage({ru={1,2}}) 										--Разрубатель душ
	self.spells[214743]	= self.spells[207407] 													--Разрубатель душ
	self.spells[195072]	= Damage({ru=1}) 														--Рывок Скверны
	self.spells[188499]	= Damage({ru=1}) 														--Танец клинков
	self.spells[162794]	= Damage({ru=1}) 														--Удар Хаоса
	self.spells[197125]	= self.spells[162794] 													--Удар Хаоса
	self.spells[162243]	= Damage({ru=1}) 														--Укус демона
	self.spells[201467]	= TimeDamage({ru=2, de=3, cn=3, kr=3}) 									--Ярость иллидари
	self.spells[201628]	= self.spells[201467] 													--Ярость иллидари
	self.spells[201789]	= self.spells[201467] 													--Ярость иллидари
	self.spells[198793]	= Damage({ru=1}) 														--Коварное отступление
	self.spells[204596]	= DamageAndTimeDamage({ru={2,3}, cn={2,4}, kr={2,4}}) 					--Печать огня
end
