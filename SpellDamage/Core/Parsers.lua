local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems

--

SD.SpellParser = {}
function SD.SpellParser:create()
	self.__index = self
	return setmetatable({}, self)
end

function SD.SpellParser:getData(description)
	return SpellData:create(SpellUnknown)
end

SD.SimpleParser = SD.SpellParser:create()
function SD.SimpleParser:create(type, index)
	local parser = {}
	parser.type = type
	parser.index = index
	self.__index = self
	return setmetatable(parser, self)
end

function SD.SimpleParser:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	local match = matchDigit(description, self.index)

	if match ~= nil then
		data.type = self.type
		if self.type == SpellDamage then data.damage = match 
		elseif self.type == SpellTimeDamage then data.timeDamage = match 
		elseif self.type == SpellHeal then data.heal = match 
		elseif self.type == SpellTimeHeal then data.timeHeal = match 
		elseif self.type == SpellMana then data.mana = match
		elseif self.type == SpellTimeMana then data.timeMana = match
		elseif self.type == SpellAbsorb then data.absorb = match
		end
	end
	return data
end

SD.SimpleDamageParser, SD.SimpleTimeDamageParser = SD.SimpleParser:create(SpellDamage, 1), SD.SimpleParser:create(SpellTimeDamage, 1)
SD.SimpleHealParser, SD.SimpleTimeHealParser = SD.SimpleParser:create(SpellHeal, 1), SD.SimpleParser:create(SpellTimeHeal, 1)
SD.SimpleManaParser, SD.SimpleTimeManaParser = SD.SimpleParser:create(SpellMana, 1), SD.SimpleParser:create(SpellTimeMana, 1)
SD.SimpleAbsorbParser = SD.SimpleParser:create(SpellAbsorb, 1)

SD.SimpleDamageParser2 = SD.SimpleParser:create(SpellDamage, 2)
SD.SimpleTimeDamageParser2 = SD.SimpleParser:create(SpellTimeDamage, 2)
SD.SimpleHealParser2 = SD.SimpleParser:create(SpellHeal, 2)
SD.SimpleTimeHealParser2 = SD.SimpleParser:create(SpellTimeHeal, 2)
SD.SimpleManaParser2 = SD.SimpleParser:create(SpellMana, 2)
SD.SimpleAbsorbParser2 = SD.SimpleParser:create(SpellAbsorb, 2)

--

SD.DoubleParser = SD.SpellParser:create()
function SD.DoubleParser:create(type, directIndex, timeIndex)
	local parser = {}
	parser.type = type
	parser.directIndex = directIndex
	parser.timeIndex = timeIndex
	self.__index = self
	return setmetatable(parser, self)
end

function SD.DoubleParser:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	local match = matchDigits(description, {self.directIndex, self.timeIndex})
	if match ~= nil then
		data.type = self.type
		if self.type == SpellDamageAndTimeDamage then 
			data.damage = match[self.directIndex]
			data.timeDamage = match[self.timeIndex]
		elseif self.type == SpellHealAndTimeHeal then
			data.heal = match[self.directIndex]
			data.timeHeal = match[self.timeIndex]
		elseif self.type == SpellDamageAndHeal then
			data.damage = match[self.directIndex]
			data.heal = match[self.timeIndex]
		elseif self.type == SpellDamageAndTimeHeal then
			data.damage = match[self.directIndex]
			data.timeHeal = match[self.timeIndex]
		elseif self.type == SpellHealAndMana then
			data.heal = match[self.directIndex]
			data.mana = match[self.timeIndex]
		else
			data.type = SpellUnknown
		end
	end
	return data
end

SD.DoubleDamageParser = SD.DoubleParser:create(SpellDamageAndTimeDamage, 1, 2)
SD.DoubleHealManaParser = SD.DoubleParser:create(SpellHealAndMana, 1, 2)

--

SD.MultiParser = SD.SpellParser:create()
function SD.MultiParser:create(type, indexTable, func)
	local parser = {}
	parser.type = type
	parser.indexTable = indexTable
	parser.computeFunc = func
	self.__index = self
	return setmetatable(parser, self)
end

function SD.MultiParser:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	local match = matchDigits(description, self.indexTable)
	if match ~= nil then
		data.type = self.type
		self.computeFunc(data, match)
	end
	return data
end

--

SD.AverageParser = SD.SpellParser:create()
function SD.AverageParser:create(firstIndex, secondIndex)
	local parser = {}
	parser.firstIndex = firstIndex
	parser.secondIndex = secondIndex
	self.__index = self
	return setmetatable(parser, self)
end

function SD.AverageParser:getData(description)
	local data = SD.SpellData:create(SpellUnknown)
	local match = matchDigits(description, {self.firstIndex, self.secondIndex})
	if match ~= nil then
		data.type = SpellDamage
		data.damage = (match[self.firstIndex] + match[self.secondIndex]) / 2
	end
	return data
end

SD.SimpleAverageParser = SD.AverageParser:create(1, 2)

--

SD.CustomParser = SD.SpellParser:create()
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

----

SD.SimpleSpell = {}
function SD.SimpleSpell:create(type, indexes, computeFunc)
	local spell = {}
	spell.type = type
	spell.indexes = indexes
	self.computeFunc = computeFunc
	self.__index = self
	return setmetatable(spell, self)
end

function SD.SimpleSpell.getLocaleIndex(indexes)
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

function SD.SimpleSpell:getData(description)
	local match = matchDigit(description, SD.SimpleSpell.getLocaleIndex(self.indexes))
	if match then
		local data = SD.SpellData:create(SpellUnknown)
		data.type = self.type
		if self.type == SpellDamage then data.damage = match 
		elseif self.type == SpellTimeDamage then data.timeDamage = match 
		elseif self.type == SpellHeal then data.heal = match 
		elseif self.type == SpellTimeHeal then data.timeHeal = match 
		elseif self.type == SpellMana then data.mana = match
		elseif self.type == SpellTimeMana then data.timeMana = match
		elseif self.type == SpellAbsorb then data.absorb = match
		else data.type = SpellUnknown
		end
		if self.computeFunc then self.computeFunc(data, match, description); end
		return data
	end
	return nil
end

function SD.Damage(indexes, computeFunc) return SD.SimpleSpell:create(SpellDamage, indexes, computeFunc); end
function SD.TimeDamage(indexes, computeFunc) return SD.SimpleSpell:create(SpellTimeDamage, indexes, computeFunc); end
function SD.Heal(indexes, computeFunc) return SD.SimpleSpell:create(SpellHeal, indexes, computeFunc); end
function SD.TimeHeal(indexes, computeFunc) return SD.SimpleSpell:create(SpellTimeHeal, indexes, computeFunc); end
function SD.Mana(indexes, computeFunc) return SD.SimpleSpell:create(SpellMana, indexes, computeFunc); end
function SD.TimeMana(indexes, computeFunc) return SD.SimpleSpell:create(SpellTimeMana, indexes, computeFunc); end
function SD.Absorb(indexes, computeFunc) return SD.SimpleSpell:create(SpellAbsorb, indexes, computeFunc); end
function SD.CriticalDamage(indexes) return SD.SimpleSpell:create(SpellDamage, indexes, function(data) data.damage = data.damage * 2; end); end

--

SD.DoubleSpell = {}
function SD.DoubleSpell:create(type, indexes, computeFunc)
	local spell = {}
	spell.type = type
	spell.indexes = indexes
	self.computeFunc = computeFunc
	self.__index = self
	return setmetatable(spell, self)
end

function SD.DoubleSpell:getData(description)
	local matchs = matchDigits(description, SD.SimpleSpell.getLocaleIndex(self.indexes))
	if matchs then
		local data = SD.SpellData:create(SpellUnknown)
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
		else
			data.type = SpellUnknown
		end
		if self.computeFunc then self.computeFunc(data, matchs, description); end
		return data
	end
	return nil
end

function SD.DamageAndTimeDamage(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndTimeHeal, indexes, computeFunc); end
function SD.HealAndTimeHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellHealAndTimeHeal, indexes, computeFunc); end
function SD.DamageAndHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndHeal, indexes, computeFunc); end
function SD.DamageAndTimeHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndTimeHeal, indexes, computeFunc); end
function SD.HealAndMana(indexes, computeFunc) return SD.DoubleSpell:create(SpellHealAndMana, indexes, computeFunc); end
function SD.DamageAndDamage(indexes) return SD.DoubleSpell:create(SpellDamage, indexes, function(data, matchs) data.damage = matchs[1] + matchs[2]; end); end
function SD.DamageAndMana(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndMana, indexes, computeFunc); end
function SD.TimeDamageAndTimeHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellTimeDamageAndTimeHeal, indexes, computeFunc); end

--

