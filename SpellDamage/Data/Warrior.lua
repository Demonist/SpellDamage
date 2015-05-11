--Опустошитель:
Ravager = MultiParser:create(SpellTimeDamage, {1, 4}, function(data, match)
	data.timeDamage = match[1] * match[4]
	end)

--Кровопускание:
Rend = MultiParser:create(SpellTimeDamage, {1, 3}, function(data, match)
	data.timeDamage = match[1] + match[3]
	end)

--Яростный выпад:
RagingBlow = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.Damage = match[1] + match[2]
	end)

--Вихрь клинков
Bladestorm = MultiParser:create(SpellTimeDamage, {2, 4}, function(data, match)
	data.timeDamage = match[2] * match[4]
	end)

Warrior = Class:create()
Warrior.spells[156287]	= Ravager 				--Опустошитель
Warrior.spells[176318]	= SimpleDamageParser 	--Стенолом – левая рука
Warrior.spells[78]		= SimpleDamageParser 	--Удар героя
Warrior.spells[145585]	= SimpleDamageParser 	--Удар громовержца левой рукой
Warrior.spells[34428]	= SimpleDamageParser 	--Победный раж
Warrior.spells[5308]	= SimpleDamageParser 	--Казнь
Warrior.spells[163201]	= SimpleDamageParser 	--Казнь
Warrior.spells[772]		= Rend 					--Кровопускание
Warrior.spells[163558]	= SimpleDamageParser 	--Внезапная казнь
Warrior.spells[23881]	= SimpleDamageParser 	--Кровожадность
Warrior.spells[23922]	= SimpleDamageParser 	--Мощный удар щитом
Warrior.spells[12294]	= SimpleDamageParser 	--Смертельный удар
Warrior.spells[6343]	= SimpleDamageParser2 	--Удар грома
Warrior.spells[100130]	= SimpleDamageParser 	--Зверский удар
Warrior.spells[57755]	= SimpleDamageParser 	--Героический бросок
Warrior.spells[1680]	= SimpleDamageParser2 	--Вихрь
Warrior.spells[20243]	= SimpleDamageParser 	--Сокрушение
Warrior.spells[103840]	= SimpleDamageParser 	--Верная победа
Warrior.spells[6572]	= SimpleDamageParser 	--Реванш
Warrior.spells[85288]	= RagingBlow 			--Яростный выпад
Warrior.spells[1715]	= SimpleDamageParser 	--Подрезать сухожилия
Warrior.spells[1464]	= SimpleDamageParser 	--Мощный удар
Warrior.spells[118000]	= SimpleDamageParser 	--Рев дракона
Warrior.spells[107570]	= SimpleDamageParser 	--Удар громовержца
Warrior.spells[46968]	= SimpleDamageParser 	--Ударная волна
Warrior.spells[12328]	= SimpleDamageParser 	--Размашистые удары
Warrior.spells[64382]	= SimpleDamageParser 	--Сокрушительный бросок
Warrior.spells[174926]	= SimpleAbsorbParser 	--Непроницаемый щит
Warrior.spells[167105]	= SimpleDamageParser 	--Удар колосса
Warrior.spells[6544]	= SimpleDamageParser2 	--Героический прыжок
Warrior.spells[46924]	= Bladestorm 			--Вихрь клинков
Warrior.spells[152277]	= Ravager 				--Опустошитель
Warrior.spells[176289]	= SimpleDamageParser 	--Стенолом