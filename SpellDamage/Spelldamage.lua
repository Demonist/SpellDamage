local buttons = {}

local classes = {}
local emptyClass = Class:create()
local currentClass = emptyClass
local race = Race
local glyphs = Glyphs

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("UNIT_STATS")
EventFrame:RegisterEvent("UNIT_AURA")
EventFrame:RegisterEvent("UNIT_POWER")
EventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EventFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
EventFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
EventFrame:RegisterEvent("GLYPH_ADDED")
EventFrame:RegisterEvent("GLYPH_DISABLED")
EventFrame:RegisterEvent("GLYPH_ENABLED")
EventFrame:RegisterEvent("GLYPH_REMOVED")
EventFrame:RegisterEvent("GLYPH_UPDATED")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local _, className = UnitClass("player")
		currentClass = classes[className]
		if currentClass == nil then currentClass = emptyClass end
		
		createButtons()
		glyphs:update()
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" then
		for _, button in pairs(buttons) do
			button.centerText:SetText("")
			button.bottomText:SetText("")
		end
	end

	local glyphsUpdated = false
	if event == "GLYPH_ADDED" or event == "GLYPH_DISABLED" or event == "GLYPH_ENABLED" or event == "GLYPH_REMOVED" or event == "GLYPH_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		glyphsUpdated = true
		glyphs:update()
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LOGIN" or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR"
		or (event == "UNIT_STATS" and select(1, ...) == "player")
		or (event == "UNIT_AURA" and select(1, ...) == "player")
		or (event == "UNIT_POWER" and currentClass.dependFromPower == true and select(1, ...) == "player" and currentClass.dependPowerTypes[select(2, ...)] ~= nil)
		or glyphsUpdated == true then

		for _, button in pairs(buttons) do
			local slot = ActionButton_GetPagedID(button)
			if slot == 0 then slot = ActionButton_CalculateAction(button) end
			if slot == 0 then slot = button:GetAttribute("action") end
			if HasAction(slot) then
				local actionType, id = GetActionInfo(slot)
				if actionType == 'spell' then
					button.centerText:SetText("")
					button.bottomText:SetText("")
					
					local used = currentClass:updateButton(button, id)
					if used == false then used = race:updateButton(button, id) end
				end
			end
		end
	end
end)

function createButtons()
	if IsAddOnLoaded("ElvUI") then
		for i = 1, 6 do
			for j = 1, 12 do
				table.insert(buttons, _G["ElvUI_Bar"..i.."Button"..j])
			end
		end
	else
		for i = 1, 6 do
			for j = 1, 12 do
				table.insert(buttons, _G[((select(i, "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"))..j)])
			end
		end
	end

	for _, button in pairs(buttons) do   
		button.centerText = button:CreateFontString(nil, nil, "GameFontNormalLeft")
		button.centerText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		button.centerText:SetPoint("CENTER" , 0, 0)	
		button.centerText:SetPoint("LEFT", 0, 0)
		
		button.bottomText = button:CreateFontString(nil, nil, "GameFontNormalLeft")
		button.bottomText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		button.bottomText:SetPoint("BOTTOM" , 0, 0)	
		button.bottomText:SetPoint("LEFT", 0, 0)	
	end
end

local function createClasses()
	classes["DEATHKNIGHT"]	= DeathKnight
	classes["DRUID"]		= Druid
	classes["HUNTER"]		= Hunter
	classes["MAGE"]			= Mage
	classes["MONK"]			= Monk
	classes["PALADIN"]		= Paladin
	classes["PRIEST"]		= Priest
	classes["ROGUE"]		= Rogue
	classes["SHAMAN"]		= Shaman
	classes["WARLOCK"]		= Warlock
	classes["WARRIOR"]		= Warrior
end

createClasses()