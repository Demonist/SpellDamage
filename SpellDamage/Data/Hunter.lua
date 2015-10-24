if GetLocale() ~= "ruRU" then return end

--Отрыв:
local Disengage = CustomParser:create(function(data, description)
	if Glyphs:contains(132106) then		--Символ освобождения
		data.type = SpellHeal
		data.heal = UnitHealthMax("player") * 0.04
	else
		data.type = SpellEmpty
	end
end)

--Лечение питомца:
local MendPet = CustomParser:create(function(data, description)
	local match = matchDigit(description, 1)
	if match then
		data.type = SpellTimeHeal
		data.timeHeal = match * UnitHealthMax("pet") / 100
	end
end)

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
local ExplosiveTrap = CustomParser:create(function(data, description)
	if not Glyphs:contains(119403) then		--Символ взрывной ловушки
		local match = matchDigits(description, {1, 3})
		if match then
			data.type = SpellDamageAndTimeDamage
			data.damage = match[1]
			data.timeDamage = match[3]
		end
	end
end)

--Выстрел химеры:
local ChimaeraShot = CustomParser:create(function(data, description)
	local match = matchDigit(description, 1)
	if match then
		data.type = SpellDamage
		data.damage = match

		if Glyphs:contains(119447) then		--Символ выстрела химеры
			data.type = SpellDamageAndHeal
			data.heal = UnitHealthMax("player") * 0.02
		end
	end
end)

--Бросок глеф:
local GlaiveToss = MultiParser:create(SpellDamage, {3}, function(data, match)
	data.damage = match[3] * 8
end)

Hunter = Class:create(ClassSpells)
Hunter.spells[3044]		= SimpleDamageParser 		--Чародейский выстрел
Hunter.spells[56641]	= SimpleDamageParser 		--Верный выстрел
Hunter.spells[781]		= Disengage 				--Отрыв
Hunter.spells[136]		= MendPet 					--Лечение питомца
Hunter.spells[34026]	= SimpleDamageParser 		--Команда "Взять!"
Hunter.spells[19434]	= SimpleDamageParser 		--Прицельный выстрел
Hunter.spells[53301]	= ExplosiveShot 			--Разрывной выстрел
Hunter.spells[2643]		= SimpleDamageParser2 		--Залп
Hunter.spells[157708]	= KillShot 					--Убийственный выстрел
Hunter.spells[13813]	= ExplosiveTrap			 	--Взрывная ловушка
Hunter.spells[82939]	= ExplosiveTrap			 	--Взрывная ловушка, в режиме метания
Hunter.spells[3674]		= SimpleTimeDamageParser 	--Черная стрела
Hunter.spells[53209]	= ChimaeraShot 				--Выстрел химеры
Hunter.spells[77767]	= SimpleDamageParser 		--Выстрел кобры
Hunter.spells[117050]	= GlaiveToss 				--Бросок глеф
Hunter.spells[109259]	= SimpleDamageParser 		--Мощный выстрел
Hunter.spells[120360]	= SimpleDamageParser2 		--Шквал
Hunter.spells[152245]	= SimpleDamageParser 		--Сосредоточенный выстрел
Hunter.spells[163485]	= SimpleDamageParser 		--Сосредоточенный выстрел
