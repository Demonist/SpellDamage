local classes = {}
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

local emptyClass = Class:create(ClassSpells)
local currentClass = emptyClass
local race = Race
local glyphs = Glyphs
local items = Items

local debuging = false
local eventDebuging = false
local showItems = true
local locale = nil

local elvUi_needUpdate = false

local onUpdateSpells = false
local onUpdateLastTime = GetTime()

local delayedUpdate = false
local delayedUpdateTime = GetTime()

local updatingHistory = {}

local DisableReason_Unknown, DisableReason_Language, DisableReason_Average = 0, 1, 2
local addonDisableReason = DisableReason_Unknown

local buttons = {}
local buttonsCache = {}

local function clearButtons(buttons)
	for _, button in pairs(buttons) do
		button.centerText:SetText("")
		button.bottomText:SetText("")
	end
end

local function createButtons()
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
		button.centerText:SetPoint("CENTER", 0, 0)	
		button.centerText:SetPoint("LEFT", 0, 0)
		
		button.bottomText = button:CreateFontString(nil, nil, "GameFontNormalLeft")
		button.bottomText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		button.bottomText:SetPoint("BOTTOM", 0, 0)	
		button.bottomText:SetPoint("LEFT", 0, 0)	
	end
end

local function checkRequirements()
	local locale = GetLocale()
	if locale ~= "ruRU" and locale ~= "enUS" and locale ~= "enGB" and locale ~= "deDE" and locale ~= "esES" and locale ~= "frFR" and locale ~= "itIT" and locale ~= "ptBR" and locale ~= "zhCN" then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage|r addon can't work in your locale! Addon disabled, sorry.", 1, 0, 0)
		addonDisableReason = DisableReason_Language
		DisableAddOn("SpellDamage")
	elseif GetCVar("SpellTooltip_DisplayAvgValues") == "0" then
		clearButtons(buttons)
		DEFAULT_CHAT_FRAME:AddMessage(sdLocale["locale_error"], 1, 0, 0)
		addonDisableReason = DisableReason_Average
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_LOGOUT")
EventFrame:RegisterEvent("CVAR_UPDATE")
EventFrame:RegisterEvent("UNIT_STATS")
EventFrame:RegisterEvent("UNIT_AURA")
EventFrame:RegisterEvent("UNIT_POWER")
EventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
EventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EventFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
EventFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
EventFrame:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
EventFrame:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
EventFrame:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
EventFrame:RegisterEvent("GLYPH_ADDED")
EventFrame:RegisterEvent("GLYPH_DISABLED")
EventFrame:RegisterEvent("GLYPH_ENABLED")
EventFrame:RegisterEvent("GLYPH_REMOVED")
EventFrame:RegisterEvent("GLYPH_UPDATED")
local logined = false
local function EventHandler(self, event, ...)
	if addonDisableReason ~= DisableReason_Unknown then
		if addonDisableReason == DisableReason_Average and event == "CVAR_UPDATE" then
			local variable = select(1, ...)
			if variable == "SHOW_POINTS_AS_AVG" and GetCVar("SpellTooltip_DisplayAvgValues") == "1" then
				DEFAULT_CHAT_FRAME:AddMessage(sdLocale["locale_error_fixed"], 0, 1, 0)
				addonDisableReason = DisableReason_Unknown
				EventHandler(self, "ACTIONBAR_PAGE_CHANGED")
			end
		end
		return
	end

	if debuging == true then debugprofilestart() end
	if eventDebuging == true then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r event |cFFffffc0"..event.."|r") end

	local needCheckOnUpdate = false
	local needUpdateButtonsCache = false

	if event == "PLAYER_LOGIN" then
		logined = true
		needCheckOnUpdate = true
		needUpdateButtonsCache = true
		locale = GetLocale()
		local _, className = UnitClass("player")
		currentClass = classes[className]
		if currentClass == nil then currentClass = emptyClass end
		
		createButtons()
		checkRequirements()
		if addonDisableReason ~= DisableReason_Unknown then return end
		glyphs:update()

		for k,v in pairs(classes) do
			v:onLoad()
		end
	end

	if event == "CVAR_UPDATE" then
		local variable = select(1, ...)
		if variable == "SHOW_POINTS_AS_AVG" then checkRequirements() end
	end

	if event == "PLAYER_LOGOUT" then logined = false end
	if logined == false then return end

	--Защита от слишком частого обновления:
	local currentTime = GetTime()
	if updatingHistory[event] and currentTime - updatingHistory[event] < 0.1 then
		delayedUpdate = true
		delayedUpdateTime = currentTime
		return
	else
		updatingHistory[event] = currentTime
	end

	if event == "UPDATE_BONUS_ACTIONBAR" or event == "UPDATE_EXTRA_ACTIONBAR" or event == "UPDATE_OVERRIDE_ACTIONBAR" or event == "UPDATE_VEHICLE_ACTIONBAR" then
		delayedUpdate = true
		delayedUpdateTime = currentTime
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_MACROS" 
		or event == "UPDATE_BONUS_ACTIONBAR" or event == "UPDATE_VEHICLE_ACTIONBAR"
		or event == "CUSTOM_DELAYED_UPDATE" or event == "CUSTOM_ELVUIFIX"
		or (event == "ACTIONBAR_SLOT_CHANGED" and UnitInVehicle("player") == false) then

		if debuging == true then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r clear on |cFFffffc0"..event.."|r event") end
		clearButtons(buttonsCache)

		needCheckOnUpdate = true
		needUpdateButtonsCache = true
		buttonsCache = {}
	end

	if UnitInVehicle("player") == true then return end

	if event == "ACTIONBAR_PAGE_CHANGED" and IsAddOnLoaded("ElvUI") then
		elvUi_needUpdate = true
		return
	end

	local glyphsUpdated = false
	if event == "GLYPH_ADDED" or event == "GLYPH_UPDATED" or event == "GLYPH_REMOVED" or event == "GLYPH_ENABLED" or event == "GLYPH_DISABLED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		if debuging == true then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r glyphs updated on |cFFffffc0"..event.."|r event") end
		glyphsUpdated = true
		glyphs:update()
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LOGIN" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "UPDATE_MACROS"
		or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "UPDATE_VEHICLE_ACTIONBAR" or evet == "UPDATE_EXTRA_ACTIONBAR" or event == "UPDATE_OVERRIDE_ACTIONBAR"
		or event == "CUSTOM_ON_UPDATE_SPELLS" or event == "CUSTOM_DELAYED_UPDATE" or event == "CUSTOM_ELVUIFIX"
		or (event == "UNIT_STATS" and select(1, ...) == "player")
		or (event == "UNIT_AURA" and select(1, ...) == "player")
		or (event == "UNIT_POWER" and currentClass.dependFromPower == true and select(1, ...) == "player" and currentClass.dependPowerTypes[select(2, ...)] ~= nil)
		or (event == "PLAYER_TARGET_CHANGED" and currentClass.dependFromTarget == true)
		or (event == "UNIT_AURA" and select(1, ...) == "target" and currentClass.dependFromTarget == true)
		or glyphsUpdated == true then
		
		local updateSpells = {}
		if needCheckOnUpdate == true then
			onUpdateSpells = false
			needCheckOnUpdate = false
			for id,_ in pairs(currentClass.onUpdateSpells) do
				updateSpells[id] = true
				needCheckOnUpdate = true
			end
		end

		local currentButtons = buttonsCache
		if needUpdateButtonsCache == true then currentButtons = buttons end

		for _, button in pairs(currentButtons) do
			local slot = ActionButton_GetPagedID(button)
			if slot == 0 then slot = ActionButton_CalculateAction(button) end
			if slot == 0 then slot = button:GetAttribute("action") end
			if HasAction(slot) then
				local actionType, id = GetActionInfo(slot)

				if actionType == "macro" and id then
					local match = string.match(GetMacroBody(id), "#%s*sd%s*%d+")
					if match then
						actionType = "spell"
						id = tonumber(string.match(match, "%d+"))
					end
				end

				if actionType == "spell" and id then
					button.centerText:SetText("")
					button.bottomText:SetText("")

					if needCheckOnUpdate == true and updateSpells[id] then
						onUpdateSpells = true
						needCheckOnUpdate = false
						updateSpells = nil
					end
					
					local used = currentClass:updateButton(button, id)
					if used == false then used = race:updateButton(button, id) end
					
					if used and needUpdateButtonsCache then table.insert(buttonsCache, button) end
				elseif showItems == true and items and actionType == "item" and id then
					if items:updateButton(button, id) == true and needUpdateButtonsCache then table.insert(buttonsCache, button) end
				end
			end
		end

		if debuging == true then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r updating on |cFFffffc0"..event.."|r event (|cFFc0c0c0"..string.format("%.1f", debugprofilestop()).."|r ms)") end
	end
end

EventFrame:SetScript("OnUpdate", function(self, elapsed)
	if addonDisableReason ~= DisableReason_Unknown then return end

	if elvUi_needUpdate == true then
		elvUi_needUpdate = false
		EventHandler(self, "CUSTOM_ELVUIFIX")
	elseif onUpdateSpells == true and GetTime() - onUpdateLastTime > 0.2 then
		EventHandler(self, "CUSTOM_ON_UPDATE_SPELLS")
		onUpdateLastTime = GetTime()
	elseif delayedUpdate == true and GetTime() - delayedUpdateTime > 0.2 then
		delayedUpdate = false
		EventHandler(self, "CUSTOM_DELAYED_UPDATE")
	end
end)

EventFrame:SetScript("OnEvent", EventHandler)

SLASH_SPELLDAMAGE1, SLASH_SPELLDAMAGE2, SLASH_SPELLDAMAGE3, SLASH_SPELLDAMAGE4 = "/sd", "/SD", "/spelldamage", "/SpellDamage"
function SlashCmdList.SPELLDAMAGE(msg, editbox)
	if addonDisableReason == DisableReason_Language then
		DEFAULT_CHAT_FRAME:AddMessage(sdLocale["addon_off_language"])
		return
	elseif addonDisableReason == DisableReason_Average then
		DEFAULT_CHAT_FRAME:AddMessage(sdLocale["addon_off_average"])
		return
	end

	local itemsState = function() if showItems == true then return sdLocale["chat_items_on"] else return sdLocale["chat_items_off"] end end
 	local errorsState = function() if displayErrors == true then return sdLocale["chat_errors_on"] else return sdLocale["chat_errors_off"] end end

 	if msg == "debug" then
 		debuging = not debuging
 		if debuging then
 			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r Debug |cFFc0ffc0enabled|r")
 		else
 			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r Debug |cFFffc0c0disabled|r")
 		end
 	elseif msg == "events" then
 		eventDebuging = not eventDebuging
  		if eventDebuging then
 			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r Events display |cFFc0ffc0enabled|r")
 		else
 			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r Events display |cFFffc0c0disabled|r")
 		end
  	elseif msg == "items" and items then
 		showItems = not showItems
 		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..itemsState())
 		EventHandler(self, "ACTIONBAR_PAGE_CHANGED")
 	elseif msg == "errors" then
 		displayErrors = not displayErrors
 		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..errorsState())
 	elseif msg == "help" then
 		displayErrors = not displayErrors
 		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..sdLocale["chat_help"])
	elseif msg == "version" then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..sdLocale["chat_version"].." 0.9.0.2 beta")
 	elseif msg == "status" then
 		DEFAULT_CHAT_FRAME:AddMessage(sdLocale["chat_settings"])
 		if items then
 			DEFAULT_CHAT_FRAME:AddMessage("   "..itemsState())
 		end
 		DEFAULT_CHAT_FRAME:AddMessage("   "..errorsState())
 	else
 		DEFAULT_CHAT_FRAME:AddMessage(sdLocale["chat_commands_list"])
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd status|r - "..sdLocale["chat_command_status"])
 		if items then
 			DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd items|r - "..sdLocale["chat_command_items"])
 		end
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd errors|r - "..sdLocale["chat_command_errors"])
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd help|r - "..sdLocale["chat_command_help"])
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd version|r - "..sdLocale["chat_command_version"])
 	end
end
