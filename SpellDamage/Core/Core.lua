SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = 0, 1, 2, 3, 4, 5, 6, 7, 8
SpellDamageAndTimeDamage, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = 10, 11, 12, 13, 14, 15, 16, 17, 18

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

local ItemTooltip = CreateFrame("GAMETOOLTIP", "spellDamageItemTooltip")
local L = ItemTooltip:CreateFontString()
local R = ItemTooltip:CreateFontString()
L:SetFontObject(GameFontNormal)
R:SetFontObject(GameFontNormal)
ItemTooltip:AddFontStrings(L,R)
ItemTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
ItemTooltip:ClearLines()
local itemsCache = {}
local function GetItemDescription(itemId)
	if itemsCache[itemId] then return itemsCache[itemId] end
	if #itemsCache >= 100 then itemsCache = {} end
	
	ItemTooltip:SetHyperlink("item:"..itemId)
	for i = 2, ItemTooltip:NumLines() do
		local str = _G["spellDamageItemTooltipTextLeft"..i]
		if str then
			local text = str:GetText()
			if text:starts("Использование") then
				itemsCache[itemId] = text
				return text
			end
		end
	end
	return ""
end

displayErrors = true
ClassSpells, ClassItems = 1, 2

Class = {}
function Class:create(type)
	local class = {}
	class.spells = {}
	class.dependFromPower = false
	class.dependPowerTypes = {}
	class.type = type
	if type == ClassSpells then
		class.getSpellText = GetSpellDescription
	else
		class.getSpellText = GetItemDescription
	end
	self.__index = self
	return setmetatable(class, self)
end

function Class:updateButton(button, spellId)
	if self.spells[spellId] == nil then return false end

	local data = self.spells[spellId]:getData(self.getSpellText(spellId))
	if data.type == SpellUnknown and displayErrors == true then
		local slot = "умения"
		if self.type == ClassItems then slot = "предмета" end
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0Ошибка парсинга "..slot.." с id|r |cFFffffc0"..spellId.."|r", 1, 0, 0)
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
		elseif displayErrors == true then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0Ошибка определения типа умения с id|r |cFFffffc0"..spellId.."|r", 1, 0, 0)
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
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0Ошибка определения типа предмета с id|r |cFFffffc0"..spellId.."|r", 1, 0, 0)
		end
	end
	return true
end