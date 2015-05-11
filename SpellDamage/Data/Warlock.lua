--Похищение жизни:
DrainLife = MultiParser:create(SpellDamageAndTimeHeal, {1, 2}, function(data, match)
	data.damage = match[1]
	data.timeHeal = match[2] * UnitHealthMax("player") / 100
end)

--Лик тлена:
MortalCoil = MultiParser:create(SpellHeal, {2}, function(data, match)
	data.timeHeal = match[2] * UnitHealthMax("player") / 100
end)

Warlock = Class:create()
Warlock.spells[686]		= SimpleDamageParser 		--Стрела Тьмы
Warlock.spells[172]		= SimpleTimeDamageParser 	--Порча
Warlock.spells[689]		= DrainLife 		 		--Похищение жизни
Warlock.spells[29722]	= SimpleDamageParser 		--Испепеление
Warlock.spells[116858]	= SimpleDamageParser 		--Стрела Хаоса
Warlock.spells[30108]	= SimpleTimeDamageParser 	--Нестабильное колдовство
Warlock.spells[17962]	= SimpleDamageParser 		--Поджигание
Warlock.spells[348]		= DoubleDamageParser 		--Жертвенный огонь
Warlock.spells[6353]	= SimpleDamageParser 		--Ожог души
Warlock.spells[1454]	= SimpleManaParser 			--Жизнеотвод
Warlock.spells[105174]	= DoubleParser:create(SpellDamageAndTimeDamage, 2, 3) 	--Рука Гул'дана
Warlock.spells[5740]	= SimpleTimeDamageParser 	--Огненный ливень
Warlock.spells[27243]	= SimpleTimeDamageParser 	--Семя порчи
Warlock.spells[1949]	= SimpleTimeDamageParser2 	--Адское пламя
Warlock.spells[103103]	= SimpleTimeDamageParser 	--Похищение души
Warlock.spells[6789]	= MortalCoil 				--Лик тлена
Warlock.spells[980]		= SimpleTimeDamageParser 	--Агония
Warlock.spells[17877]	= SimpleDamageParser 		--Ожог Тьмы
Warlock.spells[48181]	= SimpleDamageParser 		--Блуждающий дух
Warlock.spells[157695]	= SimpleDamageParser 		--Демонический заряд
Warlock.spells[152108]	= SimpleDamageParser 	 	--Катаклизм