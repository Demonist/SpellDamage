local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local Items = SD.Items

local emptyClass = SD.Class:create(SD.ClassSpells)
local currentClass = emptyClass
local race = SD.classes["Race"]

local debuging = false
local eventDebuging = false
local showItems = false
local locale = nil

local nonStandardUi = false
local ui_needUpdate = false

local onUpdateSpells = false
local onUpdateLastTime = GetTime()

local delayedUpdate = false
local delayedUpdateTime = GetTime()

local updatingHistory = {}

local DisableReason_Unknown, DisableReason_Language, DisableReason_Average, DisableReason_Version = 0, 1, 2, 3
local addonDisableReason = DisableReason_Unknown

local buttons = {}
local buttonsCache = {}


local function clearButtons(buttons)
	for _, button in ipairs(buttons) do
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
		nonStandardUi = true
	elseif IsAddOnLoaded("Bartender4") then
		for i = 1, 160 do
			table.insert(buttons, _G["BT4Button"..i])
		end
		nonStandardUi = true
	else
		for i = 1, 6 do
			for j = 1, 12 do
				table.insert(buttons, _G[((select(i, "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"))..j)])
			end
		end

		if IsAddOnLoaded("Dominos") then
			for i = 1, 60 do
				table.insert(buttons, _G["DominosActionButton"..i])
			end
			nonStandardUi = true
		end
	end

	local fontName = "Fonts\\FRIZQT__.TTF"
	local cx, cy = 0, 0
	local bx, by = 0, 0
	if SpellDamageStorage and SpellDamageStorage["font"] then
		fontName = "Fonts\\"..SpellDamageStorage["font"]
		if SpellDamageStorage["font"] == "ARIALN.TTF" then
			cx = 2
			cy = 3
			bx = 2
			by = 1
		end
	end
	for _, button in ipairs(buttons) do   
		button.centerText = button:CreateFontString(nil, nil, "GameFontNormalLeft")
		button.centerText:SetFont(fontName, 10, "OUTLINE")
		button.centerText:SetPoint("CENTER", 0, cy)
		button.centerText:SetPoint("LEFT", cx, 0)
		
		button.bottomText = button:CreateFontString(nil, nil, "GameFontNormalLeft")
		button.bottomText:SetFont(fontName, 10, "OUTLINE")
		button.bottomText:SetPoint("BOTTOM", 0, by)
		button.bottomText:SetPoint("LEFT", bx, 0)
	end
end

local function checkRequirements()
	local locale = GetLocale()
	if locale ~= "ruRU" and locale ~= "enUS" and locale ~= "enGB" and locale ~= "deDE" and locale ~= "esES" and locale ~= "frFR" and locale ~= "itIT" and locale ~= "ptBR" and locale ~= "zhCN" and locale ~= "koKR" then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage|r addon can't work in your locale! Addon disabled, sorry.", 1, 0, 0)
		addonDisableReason = DisableReason_Language
		DisableAddOn("SpellDamage")
	elseif GetCVar("SpellTooltip_DisplayAvgValues") == "0" then
		clearButtons(buttons)
		DEFAULT_CHAT_FRAME:AddMessage(L["locale_error"], 1, 0, 0)
		addonDisableReason = DisableReason_Average
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_LOGOUT")
EventFrame:RegisterEvent("CVAR_UPDATE")
EventFrame:RegisterEvent("UNIT_STATS")
EventFrame:RegisterEvent("UNIT_AURA")
EventFrame:RegisterEvent("UNIT_POWER_UPDATE")
EventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
EventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EventFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
EventFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
EventFrame:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
EventFrame:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
EventFrame:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
local logined, updateSpells = false, {}
local function EventHandler(self, event, ...)
	if addonDisableReason ~= DisableReason_Unknown then
		if addonDisableReason == DisableReason_Average and event == "CVAR_UPDATE" then
			local variable = select(1, ...)
			if variable == "SHOW_POINTS_AS_AVG" and GetCVar("SpellTooltip_DisplayAvgValues") == "1" then
				DEFAULT_CHAT_FRAME:AddMessage(L["locale_error_fixed"], 0, 1, 0)
				addonDisableReason = DisableReason_Unknown
				EventHandler(self, "ACTIONBAR_PAGE_CHANGED")
			end
		end
		return
	end

	if debuging == true then debugprofilestart(); end
	if eventDebuging == true then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r event |cFFffffc0"..event.."|r"); end

	local needCheckOnUpdate = false
	local needUpdateButtonsCache = false

	if event == "PLAYER_LOGIN" then
		--version check:
		local version = tonumber(string.sub(GetBuildInfo(), 1, 1))
		if version ~= 8 then
			addonDisableReason = DisableReason_Version
			DEFAULT_CHAT_FRAME:AddMessage(L["addon_off_version"], 1, 0, 0)
			DisableAddOn("SpellDamage")
			return
		end

		logined = true
		needCheckOnUpdate = true
		needUpdateButtonsCache = true
		locale = GetLocale()
		local _, className = UnitClass("player")
	
		createButtons()
		checkRequirements()
		if addonDisableReason ~= DisableReason_Unknown then return; end

		if SpellDamageStorage then
			if SpellDamageStorage["dev"] == true then SD.checkSpells(); end
			if SpellDamageStorage["dev"] == true then showItems = SpellDamageStorage["showItems"]; end
			if SpellDamageStorage["dev"] == true then SD.displayErrors = SpellDamageStorage["displayErrors"]; end
		else
			SpellDamageStorage = {}
		end


		currentClass = SD.classes[className]
		if currentClass then currentClass:init(); end
		SD.classes = nil
		SD.class = currentClass

		race:init()
	end

	if event == "CVAR_UPDATE" then
		local variable = select(1, ...)
		if variable == "SHOW_POINTS_AS_AVG" then checkRequirements(); end
	end

	if event == "PLAYER_LOGOUT" then logined = false; end
	if logined == false then return; end

	--Защита от слишком частого обновления:
	--if true == true then return; end
	---????
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
		or event == "CUSTOM_DELAYED_UPDATE" or event == "CUSTOM_UI_UPDATE"
		or (event == "ACTIONBAR_SLOT_CHANGED" and UnitInVehicle("player") == false) then

		if debuging == true then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r clear on |cFFffffc0"..event.."|r event"); end
		
		needCheckOnUpdate = true
		needUpdateButtonsCache = true

		if #buttonsCache > 0 then
			clearButtons(buttonsCache)
			buttonsCache = {}
		end
	end

	if UnitInVehicle("player") == true then return; end

	if event == "ACTIONBAR_PAGE_CHANGED" and nonStandardUi then
		ui_needUpdate = true
		return
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LOGIN" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "UPDATE_MACROS"
		or event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "UPDATE_VEHICLE_ACTIONBAR" or evet == "UPDATE_EXTRA_ACTIONBAR" or event == "UPDATE_OVERRIDE_ACTIONBAR"
		or event == "CUSTOM_ON_UPDATE_SPELLS" or event == "CUSTOM_DELAYED_UPDATE" or event == "CUSTOM_UI_UPDATE"
		or (event == "UNIT_STATS" and select(1, ...) == "player")
		or (event == "UNIT_AURA" and select(1, ...) == "player")
		or (event == "UNIT_POWER" and currentClass.dependFromPower == true and select(1, ...) == "player" and currentClass.dependPowerTypes[select(2, ...)] ~= nil)
		or (event == "PLAYER_TARGET_CHANGED" and currentClass.dependFromTarget == true)
		or (event == "UNIT_AURA" and select(1, ...) == "target" and currentClass.dependFromTarget == true) then
		if currentClass:hasOnUpdateSpells() then
			updateSpells = {}
			if needCheckOnUpdate == true then
				onUpdateSpells = false
				needCheckOnUpdate = false
				for id,_ in pairs(currentClass.onUpdateSpells) do
					updateSpells[id] = true
					needCheckOnUpdate = true
				end
			end
		else
			needCheckOnUpdate = false
		end

		local currentButtons = buttonsCache
		if needUpdateButtonsCache == true then currentButtons = buttons; end

		for _, button in ipairs(currentButtons) do
			local slot = ActionButton_GetPagedID(button)
			if slot == 0 then slot = ActionButton_CalculateAction(button); end
			if slot == 0 then slot = button:GetAttribute("action"); end
			if HasAction(slot) then
				local actionType, id = GetActionInfo(slot)
				local macroText = GetMacroBody(id)
				if macroText then
					macroText = string.gsub(macroText, "modifier", "mod")

					if actionType == "macro" and id then
						local match = string.match(macroText, "#%s*sd%s*%[mod%:shift%]%s*%d+")
						if match and IsShiftKeyDown() then
							actionType = "spell"
							id = tonumber(string.match(match, "%d+"))	
						else
							match = string.match(macroText, "#%s*sd%s*%[mod%:alt%]%s*%d+")
							if match and IsAltKeyDown() then
								actionType = "spell"
								id = tonumber(string.match(match, "%d+"))	
							else
								match = string.match(macroText, "#%s*sd%s*%[mod:ctrl%]%s*%d+")
								if match and IsControlKeyDown() then
									actionType = "spell"
									id = tonumber(string.match(match, "%d+"))
								else
									match = string.match(macroText, "#%s*sd%s*%d+")
									if match then
										actionType = "spell"
										id = tonumber(string.match(match, "%d+"))
									end
								end
							end
						end
					end
				end

				if actionType == "spell" and id then
					--button.centerText:SetText(id)
					button.bottomText:SetText("")

					if needCheckOnUpdate == true and updateSpells[id] then
						onUpdateSpells = true
						needCheckOnUpdate = false
					end
					
					local used = currentClass:updateButton(button, id)
					if used == false then used = race:updateButton(button, id); end
					if used and needUpdateButtonsCache then table.insert(buttonsCache, button); end
				elseif showItems == true and Items and actionType == "item" and id then
					if Items:updateButton(button, id) == true and needUpdateButtonsCache then table.insert(buttonsCache, button); end
				end
			end
		end

		if debuging == true then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r updating on |cFFffffc0"..event.."|r event (|cFFc0c0c0"..string.format("%.1f", debugprofilestop()).."|r ms)"); end
	end
end

EventFrame:SetScript("OnUpdate", function(self, elapsed)
	if addonDisableReason ~= DisableReason_Unknown then return; end

	if ui_needUpdate == true then
		ui_needUpdate = false
		EventHandler(self, "CUSTOM_UI_UPDATE")
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
		DEFAULT_CHAT_FRAME:AddMessage(L["addon_off_language"])
		return
	elseif addonDisableReason == DisableReason_Average then
		DEFAULT_CHAT_FRAME:AddMessage(L["addon_off_average"])
		return
	elseif addonDisableReason == DisableReason_Version then
		DEFAULT_CHAT_FRAME:AddMessage(L["addon_off_version"])
		return
	end

	local itemsState = function() if showItems == true then return L["chat_items_on"] else return L["chat_items_off"]; end; end
	local errorsState = function() if SD.displayErrors == true then return L["chat_errors_on"] else return L["chat_errors_off"]; end; end
	local autoOffErrorsState = function() if SD.autoOffDisplayErrors == true then return L["chat_auto_errors_on"] else return L["chat_auto_errors_off"]; end; end

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

  	elseif msg == "items" and Items then
 		showItems = not showItems
 		if SpellDamageStorage then SpellDamageStorage["showItems"] = showItems; end
 		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..itemsState())
 		EventHandler(self, "ACTIONBAR_PAGE_CHANGED")

 	elseif msg == "errors" then
 		SD.displayErrors = not SD.displayErrors
 		if SpellDamageStorage then SpellDamageStorage["displayErrors"] = SD.displayErrors; end
 		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..errorsState())

 	elseif msg == "autoOffErrors" then
 		SD.autoOffDisplayErrors = not SD.autoOffDisplayErrors
 		if SD.autoOffDisplayErrors then
 			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..L["chat_auto_errors_on"])
 			SD.errorsCount = 0
 		else
 			DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..L["chat_auto_errors_off"])
 		end

 	elseif msg == "macroshelp" then
 		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..L["macroshelp"])
 	
 	elseif msg == "font friz" then
 		if not SpellDamageStorage then SpellDamageStorage = {}; end
 		SpellDamageStorage["font"] = "FRIZQT__.TTF"
 		ReloadUI()

 	elseif msg == "font arial" then
 		if not SpellDamageStorage then SpellDamageStorage = {}; end
 		SpellDamageStorage["font"] = "ARIALN.TTF"
 		ReloadUI()
	
	elseif msg == "version" then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r "..L["chat_version"].." "..GetAddOnMetadata("SpellDamage", "Version"))
 	
 	elseif msg == "status" then
 		DEFAULT_CHAT_FRAME:AddMessage(L["chat_settings"])
 		if Items then
 			DEFAULT_CHAT_FRAME:AddMessage("   "..itemsState())
 		end
 		DEFAULT_CHAT_FRAME:AddMessage("   "..errorsState())
 		if SpellDamageStorage and SpellDamageStorage["dev"] then DEFAULT_CHAT_FRAME:AddMessage("   Dev mode |cFFc0ffc0enabled|r"); end
 	
 	elseif msg == "dev" then
 		SD.toogleDevMode()
 		if SpellDamageStorage["dev"] then DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r Dev mode |cFFc0ffc0enabled|r");
 		else DEFAULT_CHAT_FRAME:AddMessage("|cFFffff00SpellDamage:|r Dev mode |cFFffc0c0disabled|r"); end
 	
 	else
 		DEFAULT_CHAT_FRAME:AddMessage(L["chat_commands_list"])
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd status|r - "..L["chat_command_status"])
 		if Items then
 			DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd items|r - "..L["chat_command_items"])
 		end
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd errors|r - "..L["chat_command_errors"])
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd macroshelp|r - "..L["chat_command_help"])
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd font (friz|arial)|r - "..L["chat_command_font"])
 		DEFAULT_CHAT_FRAME:AddMessage("   |cFFffff00/sd version|r - "..L["chat_command_version"])
 	end
end
