SpellParser = {}
function SpellParser:create()
	self.__index = self
	return setmetatable({}, self)
end

function SpellParser:getData(description)
	return SpellData:create(SpellUnknown)
end

SimpleParser = SpellParser:create()
function SimpleParser:create(type, index)
	local parser = {}
	parser.type = type
	parser.index = index
	self.__index = self
	return setmetatable(parser, self)
end

function SimpleParser:getData(description)
	local data = SpellData:create(SpellUnknown)
	local value = matchDigit(description, self.index)

	if value ~= nil then
		data.type = self.type
		if self.type == SpellDamage then data.damage = value 
		elseif self.type == SpellTimeDamage then data.timeDamage = value 
		elseif self.type == SpellHeal then data.heal = value 
		elseif self.type == SpellTimeHeal then data.timeHeal = value 
		elseif self.type == SpellMana then data.mana = value
		elseif self.type == SpellTimeMana then data.timeMana = value
		elseif self.type == SpellAbsorb then data.absorb = value
		end
	end
	return data
end

SimpleDamageParser, SimpleTimeDamageParser = SimpleParser:create(SpellDamage, 1), SimpleParser:create(SpellTimeDamage, 1)
SimpleHealParser, SimpleTimeHealParser = SimpleParser:create(SpellHeal, 1), SimpleParser:create(SpellTimeHeal, 1)
SimpleManaParser, SimpleTimeManaParser = SimpleParser:create(SpellMana, 1), SimpleParser:create(SpellTimeMana, 1)
SimpleAbsorbParser = SimpleParser:create(SpellAbsorb, 1)

SimpleDamageParser2 = SimpleParser:create(SpellDamage, 2)
SimpleTimeDamage2 = SimpleParser:create(SpellTimeDamage, 2)
SimpleHealParser2 = SimpleParser:create(SpellHeal, 2)
SimpleTimeHealParser2 = SimpleParser:create(SpellTimeHeal, 2)

--

DoubleParser = SpellParser:create()
function DoubleParser:create(type, directIndex, timeIndex)
	local parser = {}
	parser.type = type
	parser.directIndex = directIndex
	parser.timeIndex = timeIndex
	self.__index = self
	return setmetatable(parser, self)
end

function DoubleParser:getData(description)
	local data = SpellData:create(SpellUnknown)
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
		end
	end
	return data
end

DoubleDamageParser = DoubleParser:create(SpellDamageAndTimeDamage, 1, 2)

--

MultiParser = SpellParser:create()
function MultiParser:create(type, indexTable, func)
	local parser = {}
	parser.type = type
	parser.indexTable = indexTable
	parser.computeFunc = func
	self.__index = self
	return setmetatable(parser, self)
end

function MultiParser:getData(description)
	local data = SpellData:create(SpellUnknown)
	local match = matchDigits(description, self.indexTable)
	if match ~= nil then
		data.type = self.type
		self.computeFunc(data, match)
	end
	return data
end

--

AverageParser = SpellParser:create()
function AverageParser:create(firstIndex, secondIndex)
	local parser = {}
	parser.firstIndex = firstIndex
	parser.secondIndex = secondIndex
	self.__index = self
	return setmetatable(parser, self)
end

function AverageParser:getData(description)
	local data = SpellData:create(SpellUnknown)
	local match = matchDigits(description, {self.firstIndex, self.secondIndex})
	if match ~= nil then
		data.type = SpellDamage
		data.damage = (match[self.firstIndex] + match[self.secondIndex]) / 2
	end
	return data
end

SimpleAverageParser = AverageParser:create(1, 2)

--

CustomParser = SpellParser:create()
function CustomParser:create(func)
	local parser = {}
	parser.parse = func
	self.__index = self
	return setmetatable(parser, self)
end

function CustomParser:getData(description)
	local data = SpellData:create(SpellUnknown)
	self.parse(data, description)
	return data
end