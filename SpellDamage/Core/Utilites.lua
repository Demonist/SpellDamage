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

function SD.matchDigit(str, index)
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

--TODO: переписать чтобы работала с произвольным порядком индексов
function SD.matchDigits(str, indexTable)
	local ret = {}
	local keys = {}
	for _, key in ipairs(indexTable) do keys[key] = true end
	local i = 1
	for match in str:gmatch("%d+[%.,]?%d*") do
		if keys[i] ~= nil then
			local m = match:gsub(",", ".")
			table.insert(ret, tonumber(m))
		end
		i = i + 1
	end
	if #ret == #indexTable then return ret; end
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
