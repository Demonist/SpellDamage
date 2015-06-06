--Unilites:

function shortNumber(number)
	if number == nil then
		return ""
	end

	if number >= 1000000 then
		local intValue = math.floor(number / 1000000 + 0.5)
		if intValue >= 10 then
			return string.format("%d m", intValue)
		else
			return string.format("%.1f m", number / 1000000)
		end
	elseif number >= 1000 then
		local intValue = math.floor(number / 1000 + 0.5)
		if intValue >= 10 then
			return string.format("%d k", intValue)
		else 
			return string.format("%.1f k", number / 1000)
		end
	end
	return string.format("%d", number)
end

function matchDigit(str, index)
	local i = 1
	for match in str:gmatch("%d+[%.,]?%d*") do
		if i == index then
			local m = match:gsub(",", ".")
			return tonumber(m)
		end
		i = i + 1
	end
	return nil
end

function matchDigits(str, indexTable)
	local ret = {}
	local keys = {}
	for _, key in pairs(indexTable) do keys[key] = true end
	local i, matched = 1, 0
	for match in str:gmatch("%d+[%.,]?%d*") do
		if keys[i] ~= nil then
			local m = match:gsub(",", ".")
			ret[i] = tonumber(m)
			matched = matched + 1
		end
		i = i + 1
	end
	if matched == #indexTable then return ret end
	return nil
end

function printTable(table)
	for key, value in pairs(table) do
		DEFAULT_CHAT_FRAME:AddMessage(key .. " -> " .. value)
	end
end

SPELL_COMBO_POINTS = 4
function comboMatch(list)
	local combo = UnitPower("player", SPELL_COMBO_POINTS)
	if combo >= 5 then return list[5] end
	for i, index in pairs(list) do
		if i == combo then return index end
	end
	return nil
end
function comboHelper(type, field, indexTable)
	return MultiParser:create(type, indexTable, function(data, match)
		local index = comboMatch(indexTable)
		if index ~= nil then data[field] = match[index] end
	end)
end

--Data:

SpellUnknown, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = 0, 1, 2, 3, 4, 5, 6, 7
SpellDamageAndTimeDamage, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana = 10, 11, 12, 13, 14, 15
SpellData = {}
function SpellData:create(type)
	local data = {}
	data.damage = nil
	data.heal = nil
	data.mana = nil
	data.timeDamage = nil
	data.timeHeal = nil
	data.timeMana = nil
	data.absorb = nil
	data.type = type

	self.__index = self
	return setmetatable(data, self)
end

--Parsers:

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

--Class:

Class = {}
function Class:create()
	local class = {}
	class.spells = {}
	self.__index = self
	self.dependFromPower = false
	class.dependPowerTypes = {}
	return setmetatable(class, self)
end

function Class:updateButton(button, spellId)
	button.centerText:SetText("")
	button.bottomText:SetText("")

	if self.spells[spellId] == nil then return end

	local data = self.spells[spellId]:getData(GetSpellDescription(spellId))
	if data.type == SpellDamage then
		button.centerText:SetText( shortNumber(data.damage) )
		button.centerText:SetTextColor(1, 1, 0, 1)
	elseif data.type == SpellTimeDamage then
		button.centerText:SetText("(".. shortNumber(data.timeDamage) ..")")
		button.centerText:SetTextColor(1, 1, 0, 1)
	elseif data.type == SpellHeal then
		button.bottomText:SetText( shortNumber(data.heal) )
		button.bottomText:SetTextColor(0, 1, 0, 1)
	elseif data.type == SpellTimeHeal then
		button.bottomText:SetText("(".. shortNumber(data.timeHeal) ..")")
		button.bottomText:SetTextColor(0, 1, 0, 1)
	elseif data.type == SpellMana then
		button.bottomText:SetText( shortNumber(data.mana) )
		button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
	elseif data.type == SpellTimeMana then
		button.bottomText:SetText("(".. shortNumber(data.timeMana) ..")")
		button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
	elseif data.type == SpellAbsorb then
		button.bottomText:SetText( shortNumber(data.absorb) )
		button.bottomText:SetTextColor(1, 0.5, 1, 1)
	elseif data.type == SpellDamageAndTimeDamage then
		button.centerText:SetText( shortNumber(data.damage) )
		button.centerText:SetTextColor(1, 1, 0, 1)
		button.bottomText:SetText("(".. shortNumber(data.timeDamage) ..")")
		button.bottomText:SetTextColor(1, 1, 0, 1)
	elseif data.type == SpellHealAndTimeHeal then
		button.centerText:SetText( shortNumber(data.heal) )
		button.centerText:SetTextColor(0, 1, 0, 1)
		button.bottomText:SetText("(".. shortNumber(data.timeHeal) ..")")
		button.bottomText:SetTextColor(0, 1, 0, 1)
	elseif data.type == SpellDamageAndHeal then
		button.centerText:SetText( shortNumber(data.damage) )
		button.centerText:SetTextColor(1, 1, 0, 1)
		button.bottomText:SetText("(".. shortNumber(data.heal) ..")")
		button.bottomText:SetTextColor(0, 1, 0, 1)
	elseif data.type == SpellTimeDamageAndTimeHeal then
		button.centerText:SetText("(".. shortNumber(data.timeDamage) ..")")
		button.centerText:SetTextColor(1, 1, 0, 1)
		button.bottomText:SetText("(".. shortNumber(data.timeHeal) ..")")
		button.bottomText:SetTextColor(0, 1, 0, 1)
	elseif data.type == SpellDamageAndTimeHeal then
		button.centerText:SetText( shortNumber(data.damage) )
		button.centerText:SetTextColor(1, 1, 0, 1)
		button.bottomText:SetText("(".. shortNumber(data.timeHeal) ..")")
		button.bottomText:SetTextColor(0, 1, 0, 1)
	elseif data.type == SpellManaAndTimeMana then
		button.centerText:SetText( shortNumber(data.mana) )
		button.centerText:SetTextColor(0.5, 0.5, 1, 1)
		button.bottomText:SetText("(".. shortNumber(data.timeMana) ..")")
		button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
	end
end