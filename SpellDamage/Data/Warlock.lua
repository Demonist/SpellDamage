local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local Warlock = Class:create(ClassSpells)
SD.classes["WARLOCK"] = Warlock

function Warlock:init()
	--Направленный демонический огонь:
	local ChannelDemonfire = function(data)
		data.timeDamage = data.timeDamage * 15
	end

	--Призрачная сингулярность:
	local PhantomSingularity = function(data)
		data.type = SpellTimeDamageAndTimeHeal
		data.timeHeal = data.timeDamage * 0.3
	end

	--Похищение души:
	local DrainSoul = function(data, match)
		data.timeHeal = data.timeDamage * match[2] / 100
	end

	--Жизнеотвод:
	local LifeTap = function(data)
		data.type = SpellMana
		data.mana = UnitManaMax("player") * 0.3
	end

	--Похищение жизни:
	local DrainLife = function(data, match)
		data.type = SpellTimeDamageAndTimeHeal
		data.timeHeal = data.timeDamage * match[2] / 100
	end

	--Вытягивание жизни:
	local SiphonLife = function(data, match)
		data.timeHeal = data.timeDamage * match[2] / 100
	end


	self.spells[157695]	= Damage({ru=1}) 																--Демонический заряд
	self.spells[196447]	= TimeDamage({ru=4}, ChannelDemonfire) 											--Направленный демонический огонь
	self.spells[205179]	= TimeDamage({ru=2, de=3, cn=3, kr=3}, PhantomSingularity) 						--Призрачная сингулярность
	self.spells[205180]	= Damage({ru=2}) 																--Призыв созерцателя Тьмы
	self.spells[196277]	= Damage({ru=1, de=2, cn=2, kr=2}) 												--Имплозия
	self.spells[152108]	= Damage({ru=1, de=2, cn=2, kr=2}) 												--Катаклизм
	self.spells[48181]	= Damage({ru=1}) 																--Блуждающий дух
	self.spells[17877]	= Damage({ru=1}) 																--Ожог Тьмы
	self.spells[205181]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Пламя Тьмы
	self.spells[198590]	= TimeDamageAndTimeHeal({ru={2,3}, fr={1,2}}, DrainSoul) 						--Похищение души
	self.spells[980]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 											--Агония
	self.spells[348]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Жертвенный огонь
	self.spells[29722]	= Damage({ru=1}) 																--Испепеление
	self.spells[30108]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 											--Нестабильное колдовство
	self.spells[172]	= TimeDamage({ru=2, en=1, es=1, fr=1, it=1, pt=1}) 								--Порча
	self.spells[686]	= Damage({ru=1}) 																--Стрела Тьмы
	self.spells[116858]	= CriticalDamage({ru=1}) 														--Стрела Хаоса
	self.spells[193440]	= TimeDamage({ru=2, de=3, es=1, fr=1, it=1, pt=1, cn=3, kr=3}) 					--Демонический гнев
	self.spells[193541]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}) 				--Жертвенный огонь
	self.spells[1454]	= Custom(LifeTap) 																--Жизнеотвод
	self.spells[5740]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 											--Огненный ливень
	self.spells[17962]	= Damage({ru=1}) 																--Поджигание
	self.spells[27243]	= TimeDamage({ru=2, de=3, cn=3, kr=3}) 											--Семя порчи
	self.spells[187394]	= Damage({ru=1}) 																--Залп Хаоса
	self.spells[689]	= TimeDamageAndTimeHeal({ru={1,3}}, DrainLife) 									--Похищение жизни
	self.spells[1122]	= Damage({ru=1, it=2}) 															--Призыв инфернала
	self.spells[196657]	= Damage({ru=1}) 																--Стрела Тьмы
	self.spells[215279]	= CriticalDamage({ru=1}) 														--Стрела Хаоса
	self.spells[63106]	= TimeDamageAndTimeHeal({ru={1,3}, de={2,3}, cn={2,3}, kr={2,3}}, SiphonLife) 	--Вытягивание жизни
	self.spells[603]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 											--Рок
	self.spells[105174]	= Damage({ru=2, de=3, cn=3, kr=3}) 												--Рука Гул'дана
end
