local TimeDamageHauntHelper = function(index)
	return MultiParser:create(SpellTimeDamage, {index}, function(data, match)
		if UnitDebuff("target", "Блуждающий дух") then
			data.timeDamage = match[index] * 1.35
		else
			data.timeDamage = match[index]
		end
	end)
end
local TimeDamageHaunt, TimeDamageHaunt2 = TimeDamageHauntHelper(1), TimeDamageHauntHelper(2)

--Похищение жизни:
local DrainLife = MultiParser:create(SpellDamageAndTimeHeal, {1, 2}, function(data, match)
	data.damage = match[1]
	data.timeHeal = match[2]
end)

--Стрела Хаоса:
local ChaosBolt = MultiParser:create(SpellDamage, {1}, function(data, match)
	data.damage = match[1] * 2
end)

--Канал здоровья:
local HealthFunnel = CustomParser:create(function(data, description)
	data.type = SpellHeal

	if Glyphs:contains(56238) then		--Символ канала здоровья
		data.heal = UnitHealthMax("pet") * 0.15
	else
		data.heal = UnitHealthMax("pet") * 0.36
	end
end)

--Углеотвод:
local EmberTap = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = match[1] * UnitHealthMax("player") / 100
end)

--Жизнеотвод:
local LifeTap = CustomParser:create(function(data, description)
	local match = nil
	
	if Glyphs:contains(63320) then		--Символ жизнеотвода
		match = matchDigit(description, 2)
	else
		match = matchDigit(description, 1)
	end

	if match then
		data.type = SpellMana
		data.mana = match
	end
end)

--Лик тлена:
local MortalCoil = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = match[1] * UnitHealthMax("player") / 100
end)

Warlock = Class:create(ClassSpells)
Warlock.dependFromTarget = true
Warlock.spells[686]		= SimpleDamageParser 									--Стрела Тьмы
Warlock.spells[172]		= TimeDamageHaunt 										--Порча
Warlock.spells[689]		= DrainLife 		 									--Похищение жизни
Warlock.spells[114654]	= SimpleDamageParser 									--Испепеление
Warlock.spells[29722]	= SimpleDamageParser 									--Испепеление
Warlock.spells[116858]	= ChaosBolt 											--Стрела Хаоса
Warlock.spells[30108]	= TimeDamageHaunt 										--Нестабильное колдовство
Warlock.spells[17962]	= SimpleDamageParser 									--Поджигание
Warlock.spells[108685]	= SimpleDamageParser2 									--Поджигание
Warlock.spells[755]		= HealthFunnel 											--Канал здоровья
Warlock.spells[348]		= DoubleDamageParser 									--Жертвенный огонь
Warlock.spells[108686]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3) 	--Жертвенный огонь
Warlock.spells[6353]	= SimpleDamageParser 									--Ожог души
Warlock.spells[114635]	= EmberTap 												--Углеотвод
Warlock.spells[1454]	= LifeTap 												--Жизнеотвод
Warlock.spells[105174]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3) 	--Рука Гул'дана
Warlock.spells[5740]	= TimeDamageHaunt 										--Огненный ливень
Warlock.spells[104232]	= TimeDamageHaunt 										--Огненный ливень
Warlock.spells[27243]	= TimeDamageHaunt 										--Семя порчи
Warlock.spells[1949]	= TimeDamageHaunt2 										--Адское пламя
Warlock.spells[103103]	= TimeDamageHaunt 										--Похищение души
Warlock.spells[6789]	= MortalCoil 											--Лик тлена
Warlock.spells[980]		= TimeDamageHaunt 										--Агония
Warlock.spells[17877]	= SimpleDamageParser 									--Ожог Тьмы
Warlock.spells[48181]	= SimpleDamageParser 									--Блуждающий дух
Warlock.spells[157695]	= SimpleDamageParser 									--Демонический заряд
Warlock.spells[152108]	= SimpleDamageParser 	 								--Катаклизм
