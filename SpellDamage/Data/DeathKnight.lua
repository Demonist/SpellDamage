--Удар Плети:
local ScourgeStrike = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1] + match[2]
end)

--Преобразование:
local Conversion = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = match[1] * UnitHealthMax("player") / 100
end)

--Смертельное поглощение:
local DeathSiphon = MultiParser:create(SpellDamageAndHeal, {1, 2}, function(data, match)
	data.damage = match[1]
	data.heal = data.damage * match[2] / 100
end)

--Смертельный союз:
local DeathPact = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = match[1] * UnitHealthMax("player") / 100
end)

DeathKnight = Class:create()
DeathKnight.spells[49184]	= SimpleDamageParser 		--Воющий ветер
DeathKnight.spells[49143]	= SimpleDamageParser 		--Ледяной удар
DeathKnight.spells[50842]	= SimpleDamageParser 		--Вскипание крови
DeathKnight.spells[45477]	= SimpleDamageParser 		--Ледяное прикосновение
DeathKnight.spells[47541]	= DoubleParser:create(SpellDamageAndHeal, 1, 2) 	--Лик смерти
DeathKnight.spells[45462]	= SimpleDamageParser 		--Удар чумы
DeathKnight.spells[49998]	= DoubleParser:create(SpellDamageAndHeal, 1, 2)		--Удар смерти
DeathKnight.spells[55090]	= ScourgeStrike 			--Удар Плети
DeathKnight.spells[49020]	= SimpleDamageParser 		--Уничтожение
DeathKnight.spells[43265]	= SimpleTimeDamageParser 	--Смерть и разложение
DeathKnight.spells[85948]	= SimpleDamageParser 		--Удар разложения
DeathKnight.spells[119975]	= Conversion 				--Преобразование
DeathKnight.spells[108196]	= DeathSiphon			 	--Смертельное поглощение
DeathKnight.spells[48743]	= DeathPact 				--Смертельный союз
DeathKnight.spells[114866]	= SimpleDamageParser 		--Жнец душ
DeathKnight.spells[130735]	= SimpleDamageParser 		--Жнец душ
DeathKnight.spells[130736]	= SimpleDamageParser 		--Жнец душ
DeathKnight.spells[152279]	= SimpleTimeDamageParser 	--Дыхание Синдрагосы
DeathKnight.spells[152280]	= SimpleTimeDamage2 		--Осквернение