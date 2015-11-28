local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
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

function SD.SimpleSpell:create(type, indexes, computeFunc)
	local spell = {}
	spell.type = type
	spell.indexes = SD.SimpleSpell.getLocaleIndex(indexes)
	spell.computeFunc = computeFunc
	self.__index = self
	return setmetatable(spell, self)
end

function SD.SimpleSpell:getData(description)
	local match = matchDigit(description, self.indexes)
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
	spell.indexes = SD.SimpleSpell.getLocaleIndex(indexes)
	spell.computeFunc = computeFunc
	self.__index = self
	return setmetatable(spell, self)
end

function SD.DoubleSpell:getData(description)
	local matchs = matchDigits(description, self.indexes)
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
function SD.DamageAndDamage(indexes) return SD.DoubleSpell:create(SpellDamage, indexes, function(data, matchs) data.type = SpellDamage; data.damage = matchs[1] + matchs[2]; end); end
function SD.DamageAndMana(indexes, computeFunc) return SD.DoubleSpell:create(SpellDamageAndMana, indexes, computeFunc); end
function SD.TimeDamageAndTimeHeal(indexes, computeFunc) return SD.DoubleSpell:create(SpellTimeDamageAndTimeHeal, indexes, computeFunc); end

--

SD.Combo = {}
function SD.Combo:create(type, startsAndSteps, computeFunc)
	local combo = {}
	combo.type = type
	combo.indexes = {}
	combo.computeFunc = computeFunc

	local startAndStep = SD.SimpleSpell.getLocaleIndex(startsAndSteps)
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
	local matchs = matchDigits(description, self.indexes)
	if matchs then
		local value = matchs[SD.Combo.getComboPoints()]

		local data = SD.SpellData:create(SpellUnknown)
		data.type = self.type
		if self.type == SpellDamage then data.damage = value;
		elseif self.type == SpellTimeDamage then data.timeDamage = value;
		else data.type = SpellUnknown
		end
		if self.computeFunc then self.computeFunc(data, value, computeFunc); end
		return data
	end
	return nil
end

function SD.ComboDamage(startsAndSteps, computeFunc) return SD.Combo:create(SpellDamage, startsAndSteps, computeFunc); end
function SD.ComboTimeDamage(startsAndSteps, computeFunc) return SD.Combo:create(SpellTimeDamage, startsAndSteps, computeFunc); end
