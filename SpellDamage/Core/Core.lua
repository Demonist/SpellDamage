SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = 0, 1, 2, 3, 4, 5, 6, 7, 8
SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

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

sdItemTooltop = CreateFrame("GameTooltip", "spellDamageItemTooltip")
local leftString = sdItemTooltop:CreateFontString()
local rightString = sdItemTooltop:CreateFontString()
leftString:SetFontObject(GameFontNormal)
rightString:SetFontObject(GameFontNormal)
sdItemTooltop:AddFontStrings(leftString, rightString)
sdItemTooltop:SetOwner(WorldFrame, "ANCHOR_NONE")
local tooltipInitTime = GetTime()

local itemsCache = {}
local function GetItemDescription(itemId)
	if itemsCache[itemId] then return itemsCache[itemId] end
	if #itemsCache >= 100 then itemsCache = {} end

	sdItemTooltop:ClearLines()
	sdItemTooltop:SetHyperlink("item:"..itemId)
	for i = 2, sdItemTooltop:NumLines() do
		local str = _G["spellDamageItemTooltipTextLeft"..i]
		if str then
			local text = str:GetText()
			if text and text:starts("Использование") then
				itemsCache[itemId] = text
				return text
			end
		end
	end
	return ""
end

function sdDebugItem(itemId)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..itemId.."-"..GetItemDescription(itemId))
	
	local out = ""
	sdItemTooltop:ClearLines()
	sdItemTooltop:SetHyperlink("item:"..itemId)
	for i = 2, sdItemTooltop:NumLines() do
		local str = _G["spellDamageItemTooltipTextLeft"..i]
		if str then
			local text = str:GetText()
			if text then
				out = out..i.."-"..text
			end
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..out)
end

displayErrors = true
ClassSpells, ClassItems = 1, 2

Class = {}
function Class:create(classType)
	local class = {}
	class.spells = {}
	class.dependFromPower = false
	class.dependFromTarget = false
	class.dependPowerTypes = {}
	class.onUpdateSpells = {}
	class.onLoad = function() end
	class.type = classType
	if classType == ClassItems then
		class.getSpellText = GetItemDescription
	else
		class.getSpellText = GetSpellDescription
	end
	self.__index = self
	return setmetatable(class, self)
end

function Class:updateButton(button, spellId)
	local spellParser = self.spells[spellId]
	local updateParser = self.onUpdateSpells[spellId]

	if spellParser == nil and updateParser == nil then return false end

	local data = SpellData:create(SpellUnknown)

	if spellParser then
		local text = self.getSpellText(spellId)
		data = spellParser:getData(text)
	elseif updateParser then
		data = updateParser:getData(nil)
	end

	if data.type == SpellUnknown and self.type == ClassItems and GetTime() - tooltipInitTime < 120 then return false end	--Костыль от начальных ошибок предметов

	if data.type == SpellUnknown and displayErrors == true then
		local slot = "умения"
		if self.type == ClassItems then slot = "предмета" end
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0Ошибка парсинга "..slot.." с id|r |cFFffffc0"..spellId.."|r.")
		return false 
	end

	if data.type == SpellEmpty then return true end

	if self.type == ClassSpells then
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
		elseif data.type == SpellTimeHealAndTimeMana then
			button.centerText:SetText("(".. shortNumber(data.timeHeal) ..")")
			button.centerText:SetTextColor(0, 1, 0, 1)
			button.bottomText:SetText("(".. shortNumber(data.timeMana) ..")")
			button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
		elseif data.type == SpellAbsorbAndHeal then
			button.centerText:SetText( shortNumber(data.absorb) )
			button.centerText:SetTextColor(1, 0.5, 1, 1)
			button.bottomText:SetText( shortNumber(data.heal) )
			button.bottomText:SetTextColor(0, 1, 0, 1)
		elseif data.type == SpellHealAndMana then
			button.centerText:SetText( shortNumber(data.heal) )
			button.centerText:SetTextColor(0, 1, 0, 1)
			button.bottomText:SetText( shortNumber(data.mana) )
			button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
		elseif data.type == SpellDamageAndMana then
			button.centerText:SetText( shortNumber(data.damage) )
			button.centerText:SetTextColor(1, 1, 0, 1)
			button.bottomText:SetText( shortNumber(data.mana) )
			button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
		elseif displayErrors == true then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0Ошибка определения типа умения с id|r |cFFffffc0"..spellId.."|r.")
		end
	else
		if data.type == SpellHeal then
			button.centerText:SetText( shortNumber(data.heal) )
			button.centerText:SetTextColor(0, 1, 0, 1)
		elseif data.type == SpellTimeHeal then
			button.centerText:SetText("(".. shortNumber(data.timeHeal) ..")")
			button.centerText:SetTextColor(0, 1, 0, 1)
		elseif data.type == SpellMana then
			button.centerText:SetText( shortNumber(data.mana) )
			button.centerText:SetTextColor(0.5, 0.5, 1, 1)
		elseif data.type == SpellTimeMana then
			button.centerText:SetText("(".. shortNumber(data.timeMana) ..")")
			button.centerText:SetTextColor(0.5, 0.5, 1, 1)
		elseif data.type == SpellHealAndMana then
			button.centerText:SetText( shortNumber(data.heal) )
			button.centerText:SetTextColor(0, 1, 0, 1)
			button.bottomText:SetText( shortNumber(data.mana) )
			button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
		elseif data.type == SpellTimeHealAndTimeMana then
			button.centerText:SetText("(".. shortNumber(data.timeHeal) ..")")
			button.centerText:SetTextColor(0, 1, 0, 1)
			button.bottomText:SetText("(".. shortNumber(data.timeMana) ..")")
			button.bottomText:SetTextColor(0.5, 0.5, 1, 1)
		elseif data.type == SpellAbsorb then
			button.centerText:SetText( shortNumber(data.absorb) )
			button.centerText:SetTextColor(1, 0.5, 1, 1)
		elseif data.type == SpellDamage then
			button.centerText:SetText( shortNumber(data.damage) )
			button.centerText:SetTextColor(1, 1, 0, 1)
		elseif data.type == SpellTimeDamage then
			button.centerText:SetText("(".. shortNumber(data.timeDamage) ..")")
			button.centerText:SetTextColor(1, 1, 0, 1)
		elseif data.type == SpellDamageAndTimeDamage then
			button.centerText:SetText( shortNumber(data.damage) )
			button.centerText:SetTextColor(1, 1, 0, 1)
			button.bottomText:SetText("(".. shortNumber(data.timeDamage) ..")")
			button.bottomText:SetTextColor(1, 1, 0, 1)
		elseif displayErrors == true then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0Ошибка определения типа предмета с id|r |cFFffffc0"..spellId.."|r.")
		end
	end
	return true
end
