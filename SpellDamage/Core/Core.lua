local L, shortNumber, matchDigit, matchDigits, printTable, strstarts, Buff, Debuff = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts, SD.Buff, SD.Debuff

--

SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb = 0, 1, 2, 3, 4, 5, 6, 7, 8
SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal, SD.SpellAbsorbAndDamage = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20

local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal, SpellAbsorbAndDamage = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal, SD.SpellAbsorbAndDamage

local _spellData = {}	--cache for minimizing memory new/delete function calls
_spellData.type = SD.SpellUnknown
SD.SpellData = {}
function SD.SpellData:create(type)
	_spellData.type = type
	return _spellData
end

local sdItemTooltip = CreateFrame("GameTooltip", "spellDamageItemTooltip")
local leftString = sdItemTooltip:CreateFontString()
local rightString = sdItemTooltip:CreateFontString()
leftString:SetFontObject(GameFontNormal)
rightString:SetFontObject(GameFontNormal)
sdItemTooltip:AddFontStrings(leftString, rightString)
sdItemTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
local tooltipInitTime = GetTime()

local itemsCache = {}
local function GetItemDescription(itemId)
	if itemsCache[itemId] then return itemsCache[itemId]; end
	if #itemsCache >= 100 then itemsCache = {}; end

	sdItemTooltip:ClearLines()
	sdItemTooltip:SetHyperlink("item:"..itemId)
	for i = 2, sdItemTooltip:NumLines() do
		local tooltipTextFrame = _G["spellDamageItemTooltipTextLeft"..i]
		if tooltipTextFrame then
			local text = tooltipTextFrame:GetText()
			if text and SD.strstarts(text, L["item_use"]) then
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
	sdItemTooltip:ClearLines()
	sdItemTooltip:SetHyperlink("item:"..itemId)
	for i = 2, sdItemTooltip:NumLines() do
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

SD.displayErrors = true
SD.autoOffDisplayErrors = true
SD.errorsCount = 0

local function incErrorsCount()
	if SD.displayErrors and SD.autoOffDisplayErrors and GetTime() - tooltipInitTime > 10 then
		SD.errorsCount = SD.errorsCount + 1
		if SD.errorsCount >= 5 then
			SD.displayErrors = false
			SD.errorsCount = 0
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..L["too_many_errors"])
		end
	end
end

SD.ClassSpells, SD.ClassItems = 1, 2
local ClassSpells, ClassItems = SD.ClassSpells, SD.ClassItems

SD.Class = {}
function SD.Class:create(classType)
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

function SD.Class:hasOnUpdateSpells()
	if self.hasOnUpdateSpellsCache ~= nil then return self.hasOnUpdateSpellsCache; end
	self.hasOnUpdateSpellsCache = false
	for _,_ in pairs(self.onUpdateSpells) do
		self.hasOnUpdateSpellsCache = true
		break
	end
	return self.hasOnUpdateSpellsCache
end

function SD.Class:updateButton(button, spellId)
	local spellParser = self.spells[spellId]
	local updateParser = self.onUpdateSpells[spellId]

	if spellParser == nil and updateParser == nil then return false; end

	local data = SD.SpellData:create(SpellUnknown)

	if spellParser then
		local text = self.getSpellText(spellId)
		if text then data = spellParser:getData(text);
		elseif SD.displayErrors then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0"..L["description_error"].." id|r |cFFffffc0"..spellId.."|r.")
			incErrorsCount()
			return false
		end
	elseif updateParser then
		data = updateParser:getData(nil)
	end

	if (not data or data.type == SpellUnknown) and self.type == ClassSpells and GetTime() - tooltipInitTime < 120 then return false; end --Костыль от начальных ошибок скилов
	if (not data or data.type == SpellUnknown) and self.type == ClassItems and GetTime() - tooltipInitTime < 120 then return false; end	--Костыль от начальных ошибок предметов

	if (not data or data.type == SpellUnknown) and SD.displayErrors == true then
		if self.type == ClassSpells then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0"..L["parsing_spell_error"].." id|r |cFFffffc0"..spellId.."|r.")
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0"..L["parsing_item_error"].." id|r |cFFffffc0"..spellId.."|r.")
		end
		incErrorsCount()
		return false 
	end

	if data.type == SpellEmpty then return true; end

	if self.type == ClassSpells then
		if data.type == SpellDamage then
			button.centerText:SetText( shortNumber(data.damage) )
			button.centerText:SetTextColor(1, 1, 0, 1)
		elseif data.type == SpellTimeDamage then
			button.centerText:SetText("(".. shortNumber(data.timeDamage) ..")")
			button.centerText:SetTextColor(1, 1, 0, 1)
		elseif data.type == SpellHeal then
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
		elseif data.type == SpellAbsorb then
			button.centerText:SetText( shortNumber(data.absorb) )
			button.centerText:SetTextColor(1, 0.5, 1, 1)
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
			button.bottomText:SetText(shortNumber(data.heal))
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
		elseif data.type == SpellAbsorbAndDamage then
			button.centerText:SetText( shortNumber(data.absorb) )
			button.centerText:SetTextColor(1, 0.5, 1, 1)
			button.bottomText:SetText( shortNumber(data.damage) )
			button.bottomText:SetTextColor(1, 1, 0, 1)
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
		elseif SD.displayErrors == true then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0"..L["type_spell_error"].." id|r |cFFffffc0"..spellId.."|r.")
			incErrorsCount()
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
		elseif SD.displayErrors == true then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r |cFFffc0c0"..L["type_item_error"].." id|r |cFFffffc0"..spellId.."|r.")
			incErrorsCount()
		end
	end
	return true
end

--

SD.classes = {}

--

function SD.toogleDevMode()
	if not SpellDamageStorage then
		SpellDamageStorage = {}
		SpellDamageStorage["dev"] = true
	elseif not SpellDamageStorage["dev"] then
		SpellDamageStorage["dev"] = true
	else
		SpellDamageStorage["dev"] = not SpellDamageStorage["dev"]
	end

 	if GetCVar("scriptErrors") ~= "1" then
 		local str = "|cFFffff00SpellDamage:|r |cFFff5555Error!|r To use dev mode you must enabled |cFFccccccShow Lua errors|r option."
 		if not IsAddOnLoaded("BugSack") then str = str + " Also strongly recommend to install |cFFccccccBugSack|r addon."; end
 		SpellDamageStorage["dev"] = false
		DEFAULT_CHAT_FRAME:AddMessage(str)
	elseif not IsAddOnLoaded("BugSack") then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r Strongly recommend to install |cFFccccccBugSack|r addon.")
	end
end

function SD.checkSpells()
	local str = ""
	for className, class in pairs(SD.classes) do
		class:init()
		local s = ""
		for id, parser in pairs(class.spells) do
			local description = GetSpellDescription(id)
			if not description then
				s = s.."no descr for "..id..", "
			elseif description == "" then
				DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r check spells - |cFFffc0c0"..L["description_error"].." id|r |cFFffffc0"..id.."|r.");
			else
				local data = parser:getData(description)
				if not data or data.type == SD.SpellUnknown then s = s..id..", "; end
			end
		end
		if s ~= "" then str = str..className.."("..s.."), "; end
		class.spells = {}
	end
	if str ~= "" then error("SpellDamage check spells error: "..str); end
end
