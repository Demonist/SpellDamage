local ABobjects = {}
local spellsTable = {}
local debugFlag = false

SLASH_SPELLDAMAGE1 = "/spelldamage"
SLASH_SPELLDAMAGE2 = "/sd"
function SlashCmdList.SPELLDAMAGE(msg, editbox)
	if msg == "debug" then
		if debugFlag == true then
			debugFlag = false
			DEFAULT_CHAT_FRAME:AddMessage("debug: disabled")
		else
			debugFlag = true
			DEFAULT_CHAT_FRAME:AddMessage("debug: enabled")
		end
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("UNIT_STATS")
EventFrame:RegisterEvent("UNIT_AURA")
EventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "ACTIVE_TALENT_GROUP_CHANGED" then
		clearActionBar()
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		local _, id = GetActionInfo(select(1, ...))
		if spellsTable[id] ~= nil then
			clearActionBar()
		end
	end

	if (event == "UNIT_STATS" and select(1, ...) == "player")
	or (event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_LOGIN")
	or (event == "UNIT_AURA" and select(1, ...) == "player") then
		updateActionBar()
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		local _, id = GetActionInfo(select(1, ...))
		if spellsTable[id] ~= nil then
			updateActionBar()
		end
	end
end)

function debug(msg)
	if debugFlag == true then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

function clearActionBar()
	debug("clearActionBar()")
	for _, button in pairs(ActionBarButtonEventsFrame.frames) do
		if (button.text) then
			button.text:SetText("")
		end
	end
end

function updateActionBar()
	debug("updateActionBar()")
	for _, ActionButton in pairs(ABobjects) do       
		local slot = ActionButton_GetPagedID(ActionButton) or ActionButton_CalculateAction(ActionButton) or ActionButton:GetAttribute('action') or 0
		if HasAction(slot) then
			local actionType, id = GetActionInfo(slot)
			if actionType == 'spell' then
				local num = spellsTable[id]
				if num ~= nil then
					ActionButton.text:SetText(matchIndex(GetSpellDescription(id), "%d+", num))
				end
			end
		end  
	end      
end

function matchIndex(str, pattern, index)
  local i = 1
  for value in str:gmatch(pattern) do
    if(i == index) then return value end
    i = i + 1
  end
  return nil
end

local function createABFrames()	
	for i = 1, 6 do
		for j = 1, 12 do
			table.insert(ABobjects,_G[((select(i,"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "BonusActionButton"))..j)])
		end
	end

	for _, ActionButton in pairs(ABobjects) do     
		ActionButton.text = ActionButton:CreateFontString(nil, nil, "GameFontNormalLeft")
		ActionButton.text:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
		ActionButton.text:SetPoint("BOTTOM",0,0)	
		ActionButton.text:SetPoint("CENTER",0,0)	
		ActionButton.text:SetTextColor(255,255,255,1)
	end
end

local function createSpellsTable()
	spellsTable[133] = 1 		--Fireball
	spellsTable[11366] = 1 		--Pyroblast
	spellsTable[2136] = 1 		--Fire Blast
	spellsTable[122] = 2 		--Frost Nova
end

createABFrames()
createSpellsTable()