local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
local Glyphs = SD.Glyphs

--

--Возложение рук:
local LayOnHands = MultiParser:create(SpellHeal, {1}, function(data, match)
	data.heal = UnitHealthMax("player")
end)

--Шок небес:
local HolyShock = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1]
	if UnitExists("target") and UnitIsFriend("player", "target") then
		data.type = SpellHeal
		data.heal = match[2]
	end
end)

--Священный щит:
local SacredShield = MultiParser:create(SpellAbsorb, {1, 2, 3}, function(data, match)
	data.absorb = math.floor(match[1] / match[3]) * match[2]
end)

--Божественная буря:
local DivineStorm = CustomParser:create(function(data, description)
	local match = matchDigit(description, 1)
	if match then
		data.type = SpellDamage
		data.damage = match

		if Glyphs:contains(63220) then		--Символ божественной бури
			data.type = SpellDamageAndHeal
			data.heal = UnitHealthMax("player") * 0.04
		end
	end
end)

--Торжество:
local WordOfGlory = CustomParser:create(function(data, description)
	local match = matchDigit(description, 2)
	if match then
		data.type = SpellHeal
		data.heal = match

		if Glyphs:contains(54938) and UnitExists("target") and UnitIsEnemy("player", "target") then		--Символ резких слов
			data.type = SpellDamage
			data.damage = data.heal
		end
	end
end)

--Молот Света:
local LightsHammer = MultiParser:create(SpellTimeDamageAndTimeHeal, {4, 8}, function(data, match)
	data.timeDamage = match[4] * 7
	data.timeHeal = match[8] * 7
end)

--Вечное пламя:
local EternalFlame = MultiParser:create(SpellHealAndTimeHeal, {2, 3}, function(data, match)
	data.heal = match[2]
	data.timeHeal = match[3] * 15
end)

--Божественная призма:
local HolyPrism = MultiParser:create(SpellDamageAndHeal, {1, 2, 5, 6}, function(data, match)
	if UnitExists("target") then
		if UnitIsEnemy("player", "target") then
			data.damage = match[1]
			data.heal = match[2]
		end
		if UnitIsFriend("player", "target") then
			data.heal = match[5]
			data.damage = match[6]
		end
	else
		data.type = SpellEmpty
	end
end)

--Священный щит:
local SacredShield = MultiParser:create(SpellAbsorb, {1, 2, 3}, function(data, match)
	data.absorb = math.floor(match[1] / match[3]) * match[2]
end)

--Гнев карателя:
local AvengingWrath = CustomParser:create(function(data, description)
	if Glyphs:contains(54927) then		--Символ гнева карателя
		data.type = SpellTimeHeal
		data.timeHeal = UnitHealthMax("player") * 0.01 * 5
	else
		data.type = SpellEmpty
	end
end)

local Paladin = Class:create(ClassSpells)
SD.Paladin = Paladin
Paladin.dependFromTarget = true
Paladin.spells[633] 	= LayOnHands 											--Возложение рук
Paladin.spells[879]		= SimpleDamageParser 									--Экзорцизм
Paladin.spells[2812]	= SimpleDamageParser 									--Обличение
Paladin.spells[19750]	= SimpleHealParser 	 									--Вспышка Света
Paladin.spells[20271]	= SimpleDamageParser 									--Правосудие
Paladin.spells[20473]	= HolyShock												--Шок небес
Paladin.spells[20925]	= SacredShield											--Священный щит
Paladin.spells[24275]	= SimpleDamageParser 	 								--Молот гнева
Paladin.spells[26573]	= SimpleTimeDamageParser 								--Освящение
Paladin.spells[31935]	= SimpleDamageParser 									--Щит мстителя
Paladin.spells[35395]	= SimpleDamageParser 									--Удар воина Света
Paladin.spells[53385]	= DivineStorm 											--Божественная буря
Paladin.spells[53595]	= SimpleDamageParser 									--Молот праведника
Paladin.spells[53600]	= SimpleDamageParser 									--Щит праведника
Paladin.spells[82326]	= SimpleHealParser 										--Свет небес
Paladin.spells[82327]	= SimpleHealParser 										--Святое сияние
Paladin.spells[85222]	= SimpleParser:create(SpellHeal, 4) 					--Свет зари
Paladin.spells[85256]	= SimpleDamageParser 									--Вердикт храмовника
Paladin.spells[85673]	= WordOfGlory 											--Торжество
Paladin.spells[136494]	= WordOfGlory 											--Торжество
Paladin.spells[114157]	= DoubleParser:create(SpellTimeDamageAndTimeHeal, 1, 3) --Смертный приговор
Paladin.spells[114158]	= LightsHammer 											--Молот Света
Paladin.spells[114163]	= EternalFlame 											--Вечное пламя
Paladin.spells[114165]	= HolyPrism 											--Божественная призма
Paladin.spells[119072]	= SimpleDamageParser 									--Гнев небес
Paladin.spells[130552]	= SimpleHealParser2 									--Резкое слово
Paladin.spells[148039]	= SacredShield 											--Священный щит
Paladin.spells[157048]	= SimpleDamageParser 									--Окончательный приговор

Paladin.spells[31884]	= AvengingWrath 										--Гнев карателя

-------------------------------------------------------------------------------

local locale = GetLocale()

if locale == "enGB" or locale == "enUS" then

	return
end

if locale == "deDE" then
	--Божественная буря:
	local DivineStorm_de = CustomParser:create(function(data, description)
		local match = matchDigit(description, 2)
		if match then
			data.type = SpellDamage
			data.damage = match

			if Glyphs:contains(63220) then		--Символ божественной бури
				data.type = SpellDamageAndHeal
				data.heal = UnitHealthMax("player") * 0.04
			end
		end
	end)

	--Вечное пламя:
	local EternalFlame_de = MultiParser:create(SpellHealAndTimeHeal, {2, 5}, function(data, match)
		data.heal = match[2]
		data.timeHeal = match[5] * 15
	end)

	--Священный щит:
	local SacredShield_de = MultiParser:create(SpellAbsorb, {1, 2, 3}, function(data, match)
		data.absorb = math.floor(match[1] / match[2]) * match[3]
	end)

	Paladin.spells[26573]	= SimpleTimeDamageParser2 								--Освящение
	Paladin.spells[53385]	= DivineStorm_de 										--Божественная буря
	Paladin.spells[114157]	= DoubleParser:create(SpellTimeDamageAndTimeHeal, 2, 4) --Смертный приговор
	Paladin.spells[114163]	= EternalFlame_de 										--Вечное пламя
	Paladin.spells[119072]	= SimpleDamageParser2 									--Гнев небес
	Paladin.spells[148039]	= SacredShield_de 										--Священный щит
	return
end

if locale == "esES" then
	Paladin.spells[85222]	= SimpleParser:create(SpellHeal, 2) 				--Свет зари
	return
end

if locale == "frFR" then
	--Молот Света:
	local LightsHammer_fr = MultiParser:create(SpellTimeDamageAndTimeHeal, {4, 7}, function(data, match)
		data.timeDamage = match[4] * 7
		data.timeHeal = match[7] * 7
	end)

	Paladin.spells[85222]	= SimpleParser:create(SpellHeal, 2) 				--Свет зари
	Paladin.spells[114158]	= LightsHammer_fr 									--Молот Света
	return
end

if locale == "itIT" then
	Paladin.spells[85222]	= SimpleParser:create(SpellHeal, 2) 				--Свет зари
	return
end

if locale == "ptBR" then
	Paladin.spells[85222]	= SimpleParser:create(SpellHeal, 2) 				--Свет зари
	return
end

if locale == "zhCN" then
	--Божественная буря:
	local DivineStorm_cn = CustomParser:create(function(data, description)
		local match = matchDigit(description, 2)
		if match then
			data.type = SpellDamage
			data.damage = match

			if Glyphs:contains(63220) then		--Символ божественной бури
				data.type = SpellDamageAndHeal
				data.heal = UnitHealthMax("player") * 0.04
			end
		end
	end)

	--Божественная призма:
	local HolyPrism_cn = MultiParser:create(SpellDamageAndHeal, {1, 4, 5, 8}, function(data, match)
		if UnitExists("target") then
			if UnitIsEnemy("player", "target") then
				data.damage = match[1]
				data.heal = match[4]
			end
			if UnitIsFriend("player", "target") then
				data.heal = match[5]
				data.damage = match[8]
			end
		else
			data.type = SpellEmpty
		end
	end)

	--Вечное пламя:
	local EternalFlame_cn = MultiParser:create(SpellHealAndTimeHeal, {2, 4}, function(data, match)
		data.heal = match[2]
		data.timeHeal = match[4] * 15
	end)

	--Священный щит:
	local SacredShield_cn = MultiParser:create(SpellAbsorb, {1, 2, 3}, function(data, match)
		data.absorb = math.floor(match[1] / match[2]) * match[3]
	end)

	Paladin.spells[53385]	= DivineStorm_cn 											--Божественная буря
	Paladin.spells[114157]	= DoubleParser:create(SpellTimeDamageAndTimeHeal, 2, 4) 	--Смертный приговор
	Paladin.spells[114163]	= EternalFlame_cn 											--Вечное пламя
	Paladin.spells[114165]	= HolyPrism_cn 												--Божественная призма
	Paladin.spells[148039]	= SacredShield_cn 											--Священный щит
	return
end
