--Разрывной выстрел:
local ExplosiveShot = MultiParser:create(SpellDamageAndTimeDamage, {1, 2}, function(data, match)
	data.damage = match[1]
	data.timeDamage = data.damage * match[2]
end)

--Убийственный выстрел:
local KillShot = MultiParser:create(SpellDamageAndHeal, {1, 3}, function(data, match)
	data.damage = match[1]
	data.heal = match[3] * UnitHealthMax("player") / 100
end)

--Взрывная ловушка:
local ExplosiveTrap = DoubleParser:create(SpellDamageAndTimeDamage, 1, 3)

Hunter = Class:create()
Hunter.spells[3044]		= SimpleDamageParser 		--Чародейский выстрел
Hunter.spells[56641]	= SimpleDamageParser 		--Верный выстрел
Hunter.spells[34026]	= SimpleDamageParser 		--Команда "Взять!"
Hunter.spells[19434]	= SimpleDamageParser 		--Прицельный выстрел
Hunter.spells[53301]	= ExplosiveShot 			--Разрывной выстрел
Hunter.spells[2643]		= SimpleDamageParser2 		--Залп
Hunter.spells[53351]	= KillShot 					--Убийственный выстрел
Hunter.spells[13813]	= ExplosiveTrap			 	--Взрывная ловушка
Hunter.spells[82939]	= ExplosiveTrap			 	--Взрывная ловушка в режиме метания
Hunter.spells[3674]		= SimpleTimeDamageParser 	--Черная стрела
Hunter.spells[53209]	= SimpleDamageParser 		--Выстрел химеры
Hunter.spells[77767]	= SimpleDamageParser 		--Выстрел кобры
Hunter.spells[117050]	= SimpleParser:create(SpellDamage, 3) 	--Бросок глеф
Hunter.spells[109259]	= SimpleDamageParser 		--Мощный выстрел
Hunter.spells[120360]	= SimpleDamageParser2 		--Шквал
Hunter.spells[152245]	= SimpleDamageParser 		--Сосредоточенный выстрел
Hunter.spells[163485]	= SimpleDamageParser 		--Сосредоточенный выстрел