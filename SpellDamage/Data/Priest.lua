--Слово силы: Щит:
local PowerWordShield = CustomParser:create(function(data, description)
	local match = matchDigit(description, 1)
	if match then
		data.type = SpellAbsorb
		data.absorb = match

		if Glyphs:contains(55672) then		--Символ слова силы: Щит
			data.type = SpellAbsorbAndHeal
			data.heal = data.absorb * 0.2
		end
	end
end)

--Обновление:
local Renew = CustomParser:create(function(data, description)
	if UnitLevel("player") >= 64 then
		local match = matchDigits(description, {1, 2})
		if match then
			data.type = SpellHealAndTimeHeal
			data.heal = match[1]
			data.timeHeal = match[2]
		end
	else
		local match = matchDigit(description, 1)
		if match then
			data.type = SpellTimeHeal
			data.timeHeal = match
		end
	end
end)


--Божественный оплот:
local AngelicBulwark = MultiParser:create(SpellAbsorb, {1}, function(data, match)
	data.absorb = UnitHealthMax("player") * 0.15
end)

--Слово Света: Святилище:
local HolyWordSanctuary = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
	data.timeHeal = match[2] * 15
end)

Priest = Class:create(ClassSpells)
Priest.spells[17]		= PowerWordShield 									--Слово силы: Щит
Priest.spells[139]		= Renew 			 								--Обновление
Priest.spells[585]		= SimpleDamageParser 								--Кара
Priest.spells[589]		= DoubleDamageParser 								--Слово Тьмы: Боль
Priest.spells[596]		= SimpleHealParser2 								--Молитва исцеления
Priest.spells[2060]		= SimpleHealParser 									--Исцеление
Priest.spells[2061]		= SimpleHealParser 									--Быстрое исцеление
Priest.spells[2944]		= DoubleParser:create(SpellDamageAndHeal, 2, 5) 	--Всепожирающая чума
Priest.spells[8092]		= SimpleDamageParser 								--Взрыв разума
Priest.spells[14914]	= DoubleDamageParser 								--Священный огонь
Priest.spells[15407]	= SimpleTimeDamageParser 							--Пытка разума
Priest.spells[19236]	= SimpleHealParser 									--Молитва отчаяния
Priest.spells[32379]	= SimpleTimeDamageParser 							--Слово Тьмы: Смерть
Priest.spells[32546]	= SimpleHealParser 									--Связующее исцеление
Priest.spells[33076]	= SimpleHealParser 									--Молитва восстановления
Priest.spells[34861]	= SimpleParser:create(SpellHeal, 3) 				--Круг исцеления
Priest.spells[34914]	= SimpleTimeDamageParser 							--Прикосновение вампира
Priest.spells[47540]	= DoubleParser:create(SpellDamageAndTimeHeal, 1, 2) --Исповедь
Priest.spells[48045]	= SimpleTimeDamageParser 							--Иссушение разума
Priest.spells[64843]	= SimpleTimeHealParser2 				 			--Божественный гимн
Priest.spells[73510]	= SimpleDamageParser 								--Пронзание разума
Priest.spells[88625]	= SimpleDamageParser 								--Слово Света: Воздаяние
Priest.spells[88684]	= SimpleHealParser 									--Слово Света: Безмятежность
Priest.spells[110744]	= SimpleHealParser2 								--Божественная звезда
Priest.spells[122121]	= SimpleDamageParser2 								--Божественная звезда
Priest.spells[120517]	= SimpleHealParser2 								--Сияние
Priest.spells[120644]	= SimpleDamageParser2 								--Сияние
Priest.spells[121135]	= SimpleHealParser 									--Каскад
Priest.spells[127632]	= SimpleDamageParser 								--Каскад
Priest.spells[126135]	= SimpleParser:create(SpellTimeHeal, 3)				--Колодец Света
Priest.spells[129250]	= DoubleDamageParser 								--Слово силы: Утешение
Priest.spells[132157]	= DoubleParser:create(SpellDamageAndHeal, 1, 3) 	--Кольцо света
Priest.spells[152116]	= SimpleHealParser 									--Спасительная сила
Priest.spells[152118]	= SimpleAbsorbParser 								--Ясность воли
Priest.spells[155245]	= SimpleHealParser 									--Ясная цель
Priest.spells[155361]	= SimpleTimeDamageParser2 					 		--Энтропия Бездны
Priest.spells[129197]	= SimpleTimeDamageParser 							--Безумие
Priest.spells[179338]	= SimpleTimeDamageParser 							--Полное безумие

Priest.spells[108945]	= AngelicBulwark 									--Божественный оплот
Priest.spells[88685]	= HolyWordSanctuary 								--Слово Света: Святилище

-- Подчиняющий разум ?

-------------------------------------------------------------------------------

local locale = GetLocale()

if locale == "enGB" or locale == "enUS" then
	Priest.spells[132157]	= DoubleParser:create(SpellDamageAndHeal, 1, 5) 	--Кольцо света
	return
end

if locale == "deDE" then
	--Обновление:
	local Renew_de = CustomParser:create(function(data, description)
		if UnitLevel("player") >= 64 then
			local match = matchDigits(description, {2, 3})
			if match then
				data.type = SpellHealAndTimeHeal
				data.heal = match[2]
				data.timeHeal = match[3]
			end
		else
			local match = matchDigit(description, 2)
			if match then
				data.type = SpellTimeHeal
				data.timeHeal = match
			end
		end
	end)

	--Слово Света: Святилище:
	local HolyWordSanctuary_de = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
		data.timeHeal = match[4] * 15
	end)

	Priest.spells[139]		= Renew_de 			 									--Обновление
	Priest.spells[589]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Слово Тьмы: Боль
	Priest.spells[14914]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Священный огонь
	Priest.spells[15407]	= SimpleTimeDamageParser2 								--Пытка разума
	Priest.spells[34914]	= SimpleTimeDamageParser2 								--Прикосновение вампира
	Priest.spells[47540]	= DoubleParser:create(SpellDamageAndTimeHeal, 1, 3) 	--Исповедь
	Priest.spells[48045]	= SimpleParser:create(SpellTimeDamage, 3) 				--Иссушение разума
	Priest.spells[64843]	= SimpleParser:create(SpellTimeHeal, 3) 				--Божественный гимн
	Priest.spells[126135]	= SimpleParser:create(SpellTimeHeal, 4)					--Колодец Света
	Priest.spells[129250]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Слово силы: Утешение
	Priest.spells[132157]	= DoubleParser:create(SpellDamageAndHeal, 2, 5) 		--Кольцо света
	Priest.spells[152118]	= SimpleAbsorbParser2 									--Ясность воли
	Priest.spells[155361]	= SimpleParser:create(SpellTimeDamage, 3) 		 		--Энтропия Бездны
	Priest.spells[129197]	= SimpleTimeDamageParser2 								--Безумие
	Priest.spells[179338]	= SimpleParser:create(SpellTimeDamage, 3) 				--Полное безумие
	Priest.spells[88685]	= HolyWordSanctuary_de 									--Слово Света: Святилище
	return
end

if locale == "esES" then
	--Слово Света: Святилище:
	local HolyWordSanctuary_es = MultiParser:create(SpellTimeHeal, {1}, function(data, match)
		data.timeHeal = match[1] * 15
	end)

	Priest.spells[596]		= SimpleHealParser 								--Молитва исцеления
	Priest.spells[34861]	= SimpleHealParser 								--Круг исцеления
	Priest.spells[64843]	= SimpleTimeHealParser 							--Божественный гимн
	Priest.spells[126135]	= SimpleTimeHealParser2							--Колодец Света
	Priest.spells[88685]	= HolyWordSanctuary_es 							--Слово Света: Святилище
	return
end

if locale == "frFR" then
	Priest.spells[596]		= SimpleHealParser 								--Молитва исцеления
	Priest.spells[34861]	= SimpleHealParser 								--Круг исцеления
	Priest.spells[64843]	= SimpleTimeHealParser 							--Божественный гимн
	Priest.spells[126135]	= SimpleTimeHealParser2							--Колодец Света
	return
end

if locale == "itIT" then
	Priest.spells[34861]	= SimpleHealParser 								--Круг исцеления
	Priest.spells[126135]	= SimpleTimeHealParser2							--Колодец Света
	Priest.spells[132157]	= DoubleParser:create(SpellDamageAndHeal, 1, 5) --Кольцо света
	return
end

if locale == "ptBR" then
	--Слово Света: Святилище:
	local HolyWordSanctuary_pt = MultiParser:create(SpellTimeHeal, {1}, function(data, match)
		data.timeHeal = match[1] * 15
	end)

	Priest.spells[596]		= SimpleHealParser 								--Молитва исцеления
	Priest.spells[64843]	= SimpleTimeHealParser 							--Божественный гимн
	Priest.spells[126135]	= SimpleTimeHealParser2							--Колодец Света
	Priest.spells[88685]	= HolyWordSanctuary_pt 							--Слово Света: Святилище
	return
end

if locale == "zhCN" then
	--Слово Света: Святилище:
	local HolyWordSanctuary_cn = MultiParser:create(SpellTimeHeal, {3}, function(data, match)
		data.timeHeal = match[3] * 15
	end)

	Priest.spells[589]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Слово Тьмы: Боль
	Priest.spells[14914]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Священный огонь
	Priest.spells[15407]	= SimpleTimeDamageParser2 								--Пытка разума
	Priest.spells[34914]	= SimpleTimeDamageParser2 								--Прикосновение вампира
	Priest.spells[47540]	= DoubleParser:create(SpellDamageAndTimeHeal, 1, 3) 	--Исповедь
	Priest.spells[48045]	= SimpleTimeDamageParser2 								--Иссушение разума
	Priest.spells[64843]	= SimpleTimeHealParser2 								--Божественный гимн
	Priest.spells[126135]	= SimpleParser:create(SpellTimeHeal, 4)					--Колодец Света
	Priest.spells[129250]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Слово силы: Утешение
	Priest.spells[132157]	= DoubleParser:create(SpellDamageAndHeal, 2, 5) 		--Кольцо света
	Priest.spells[152118]	= SimpleAbsorbParser2 									--Ясность воли
	Priest.spells[155361]	= SimpleParser:create(SpellTimeDamage, 3) 		 		--Энтропия Бездны
	Priest.spells[129197]	= SimpleTimeDamageParser2 								--Безумие
	Priest.spells[179338]	= SimpleTimeDamageParser2 								--Полное безумие
	Priest.spells[88685]	= HolyWordSanctuary_cn 									--Слово Света: Святилище
	return
end
