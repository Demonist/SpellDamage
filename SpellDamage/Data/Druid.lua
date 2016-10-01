local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Combo, ComboDamage, ComboTimeDamage, getComboPoints = SD.Combo, SD.ComboDamage, SD.ComboTimeDamage, SD.Combo.getComboPoints
local Glyphs = SD.Glyphs

--

local Druid = Class:create(ClassSpells)
Druid.dependFromPower = true
Druid.dependPowerTypes["COMBO_POINTS"] = true
Druid.dependPowerTypes["ENERGY"] = true
SD.classes["DRUID"] = Druid

function Druid:init()
	--Ярость Элуны:
	local FuryOfElune = function(data)
		local times = math.floor((UnitPower("player")-60) / 120 + 1)
		data.timeDamage = data.timeDamage * times
	end

	--Обновление:
	local Renewal = function(data)
		data.type = SpellHeal
		data.heal = UnitHealthMax("player") * 0.3
	end

	--Жизнецвет:
	local Lifebloom = function(data)
		data.type = SpellTimeHeal
		data.timeHeal = data.heal + data.timeHeal
	end

	--Свирепый укус:
	local FerociousBite = function(data, description)
		data.type = SpellDamage

		local match = matchDigits(description, {4,6,8,10,12})
		if match and match[1] == 1 then
			match = matchDigits(description, {5,7,9,11,13})
		end

		local combo = getComboPoints()
		if combo == 0 then combo = 1; end
		data.damage = match[combo]

		local energy = UnitPower("player")
		if energy > 25 then energy = 25; end
		data.damage = data.damage + (data.damage * energy / 25)
	end


	self.spells[202028]	= Damage({ru=1}) 																--Жестокий удар когтями
	self.spells[204066]	= DamageAndTimeHeal({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 					--Лунный луч
	self.spells[80313]	= Damage({ru=2}) 																--Раздавить
	self.spells[202770]	= TimeDamage({ru=1, de=2, cn=2, kr=2}, FuryOfElune) 							--Ярость Элуны
	self.spells[202347]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Звездная вспышка
	self.spells[108238]	= Custom(Renewal) 																--Обновление
	self.spells[102351]	= TimeHeal({ru=2, de=3, cn=3, kr=3}) 											--Щит Кенария
	self.spells[48438]	= TimeHeal({ru=3, en=4, es=1, pt=1, de=4, cn=4, kr=4}) 							--Буйный рост
	self.spells[8936]	= HealAndTimeHeal({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 					--Восстановление
	self.spells[1822]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Глубокая рана
	self.spells[33763]	= HealAndTimeHeal({ru={1,2}}, Lifebloom) 										--Жизнецвет
	self.spells[78674]	= Damage({ru=1}) 																--Звездный поток
	self.spells[774]	= TimeHeal({ru=1}) 																--Омоложение
	self.spells[5176]	= Damage({ru=1}) 																--Солнечный гнев
	self.spells[18562]	= Heal({ru=1}) 																	--Быстрое восстановление
	self.spells[191034]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 											--Звездопад
	self.spells[22570]	= ComboDamage({ru={2,3}}) 														--Калечение
	self.spells[194153]	= Damage({ru=1}) 																--Лунный удар
	self.spells[5221]	= Damage({ru=1}) 																--Полоснуть
	self.spells[1079]	= ComboTimeDamage({ru={3,2}}) 													--Разорвать
	self.spells[22568]	= Custom(FerociousBite) 														--Свирепый укус
	self.spells[190984]	= Damage({ru=1}) 																--Солнечный гнев
	self.spells[93402]	= DamageAndTimeDamage({ru={1,2}, de={1,4}, cn={1,4}, kr={1,4}}) 				--Солнечный огонь
	self.spells[740]	= TimeHeal({ru=1, en=2, de=3, cn=3, kr=3}) 										--Спокойствие
	self.spells[6807]	= Damage({ru=1}) 																--Трепка
	self.spells[33917]	= Damage({ru=1}) 																--Увечье
	self.spells[5185]	= Heal({ru=1}) 																	--Целительное прикосновение
	self.spells[210722]	= DamageAndTimeDamage({ru={3,4}, de={3,5}, cn={3,5}, kr={2,5}}) 				--Бешенство Пеплошкурой
	self.spells[210723]	= self.spells[210722] 															--Бешенство Пеплошкурой
	self.spells[77758]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Взбучка
	self.spells[106830]	= self.spells[77758] 															--Взбучка
	self.spells[8921]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Лунный огонь
	self.spells[155625]	= self.spells[8921] 															--Лунный огонь
	self.spells[202767]	= Damage({ru=1}) 																--Новолуние
	self.spells[202771]	= Damage({ru=1}) 																--Полная луна
	self.spells[202768]	= Damage({ru=1}) 																--Полумесяц
	self.spells[164815]	= DamageAndTimeDamage({ru={1,2}, de={1,4}, cn={1,4}, kr={1,4}}) 				--Солнечный огонь
	self.spells[200851]	= Damage({ru=1}) 																--Ярость Спящего
	self.spells[197628]	= Damage({ru=1}) 																--Лунный удар
	self.spells[197626]	= Damage({ru=1}) 																--Звездный поток
	self.spells[106785]	= Damage({ru=1}) 																--Размах
end
