local ABobjects = {}

local damageSpells = {}
local healSpells = {}
local absorbSpells = {}

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
		if damageSpells[id] ~= nil or healSpells[id] ~= nil or absorbSpells[id] ~= nil then
			clearActionBar()
		end
	end

	if (event == "UNIT_STATS" and select(1, ...) == "player")
	or (event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_LOGIN")
	or (event == "UNIT_AURA" and select(1, ...) == "player") then
		updateActionBar()
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		local _, id = GetActionInfo(select(1, ...))
		if damageSpells[id] ~= nil or healSpells[id] ~= nil or absorbSpells[id] ~= nil then
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
				local colorR, colorG, colorB
				local num = damageSpells[id]
				if num ~= nil then
					colorR, colorG, colorB = 1, 0.3, 0
				else
					num = healSpells[id]
					if num ~= nil then
						colorR, colorG, colorB = 0, 1, 0
					else
						num = absorbSpells[id]
						if num ~= nil then
							colorR, colorG, colorB = 1, 0.5, 1
						end
					end
				end

				if num ~= nil then
					ActionButton.text:SetText(
						shortNumber(
							tonumber(
								matchIndex(GetSpellDescription(id), "%d+", num)
								)
							)
						)
					ActionButton.text:SetTextColor(colorR, colorG, colorB, 1)
				end
			end
		end  
	end      
end

function shortNumber(number)
	if number >= 1000000 then
		return string.format("%.1fm", number/1000000)
	elseif number >= 1000 then
		return string.format("%.1fk", number/1000)
	end
	return number
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
		ActionButton.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		ActionButton.text:SetPoint("BOTTOM" , 0, 2)	
		ActionButton.text:SetPoint("LEFT", 1, 0)	
		ActionButton.text:SetTextColor(1, 1, 1, 1)
	end
end

local function createSpellsTable()
	--Маг:
	damageSpells[44614] = 1 	--Стрела ледяного огня
	damageSpells[122] = 2 		--Кольцо льда
	damageSpells[2136] = 1 		--Огненный взрыв
	damageSpells[120] = 1 		--Конус холода
	damageSpells[11366] = 1 	--Огненная глыба
	damageSpells[30451] = 1		--Чародейская вспышка
	damageSpells[116] = 1 		--Ледяная стрела
	damageSpells[133] = 1 		--Огненный шар
	damageSpells[2948] = 1 		--Ожог
	damageSpells[2120] = 1 		--Огненный столб
	damageSpells[114923] = 1 	--Буря Пустоты
	damageSpells[157981] = 1 	--Взрывная волна
	damageSpells[44457] = 1 	--Живая бомба
	damageSpells[157997] = 1 	--Кольцо обледенения
	damageSpells[157980] = 1 	--Сверхновая
	damageSpells[153595] = 2 	--Буря комет
	damageSpells[153561] = 2 	--Метеор
	damageSpells[153626] = 2 	--Чародейский шар
	
	absorbSpells[11426] = 1 	--Ледяная преграда
	absorbSpells[140468] = 1 	--Пламенное сияние
	
end

createABFrames()
createSpellsTable()