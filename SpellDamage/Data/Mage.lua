-- local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
-- local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
-- local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
-- local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
-- local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
-- local Glyphs = SD.Glyphs

-- --

-- --Чародейские стрелы:
-- local ArcaneMissiles = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
-- 	data.timeDamage = match[3] * 5
-- end)

-- --Прилив сил:
-- local Evocation = MultiParser:create(SpellManaAndTimeMana, {1, 2}, function(data, match)
-- 	local maxMana = UnitManaMax("player")
-- 	data.mana = match[1] * maxMana / 100
-- 	data.timeMana = match[2] * maxMana / 100
-- end)

-- --Ледяное копье:
-- local IceLance = MultiParser:create(SpellDamage, {1}, function(data, match)
-- 	data.damage = match[1]

-- 	if UnitExists("target") and UnitBuff("target", L["frost_bomb"]) then
-- 		local description = GetSpellDescription(112948)	--Ледяная бомба
-- 		if description then
-- 			local match = matchDigit(description, 3)
-- 			if match then
-- 				data.damage = data.damage + match
-- 			end
-- 		end
-- 	end
-- end)

-- --Живая бомба:
-- local LivingBomb = MultiParser:create(SpellTimeDamage, {1, 4}, function(data, match)
-- 	data.timeDamage = match[1] + match[4]
-- end)

-- --Ледяная глыба:
-- local IceBlock = CustomParser:create(function(data, description)
-- 	if Glyphs:contains(159486) then		--Символ возрождающего льда
-- 		local match = matchDigit(description, 1)
-- 		if match then
-- 			data.type = SpellTimeHeal
-- 			data.timeHeal = UnitHealthMax("player") * 0.04 * match
-- 		end
-- 	else
-- 		data.type = SpellEmpty
-- 	end
-- end)

-- --Пламенный взрыв:
-- local InfernoBlast = MultiParser:create(SpellDamage, {1}, function(data, match)
-- 	data.damage = match[1] * 2
-- end)

-- --Буря комет:
-- local CometStorm = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
-- 	data.damage = match[2] * match[1]
-- end)

-- --Сверхновая:
-- local Supernova = MultiParser:create(SpellDamage, {1}, function(data, match)
-- 	data.damage = match[1]
-- 	if UnitExists("target") and UnitIsEnemy("player", "target") then
-- 		data.damage = data.damage * 2
-- 	end
-- end)

-- --Взрывная волна:
-- local BlastWave = Supernova

-- --Кольцо обледенения:
-- local IceNova = Supernova

-- local Mage = Class:create(ClassSpells)
-- SD.Mage = Mage
-- Mage.dependFromTarget = true
-- Mage.spells[10]		= SimpleTimeDamageParser 	--Снежная буря
-- Mage.spells[116]	= SimpleDamageParser 		--Ледяная стрела
-- Mage.spells[120]	= SimpleDamageParser		--Конус холода
-- Mage.spells[122]	= SimpleDamageParser2		--Кольцо льда
-- Mage.spells[133]	= SimpleDamageParser		--Огненный шар
-- Mage.spells[1449]	= SimpleDamageParser 		--Чародейский взрыв
-- Mage.spells[2120]	= DoubleDamageParser		--Огненный столб
-- Mage.spells[2136]	= SimpleDamageParser		--Огненный взрыв
-- Mage.spells[2948]	= SimpleDamageParser 		--Ожог
-- Mage.spells[5143]	= ArcaneMissiles 			--Чародейские стрелы
-- Mage.spells[11366]	= DoubleDamageParser		--Огненная глыба
-- Mage.spells[11426]	= SimpleAbsorbParser 		--Ледяная преграда
-- Mage.spells[12051]	= Evocation 				--Прилив сил
-- Mage.spells[30451]	= SimpleDamageParser		--Чародейская вспышка
-- Mage.spells[30455]	= IceLance 					--Ледяное копье
-- Mage.spells[31661]	= SimpleDamageParser 		--Дыхание дракона
-- Mage.spells[44425]	= SimpleDamageParser		--Чародейский обстрел
-- Mage.spells[44457]	= LivingBomb 				--Живая бомба
-- Mage.spells[44614]	= SimpleDamageParser		--Стрела ледяного огня
-- Mage.spells[45438]	= IceBlock 					--Ледяная глыба
-- Mage.spells[84714]	= SimpleTimeDamageParser 	--Ледяной шар
-- Mage.spells[108853]	= InfernoBlast 				--Пламенный взрыв
-- Mage.spells[114923]	= SimpleTimeDamageParser 	--Буря Пустоты
-- Mage.spells[153561]	= SimpleDamageParser2		--Метеор
-- Mage.spells[153595]	= CometStorm				--Буря комет
-- Mage.spells[153626]	= SimpleDamageParser2		--Чародейский шар
-- Mage.spells[157980]	= Supernova 				--Сверхновая
-- Mage.spells[157981]	= BlastWave 				--Взрывная волна
-- Mage.spells[157997]	= IceNova 					--Кольцо обледенения

-- -------------------------------------------------------------------------------

-- --Возгорание:
-- local Combustion = CustomParser:create(function(data, description)
-- 	data.type = SpellEmpty

-- 	if StatusTextFrameLabel then
-- 		local text = StatusTextFrameLabel:GetText()
-- 		if text then
-- 			local match = text:match("Tick : %d+")
-- 			if match then
-- 				data.type = SpellTimeDamage
-- 				data.timeDamage = tonumber(string.sub(match, string.len("Tick : ")))
-- 			end
-- 		end
-- 	end
-- end)

-- function Mage:onLoad()
-- 	if IsAddOnLoaded("CombustionHelper") then
-- 		self.onUpdateSpells[11129] = Combustion 	--Возгорание
-- 	end
-- end

-- -------------------------------------------------------------------------------

-- local locale = GetLocale()

-- if locale ~= "ruRU" then
-- 	--Чародейские стрелы:
-- 	local ArcaneMissiles_notRu = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
-- 		data.timeDamage = match[2] * 5
-- 	end)

-- 	Mage.spells[5143]	= ArcaneMissiles_notRu 						--Чародейские стрелы

-- 	if locale ~= "ptBR" then
-- 		Mage.spells[11426]	= SimpleAbsorbParser2 					--Ледяная преграда
-- 	end
-- end

-- if locale == "enGB" or locale == "enUS" then
-- 	--Живая бомба:
-- 	local LivingBomb_en = MultiParser:create(SpellTimeDamage, {1, 3}, function(data, match)
-- 		data.timeDamage = match[1] + match[3]
-- 	end)

-- 	Mage.spells[44457]	= LivingBomb_en 							--Живая бомба
-- 	return
-- end

-- if locale == "deDE" then
-- 	--Прилив сил:
-- 	local Evocation_de = MultiParser:create(SpellManaAndTimeMana, {1, 3}, function(data, match)
-- 		local maxMana = UnitManaMax("player")
-- 		data.mana = match[1] * maxMana / 100
-- 		data.timeMana = match[3] * maxMana / 100
-- 	end)

-- 	--Живая бомба:
-- 	local LivingBomb_de = MultiParser:create(SpellTimeDamage, {2, 4}, function(data, match)
-- 		data.timeDamage = match[2] + match[4]
-- 	end)

-- 	--Сверхновая:
-- 	local Supernova_de = MultiParser:create(SpellDamage, {2}, function(data, match)
-- 		data.damage = match[2]
-- 		if UnitExists("target") and UnitIsEnemy("player", "target") then
-- 			data.damage = data.damage * 2
-- 		end
-- 	end)

-- 	--Взрывная волна:
-- 	local BlastWave_de = Supernova_de

-- 	--Кольцо обледенения:
-- 	local IceNova_de = Supernova_de

-- 	Mage.spells[10]		= SimpleTimeDamageParser2 								--Снежная буря
-- 	Mage.spells[1449]	= SimpleDamageParser2 									--Чародейский взрыв
-- 	Mage.spells[2120]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3)	--Огненный столб
-- 	Mage.spells[11366]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3)	--Огненная глыба
-- 	Mage.spells[12051]	= Evocation_de 											--Прилив сил
-- 	Mage.spells[44457]	= LivingBomb_de 										--Живая бомба
-- 	Mage.spells[84714]	= SimpleTimeDamageParser2 								--Ледяной шар
-- 	Mage.spells[114923]	= SimpleTimeDamageParser2 								--Буря Пустоты
-- 	Mage.spells[157980]	= Supernova_de 											--Сверхновая
-- 	Mage.spells[157981]	= BlastWave_de 											--Взрывная волна
-- 	Mage.spells[157997]	= IceNova_de 											--Кольцо обледенения
-- 	return
-- end

-- if locale == "esES" then
-- 	--Живая бомба:
-- 	local LivingBomb_es = MultiParser:create(SpellTimeDamage, {1, 3}, function(data, match)
-- 		data.timeDamage = match[1] + match[3]
-- 	end)

-- 	Mage.spells[44457]	= LivingBomb_es 							--Живая бомба
-- 	return
-- end

-- if locale == "frFR" then
-- 	--Живая бомба:
-- 	local LivingBomb_fr = MultiParser:create(SpellTimeDamage, {1, 3}, function(data, match)
-- 		data.timeDamage = match[1] + match[3]
-- 	end)

-- 	Mage.spells[44457]	= LivingBomb_fr 							--Живая бомба
-- 	return
-- end

-- if locale == "itIT" then
-- 	--Живая бомба:
-- 	local LivingBomb_it = MultiParser:create(SpellTimeDamage, {1, 3}, function(data, match)
-- 		data.timeDamage = match[1] + match[3]
-- 	end)

-- 	Mage.spells[44457]	= LivingBomb_it 							--Живая бомба
-- 	return
-- end

-- if locale == "ptBR" then
-- 	--Живая бомба:
-- 	local LivingBomb_pt = MultiParser:create(SpellTimeDamage, {1, 3}, function(data, match)
-- 		data.timeDamage = match[1] + match[3]
-- 	end)

-- 	Mage.spells[44457]	= LivingBomb_pt 							--Живая бомба
-- 	return
-- end

-- if locale == "zhCN" then
-- 	--Прилив сил:
-- 	local Evocation_cn = MultiParser:create(SpellManaAndTimeMana, {1, 3}, function(data, match)
-- 		local maxMana = UnitManaMax("player")
-- 		data.mana = match[1] * maxMana / 100
-- 		data.timeMana = match[3] * maxMana / 100
-- 	end)

-- 	--Ледяное копье:
-- 	local IceLance_cn = MultiParser:create(SpellDamage, {1}, function(data, match)
-- 		data.damage = match[1]

-- 		if UnitExists("target") and UnitBuff("target", L["frost_bomb"]) then
-- 			local description = GetSpellDescription(112948)	--Ледяная бомба
-- 			if description then
-- 				local match = matchDigit(description, 2)
-- 				if match then
-- 					data.damage = data.damage + match
-- 				end
-- 			end
-- 		end
-- 	end)

-- 	--Живая бомба:
-- 	local LivingBomb_cn = MultiParser:create(SpellTimeDamage, {2, 4}, function(data, match)
-- 		data.timeDamage = match[2] + match[4]
-- 	end)

-- 	--Сверхновая:
-- 	local Supernova_cn = MultiParser:create(SpellDamage, {2}, function(data, match)
-- 		data.damage = match[2]
-- 		if UnitExists("target") and UnitIsEnemy("player", "target") then
-- 			data.damage = data.damage * 2
-- 		end
-- 	end)

-- 	--Взрывная волна:
-- 	local BlastWave_cn = Supernova_cn

-- 	--Кольцо обледенения:
-- 	local IceNova_cn = Supernova_cn

-- 	Mage.spells[10]		= SimpleTimeDamageParser2 								--Снежная буря
-- 	Mage.spells[1449]	= SimpleDamageParser2 									--Чародейский взрыв
-- 	Mage.spells[2120]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3)	--Огненный столб
-- 	Mage.spells[11366]	= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3)	--Огненная глыба
-- 	Mage.spells[12051]	= Evocation_cn 											--Прилив сил
-- 	Mage.spells[30455]	= IceLance_cn 											--Ледяное копье
-- 	Mage.spells[44457]	= LivingBomb_cn 										--Живая бомба
-- 	Mage.spells[114923]	= SimpleTimeDamageParser2 								--Буря Пустоты
-- 	Mage.spells[157980]	= Supernova_cn 											--Сверхновая
-- 	Mage.spells[157981]	= BlastWave_cn 											--Взрывная волна
-- 	Mage.spells[157997]	= IceNova_cn 											--Кольцо обледенения
-- 	return
-- end
