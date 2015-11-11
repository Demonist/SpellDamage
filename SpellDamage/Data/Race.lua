local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local SpellParser, SimpleParser, SimpleDamageParser, SimpleTimeDamageParser, SimpleHealParser, SimpleTimeHealParser, SimpleManaParser, SimpleTimeManaParser, SimpleAbsorbParser, SimpleDamageParser2, SimpleTimeDamageParser2, SimpleHealParser2, SimpleTimeHealParser2, SimpleManaParser2, SimpleAbsorbParser2, DoubleParser, DoubleDamageParser, DoubleHealManaParser, MultiParser, AverageParser, SimpleAverageParser, CustomParser = SD.SpellParser, SD.SimpleParser, SD.SimpleDamageParser, SD.SimpleTimeDamageParser, SD.SimpleHealParser, SD.SimpleTimeHealParser, SD.SimpleManaParser, SD.SimpleTimeManaParser, SD.SimpleAbsorbParser, SD.SimpleDamageParser2, SD.SimpleTimeDamageParser2, SD.SimpleHealParser2, SD.SimpleTimeHealParser2, SD.SimpleManaParser2, SD.SimpleAbsorbParser2, SD.DoubleParser, SD.DoubleDamageParser, SD.DoubleHealManaParser, SD.MultiParser, SD.AverageParser, SD.SimpleAverageParser, SD.CustomParser
local Glyphs = SD.Glyphs

--

if GetLocale() ~= "ruRU" then return end

--Эльф крови, Волшебный поток:
local ArcaneTorrent = MultiParser:create(SpellMana, {3}, function(data, match)
	data.mana = match[3] * UnitManaMax("player") / 100
end)

--Дреней, Дар наару:
local GiftOfTheNaaru = MultiParser:create(SpellTimeHeal, {1}, function(data, match)
	data.timeHeal = match[1] * UnitHealthMax("player") / 100
end)

--Нежить, Каннибализм:
local Cannibalize = MultiParser:create(SpellTimeHealAndTimeMana, {1, 2, 3}, function(data, match)
	local times = match[3] / match[2]
	data.timeHeal = match[1] * UnitHealthMax("player") / 100 * times
	data.timeMana = match[1] * UnitManaMax("player") / 100 * times
end)

local Race = Class:create(ClassSpells)
SD.Race = Race
Race.spells[28730]	= ArcaneTorrent 						--Эльф крови, Волшебный поток
Race.spells[121093]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[28880]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59544]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59548]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59543]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59542]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59545]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59547]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[20577]	= Cannibalize 							--Нежить, Каннибализм
Race.spells[69041]	= SimpleParser:create(SpellDamage, 1) 	--Гоблин, Ракетный обстрел
