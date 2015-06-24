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

--Божественный оплот:
local AngelicBulwark = MultiParser:create(SpellAbsorb, {1}, function(data, match)
	data.absorb = match[1] * UnitHealthMax("player") / 100
end)

--Молитва отчаяния:
local DesperatePrayer = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = match[1] * UnitHealthMax("player") / 100
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

--Слово Света: Святилище:
local HolyWordSanctuary = MultiParser:create(SpellTimeHeal, {2, 3, 4}, function(data, match)
	data.timeHeal = math.floor(match[4] / match[3]) * match[2]
end)

Priest = Class:create(ClassSpells)
Priest.spells[585]		= SimpleDamageParser 								--Кара
Priest.spells[589]		= DoubleDamageParser 								--Слово Тьмы: Боль
Priest.spells[17]		= PowerWordShield 									--Слово силы: Щит
Priest.spells[2061]		= SimpleHealParser 									--Быстрое исцеление
Priest.spells[47540]	= DoubleParser:create(SpellDamageAndTimeHeal, 1, 2) --Исповедь
Priest.spells[15407]	= SimpleTimeDamageParser 							--Пытка разума
Priest.spells[88625]	= SimpleDamageParser 								--Слово Света: Воздаяние
Priest.spells[108945]	= AngelicBulwark 									--Божественный оплот
Priest.spells[19236]	= DesperatePrayer 									--Молитва отчаяния
Priest.spells[14914]	= DoubleDamageParser 								--Священный огонь
Priest.spells[132157]	= DoubleParser:create(SpellDamageAndHeal, 1, 3) 	--Кольцо света
Priest.spells[88684]	= SimpleHealParser 									--Слово Света: Безмятежность
Priest.spells[8092]		= SimpleDamageParser 								--Взрыв разума
Priest.spells[2944]		= DoubleParser:create(SpellDamageAndHeal, 2, 3) 	--Всепожирающая чума
Priest.spells[139]		= Renew 			 								--Обновление
Priest.spells[34914]	= SimpleTimeDamageParser 							--Прикосновение вампира
Priest.spells[48045]	= SimpleTimeDamageParser 							--Иссушение разума
Priest.spells[2060]		= SimpleHealParser 									--Исцеление
Priest.spells[126135]	= SimpleParser:create(SpellTimeHeal, 3)				--Колодец Света
Priest.spells[73510]	= SimpleDamageParser 								--Пронзание разума
Priest.spells[129250]	= DoubleDamageParser 								--Слово силы: Утешение
Priest.spells[596]		= SimpleHealParser2 								--Молитва исцеления
Priest.spells[129197]	= SimpleTimeDamageParser 							--Безумие
Priest.spells[179338]	= SimpleTimeDamageParser 							--Полное безумие
Priest.spells[32379]	= SimpleTimeDamageParser 							--Слово Тьмы: Смерть
Priest.spells[32546]	= SimpleHealParser 									--Связующее исцеление
Priest.spells[34861]	= SimpleParser:create(SpellHeal, 3) 				--Круг исцеления
Priest.spells[33076]	= SimpleHealParser 									--Молитва восстановления
Priest.spells[64843]	= SimpleTimeHealParser2 				 			--Божественный гимн
Priest.spells[110744]	= SimpleHealParser2 								--Божественная звезда
Priest.spells[122121]	= SimpleDamageParser2 								--Божественная звезда
Priest.spells[121135]	= SimpleHealParser 									--Каскад
Priest.spells[127632]	= SimpleDamageParser 								--Каскад
Priest.spells[120517]	= SimpleHealParser2 								--Сияние
Priest.spells[120644]	= SimpleDamageParser2 								--Сияние
Priest.spells[152116]	= SimpleHealParser 									--Спасительная сила
Priest.spells[155361]	= SimpleTimeDamage2 					 			--Энтропия Бездны
Priest.spells[155245]	= SimpleHealParser 									--Ясная цель
Priest.spells[152118]	= SimpleAbsorbParser 								--Ясность воли

Priest.spells[88685]	= HolyWordSanctuary 								--Слово Света: Святилище
