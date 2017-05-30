function SD.shortNumber(number)
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

local d1, d2
local function removeDelimiters(str)
	d1, d2 = str:match("(%d+)%.(%d%d%d)")
	while d1 and d2 do
		str = str:gsub(d1.."."..d2, d1..d2)
		d1, d2 = str:match("(%d+)%.(%d%d%d)")
	end
	return str
end

function SD.matchDigit(str, index)
	local i = 1
	for match in str:gmatch("%d+[%., ]?%d*[%., ]?%d*[%., ]?%d*") do
		if i == index then
			local m = match:gsub(",", ".")
			m = m:gsub(" ", "")
			m = removeDelimiters(m)
			return tonumber(m)
		elseif i > index then
			return nil
		end
		i = i + 1
	end
	return nil
end

function SD.matchDigits(str, indexes)
	local ret = {}

	local numbers = {}
	for match in str:gmatch("%d+[%., ]?%d*[%., ]?%d*[%., ]?%d*") do
		local m = match:gsub(",", ".")
		m = m:gsub(" ", "")
		--print(m)
		m = removeDelimiters(m)
		table.insert(numbers, tonumber(m))
	end

	for _,index in ipairs(indexes) do
		if #numbers >= index then table.insert(ret, numbers[index]);
		else return nil; end
	end

	if #ret == #indexes then return ret; end
	return nil
end

function SD.printTable(table)
	for key, value in pairs(table) do
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r " .. key .. " -> " .. value)
	end
end

SD.SPELL_COMBO_POINTS = 4
function SD.comboMatch(list)
	local combo = UnitPower("player", SD.SPELL_COMBO_POINTS)
	if combo >= 5 then return list[5] end
	for i, index in pairs(list) do
		if i == combo then return index end
	end
	return nil
end

function SD.strstarts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end
