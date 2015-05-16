local buttons = {}

local classes = {}
local emptyClass = Class:create()
local currentClass = emptyClass

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("UNIT_STATS")
EventFrame:RegisterEvent("UNIT_AURA")
EventFrame:RegisterEvent("UNIT_POWER")
EventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EventFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local _, className = UnitClass("player")
		currentClass = classes[className]
		if currentClass == nil then currentClass = emptyClass end
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" then
		for _, button in pairs(buttons) do
			button.centerText:SetText("")
			button.bottomText:SetText("")
		end
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LOGIN" or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED"
		or (event == "UNIT_STATS" and select(1, ...) == "player")
		or (event == "UNIT_AURA" and select(1, ...) == "player")
		or (event == "UNIT_POWER" and currentClass.dependFromPower == true and select(1, ...) == "player" and currentClass.dependPowerTypes[select(2, ...)] ~= nil) then
		for _, button in pairs(buttons) do
			local slot = ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute('action') or 0
			if HasAction(slot) then
				local actionType, id = GetActionInfo(slot)
				if actionType == 'spell' then
					currentClass:updateButton(button, id)
				end
			end
		end
	end
end)

local function createButtons()	
	for i = 1, 6 do
		for j = 1, 12 do
			table.insert(buttons, _G[((select(i,"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"))..j)])
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
createButtons()
