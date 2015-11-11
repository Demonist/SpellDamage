local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
local Glyphs = SD.Glyphs

--

--Тотем исцеляющего потока:
local HealingStreamTotem = MultiParser:create(SpellTimeHeal, {3}, function(data, match)
	data.timeHeal = match[3] * 7
end)

--Земной шок:
local EarthShock = MultiParser:create(SpellDamage, {1}, function(data, match)
	data.damage = match[1]

	local name, _, _, count = UnitBuff("player", L["lightning_shield"])
	if IsSpellKnown(88766) == true and name and count > 1 then	--Сверкание
		local damage = matchDigit(GetSpellDescription(324), 1)	--Щит молний
		if damage then
			data.damage = match[1] + (damage * (count - 1))
		end
	end
end)

--Тотем магмы:
local MagmaTotem = MultiParser:create(SpellTimeDamage, {4}, function(data, match)
	data.timeDamage = match[4] * 30
end)

--Удар бури:
local Stormstrike = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1] + match[2]
end)

--Водный щит:
local WaterShield = MultiParser:create(SpellTimeMana, {1}, function(data, match)
	data.timeMana = match[1]
end)

--Тотем целительного прилива:
local HealingTideTotem = MultiParser:create(SpellTimeHeal, {5}, function(data, match)
	data.timeHeal = match[5] * 5
end)

local Shaman = Class:create(ClassSpells)
SD.Shaman = Shaman
Shaman.spells[324]		= SimpleTimeDamageParser 							--Щит молний
Shaman.spells[403]		= SimpleDamageParser 								--Молния
Shaman.spells[421]		= SimpleDamageParser 								--Цепная молния
Shaman.spells[974]		= SimpleTimeHealParser2 							--Щит земли
Shaman.spells[1064]		= SimpleHealParser  								--Цепное исцеление
Shaman.spells[1535]		= SimpleDamageParser2 								--Кольцо огня
Shaman.spells[3599]		= SimpleParser:create(SpellTimeDamage, 4) 			--Опаляющий тотем
Shaman.spells[5394]		= HealingStreamTotem 								--Тотем исцеляющего потока
Shaman.spells[8004]		= SimpleHealParser 									--Исцеляющий всплеск
Shaman.spells[8042]		= EarthShock 										--Земной шок
Shaman.spells[8050]		= DoubleDamageParser 								--Огненный шок
Shaman.spells[8056]		= SimpleDamageParser 								--Ледяной шок
Shaman.spells[8190]		= MagmaTotem 										--Тотем магмы
Shaman.spells[17364]	= Stormstrike 			 							--Удар бури
Shaman.spells[51490]	= SimpleDamageParser 								--Гром и молния
Shaman.spells[51505]	= SimpleDamageParser 								--Выброс лавы
Shaman.spells[52127]	= WaterShield 										--Водный щит
Shaman.spells[60103]	= SimpleDamageParser 								--Вскипание лавы
Shaman.spells[61295]	= DoubleParser:create(SpellHealAndTimeHeal, 1, 2) 	--Быстрина
Shaman.spells[61882]	= SimpleTimeDamageParser2 	 						--Землетрясение
Shaman.spells[73899]	= SimpleDamageParser 								--Стихийный удар
Shaman.spells[73920]	= SimpleTimeHealParser 								--Целительный ливень
Shaman.spells[77472]	= SimpleHealParser 									--Волна исцеления
Shaman.spells[18270]	= SimpleParser:create(SpellAbsorb, 3) 				--Тотем каменной преграды
Shaman.spells[108280]	= HealingTideTotem 									--Тотем целительного прилива
Shaman.spells[117014]	= SimpleDamageParser 	 							--Удар духов стихии

-------------------------------------------------------------------------------

local locale = GetLocale()

if locale == "enGB" or locale == "enUS" then
	--Тотем магмы:
	local MagmaTotem_en = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
		data.timeDamage = match[3] * 30
	end)

	Shaman.spells[8190]		= MagmaTotem_en 								--Тотем магмы
	Shaman.spells[61882]	= SimpleTimeDamageParser 						--Землетрясение
	return
end

if locale == "deDE" then
	--Тотем исцеляющего потока:
	local HealingStreamTotem_de = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
		data.timeHeal = match[4] * 7
	end)

	--Тотем магмы:
	local MagmaTotem_de = MultiParser:create(SpellTimeDamage, {5}, function(data, match)
		data.timeDamage = match[5] * 30
	end)

	--Водный щит:
	local WaterShield_de = MultiParser:create(SpellTimeMana, {2}, function(data, match)
		data.timeMana = match[2]
	end)

	Shaman.spells[1535]		= SimpleParser:create(SpellDamage, 3) 					--Кольцо огня
	Shaman.spells[5394]		= HealingStreamTotem_de 								--Тотем исцеляющего потока
	Shaman.spells[8050]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Огненный шок
	Shaman.spells[8190]		= MagmaTotem_de 										--Тотем магмы
	Shaman.spells[51490]	= SimpleDamageParser2 									--Гром и молния
	Shaman.spells[52127]	= WaterShield_de 										--Водный щит
	Shaman.spells[61295]	= DoubleParser:create(SpellHealAndTimeHeal, 1, 3) 		--Быстрина
	Shaman.spells[61882]	= SimpleParser:create(SpellTimeDamage, 3) 				--Землетрясение
	Shaman.spells[73920]	= SimpleParser:create(SpellTimeHeal, 3) 				--Целительный ливень
	return
end

if locale == "esES" then
	--Тотем исцеляющего потока:
	local HealingStreamTotem_es = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
		data.timeHeal = match[2] * 7
	end)

	--Тотем магмы:
	local MagmaTotem_es = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
		data.timeDamage = match[3] * 30
	end)

	--Тотем целительного прилива:
	local HealingTideTotem_es = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
		data.timeHeal = match[4] * 5
	end)

	Shaman.spells[5394]		= HealingStreamTotem_es 						--Тотем исцеляющего потока
	Shaman.spells[8190]		= MagmaTotem_es 								--Тотем магмы
	Shaman.spells[61882]	= SimpleTimeDamageParser 						--Землетрясение
	Shaman.spells[108280]	= HealingTideTotem_es 							--Тотем целительного прилива
	return
end

if locale == "frFR" then
	--Тотем магмы:
	local MagmaTotem_fr = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
		data.timeDamage = match[3] * 30
	end)

	--Тотем целительного прилива:
	local HealingTideTotem_fr = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
		data.timeHeal = match[4] * 5
	end)

	Shaman.spells[8190]		= MagmaTotem_fr 								--Тотем магмы
	Shaman.spells[61882]	= SimpleTimeDamageParser 						--Землетрясение
	Shaman.spells[108280]	= HealingTideTotem_fr 							--Тотем целительного прилива
	return
end

if locale == "itIT" then
	--Тотем исцеляющего потока:
	local HealingStreamTotem_it = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
		data.timeHeal = match[4] * 7
	end)

	--Тотем магмы:
	local MagmaTotem_it = MultiParser:create(SpellTimeDamage, {3}, function(data, match)
		data.timeDamage = match[3] * 30
	end)

	--Тотем целительного прилива:
	local HealingTideTotem_it = MultiParser:create(SpellTimeHeal, {4}, function(data, match)
		data.timeHeal = match[4] * 5
	end)

	Shaman.spells[5394]		= HealingStreamTotem_it 						--Тотем исцеляющего потока
	Shaman.spells[8190]		= MagmaTotem_it 								--Тотем магмы
	Shaman.spells[61882]	= SimpleTimeDamageParser 						--Землетрясение
	Shaman.spells[108280]	= HealingTideTotem_it 							--Тотем целительного прилива
	return
end

if locale == "ptBR" then
	--Тотем исцеляющего потока:
	local HealingStreamTotem_pt = MultiParser:create(SpellTimeHeal, {2}, function(data, match)
		data.timeHeal = match[2] * 7
	end)

	--Тотем магмы:
	local MagmaTotem_pt = MultiParser:create(SpellTimeDamage, {2}, function(data, match)
		data.timeDamage = match[2] * 30
	end)

	Shaman.spells[5394]		= HealingStreamTotem_pt 						--Тотем исцеляющего потока
	Shaman.spells[8190]		= MagmaTotem_pt 								--Тотем магмы
	Shaman.spells[61882]	= SimpleTimeDamageParser 						--Землетрясение
	return
end

if locale == "zhCN" then
	--Тотем исцеляющего потока:
	local HealingStreamTotem_cn = MultiParser:create(SpellTimeHeal, {6}, function(data, match)
		data.timeHeal = match[6] * 7
	end)

	--Тотем магмы:
	local MagmaTotem_cn = MultiParser:create(SpellTimeDamage, {5}, function(data, match)
		data.timeDamage = match[5] * 30
	end)

	--Водный щит:
	local WaterShield_cn = MultiParser:create(SpellTimeMana, {2}, function(data, match)
		data.timeMana = match[2]
	end)

	Shaman.spells[5394]		= HealingStreamTotem_cn 								--Тотем исцеляющего потока
	Shaman.spells[8050]		= DoubleParser:create(SpellDamageAndTimeDamage, 1, 3) 	--Огненный шок
	Shaman.spells[8190]		= MagmaTotem_cn 										--Тотем магмы
	Shaman.spells[51490]	= SimpleDamageParser2 									--Гром и молния
	Shaman.spells[52127]	= WaterShield_cn 										--Водный щит
	Shaman.spells[61295]	= DoubleParser:create(SpellHealAndTimeHeal, 1, 3) 		--Быстрина
	Shaman.spells[61882]	= SimpleParser:create(SpellTimeDamage, 3) 				--Землетрясение
	Shaman.spells[73920]	= SimpleTimeHealParser2 								--Целительный ливень
	return
end
