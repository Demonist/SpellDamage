local L, shortNumber, matchDigit, matchDigits, printTable, strstarts, Buff, Debuff = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts, SD.Buff, SD.Debuff
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal, SpellAbsorbAndDamage = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal, SD.SpellAbsorbAndDamage
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems

--

SD.CustomParser = {}
function SD.CustomParser:create(func)
	local parser = {}
	parser.parse = func
	self.__index = self
	return setmetatable(parser, self)
end

function SD.CustomParser:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	self.parse(data, description)
	return data
end

function SD.Custom(computeFunc) return SD.CustomParser:create(computeFunc); end

--

SD.SimpleSpell = {}

function SD.SimpleSpell.getLocaleIndex(indexes)
	if type(indexes) ~= "table" then error("Wrong type '"..type(indexes).."' of 'indexes' in 'SD.SimpleSpell.getLocaleIndex' function"); end

	if not SD.SimpleSpell.locale then
		local locale = string.lower(GetLocale())
		SD.SimpleSpell.locale = string.sub(locale, 3, 4)
		if SD.SimpleSpell.locale == "us" or SD.SimpleSpell.locale == "gb" then SD.SimpleSpell.locale = "en" end
	end

	local ret = indexes[SD.SimpleSpell.locale]
	if ret == nil then
		return indexes["ru"]
	else
		return ret
	end
end

function SD.SimpleSpell:create(spellType, indexes, computeFunc)
	if type(indexes) ~= "table" then error("Wrong type '"..type(indexes).."' of 'indexes' in 'SD.SimpleSpell:create' function"); end

	local spell = {}
	spell.type = spellType
	spell.index = SD.SimpleSpell.getLocaleIndex(indexes)
	if type(spell.index) ~= "number" then error("Wrong type '"..type(spell.index).."' of 'spell.index' in 'SD.SimpleSpell:create' function"); end
	spell.computeFunc = computeFunc
	self.__index = self
	return setmetatable(spell, self)
end

function SD.SimpleSpell:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	local match = matchDigit(description, self.index)
	if match then
		data.type = self.type
		if self.type == SpellDamage then data.damage = match; 
		elseif self.type == SpellTimeDamage then data.timeDamage = match; 
		elseif self.type == SpellHeal then data.heal = match; 
		elseif self.type == SpellTimeHeal then data.timeHeal = match; 
		elseif self.type == SpellMana then data.mana = match;
		elseif self.type == SpellTimeMana then data.timeMana = match;
		elseif self.type == SpellAbsorb then data.absorb = match;
		else data.type = SpellUnknown;
		end
		if self.computeFunc then self.computeFunc(data, match, description); end
	end
	return data
end

--caching functions:
function SD.Damage(index, computeFunc)
	if index == {ru=1} and not computeFunc then
		if not SD.DamageCache then SD.DamageCache = SD.SimpleSpell:create(SpellDamage, index, nil); end
		return SD.DamageCache
	end
	return SD.SimpleSpell:create(SpellDamage, index, computeFunc)
end
function SD.Heal(index, computeFunc)
	if index == {ru=1} and not computeFunc then
		if not SD.HealCache then SD.HealCache = SD.SimpleSpell:create(SpellHeal, index, nil); end
		return SD.HealCache
	end
	return SD.SimpleSpell:create(SpellHeal, index, computeFunc)
end
function SD.TimeHeal(index, computeFunc) 
	if index == {ru=1, de=2, cn=2, kr=2} and not computeFunc then
		if not SD.TimeHealCache then SD.TimeHealCache = SD.SimpleSpell:create(SpellTimeHeal, index, nil); end
		return SD.TimeHealCache
	end
	return SD.SimpleSpell:create(SpellTimeHeal, index, computeFunc)
end

function SD.TimeDamage(index, computeFunc) return SD.SimpleSpell:create(SpellTimeDamage, index, computeFunc); end
function SD.Mana(index, computeFunc) return SD.SimpleSpell:create(SpellMana, index, computeFunc); end
function SD.TimeMana(index, computeFunc) return SD.SimpleSpell:create(SpellTimeMana, index, computeFunc); end
function SD.Absorb(index, computeFunc) return SD.SimpleSpell:create(SpellAbsorb, index, computeFunc); end
function SD.CriticalDamage(index) return SD.SimpleSpell:create(SpellDamage, index, function(data) data.damage = data.damage * 2; end); end

--

SD.DoubleSpell = {}
function SD.DoubleSpell:create(spellType, indexes, computeFunc)
	if type(indexes) ~= "table" then error("Wrong type '"..type(indexes).."' of 'indexes' in 'SD.DoubleSpell:create' function"); end

	local spell = {}
	spell.type = spellType
	spell.indexes = SD.SimpleSpell.getLocaleIndex(indexes)
	if type(spell.indexes) ~= "table" then error("Wrong type '"..type(spell.indexes).."' of 'spell.indexes' in 'SD.DoubleSpell:create' function"); end
	spell.computeFunc = computeFunc
	self.__index = self
	return setmetatable(spell, self)
end

function SD.DoubleSpell:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	local matchs = matchDigits(description, self.indexes)
	if matchs then
		data.type = self.type
		if self.type == SpellDamageAndTimeDamage then 
			data.damage = matchs[1]
			data.timeDamage = matchs[2]
		elseif self.type == SpellHealAndTimeHeal then
			data.heal = matchs[1]
			data.timeHeal = matchs[2]
		elseif self.type == SpellDamageAndHeal then
			data.damage = matchs[1]
			data.heal = matchs[2]
		elseif self.type == SpellDamageAndTimeHeal then
			data.damage = matchs[1]
			data.timeHeal = matchs[2]
		elseif self.type == SpellHealAndMana then
			data.heal = matchs[1]
			data.mana = matchs[2]
		elseif self.type == SpellDamageAndMana then
			data.damage = matchs[1]
			data.mana = matchs[2]
		elseif self.type == SpellTimeDamageAndTimeHeal then
			data.timeDamage = matchs[1]
			data.timeHeal = matchs[2]
		elseif self.type == SpellManaAndTimeMana then
			data.mana = matchs[1]
			data.timeMana = matchs[2]
		elseif self.type == SpellAbsorbAndDamage then
			data.absorb = matchs[1]
			data.damage = matchs[2]
		elseif self.type == SpellTimeHealAndTimeMana then
			data.timeHeal = matchs[1]
			data.timeMana = matchs[2]
		else
			data.type = SpellUnknown
		end
		if self.computeFunc then self.computeFunc(data, matchs, description); end
	end
	return data
end

function SD.DamageAndTimeDamage(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndTimeDamage, indexes, computeFunc); end
function SD.TimeDamageAndTimeDamage(indexes) return SD.DoubleSpell:create(SpellTimeDamage, indexes, function(data, matchs) data.type = SpellTimeDamage; data.timeDamage = matchs[1] + matchs[2]; end); end
function SD.HealAndTimeHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellHealAndTimeHeal, indexes, computeFunc); end
function SD.DamageAndHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndHeal, indexes, computeFunc); end
function SD.DamageAndTimeHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndTimeHeal, indexes, computeFunc); end
function SD.HealAndMana(indexes, computeFunc) return SD.DoubleSpell:create(SpellHealAndMana, indexes, computeFunc); end
function SD.TimeHealAndTimeMana(indexes, computeFunc) return SD.DoubleSpell:create(SpellTimeHealAndTimeMana, indexes, computeFunc); end
function SD.DamageAndDamage(indexes) return SD.DoubleSpell:create(SpellDamage, indexes, function(data, matchs) data.type = SpellDamage; data.damage = matchs[1] + matchs[2]; end); end
function SD.DamageAndMana(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndMana, indexes, computeFunc); end
function SD.TimeDamageAndTimeHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellTimeDamageAndTimeHeal, indexes, computeFunc); end
function SD.ManaAndTimeMana(indexes, computeFunc) return SD.DoubleSpell:create(SpellManaAndTimeMana, indexes, computeFunc); end
function SD.AbsorbAndDamage(indexes, computeFunc) return SD.DoubleSpell:create(SpellAbsorbAndDamage, indexes, computeFunc); end
function SD.AverageDamage(indexes) return SD.DoubleSpell:create(SpellDamage, indexes, function(data, matchs) data.type = SpellDamage; data.damage = (matchs[1] + matchs[2]) / 2; end); end

--

SD.Combo = {}
function SD.Combo:create(spellType, startsAndSteps, computeFunc)
	if type(startsAndSteps) ~= "table" then error("Wrong type '"..type(startsAndSteps).."' of 'startsAndSteps' in 'SD.Combo:create' function"); end

	local combo = {}
	combo.type = spellType
	combo.indexes = {}
	combo.computeFunc = computeFunc

	local startAndStep = SD.SimpleSpell.getLocaleIndex(startsAndSteps)
	if #startAndStep ~= 2 then error("Wrong data in 'startAndStep' in 'SD.Combo:create' function"); end
	local start, step = startAndStep[1], startAndStep[2]

	for i = 0,4 do
		table.insert(combo.indexes, start + i*step)
	end

	self.__index = self
	return setmetatable(combo, self)
end

SD.SPELL_COMBO_POINTS = 4
function SD.Combo.getComboPoints()
	local combo = UnitPower("player", SD.SPELL_COMBO_POINTS)
	if combo > 5 then return 5;
	elseif combo == 0 then return 1;
	else return combo; end
end

function SD.Combo:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	local matchs = matchDigits(description, self.indexes)
	if matchs then
		data.type = self.type
		local value = matchs[SD.Combo.getComboPoints()]
		if self.type == SpellDamage then data.damage = value;
		elseif self.type == SpellTimeDamage then data.timeDamage = value;
		elseif self.type == SpellDamageAndTimeDamage then data.timeDamage = value;
		else data.type = SpellUnknown
		end
		if self.computeFunc then self.computeFunc(data, value, computeFunc); end
	end
	return data
end

function SD.ComboDamage(startsAndSteps, computeFunc) return SD.Combo:create(SpellDamage, startsAndSteps, computeFunc); end
function SD.ComboTimeDamage(startsAndSteps, computeFunc) return SD.Combo:create(SpellTimeDamage, startsAndSteps, computeFunc); end
function SD.ComboDamageAndTimeDamage(startsAndSteps, computeFunc) return SD.Combo:create(SpellTimeDamage, startsAndSteps, computeFunc); end
