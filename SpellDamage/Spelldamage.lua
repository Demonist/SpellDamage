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
		if (button.textCenter) then
			button.textCenter:SetText("")
		end
		if button.textBottom then
			button.textBottom:SetText("")
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
				local num = damageSpells[id]
				if num ~= nil then
					ActionButton.textCenter:SetText(
						shortNumber(
							tonumber(
								matchIndex(GetSpellDescription(id), "%d+", num)
								)
							)
						)
				end

				num = healSpells[id]
				if num ~= nil then
					ActionButton.textBottom:SetText(
						shortNumber(
							tonumber(
								matchIndex(GetSpellDescription(id), "%d+", num)
								)
							)
						)
					ActionButton.textBottom:SetTextColor(0, 1, 0, 1)
				else
					num = absorbSpells[id]
					if num ~= nil then
						ActionButton.textBottom:SetText(
						shortNumber(
							tonumber(
								matchIndex(GetSpellDescription(id), "%d+", num)
								)
							)
						)
						ActionButton.textBottom:SetTextColor(1, 0.5, 1, 1)
					end
				end
			end
		end  
	end      
end

function shortNumber(number)
	if number >= 1000000 then
		return string.format("%.1fm", number / 1000000)
	elseif number >= 1000 then
		return string.format("%.1fk", number / 1000)
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
		ActionButton.textCenter = ActionButton:CreateFontString(nil, nil, "GameFontNormalLeft")
		ActionButton.textCenter:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		ActionButton.textCenter:SetPoint("CENTER" , 0, 0)	
		ActionButton.textCenter:SetPoint("LEFT", 0, 0)	
		ActionButton.textCenter:SetTextColor(1, 1, 0, 1)
		
		ActionButton.textBottom = ActionButton:CreateFontString(nil, nil, "GameFontNormalLeft")
		ActionButton.textBottom:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		ActionButton.textBottom:SetPoint("BOTTOM" , 0, 0)	
		ActionButton.textBottom:SetPoint("LEFT", 0, 0)	
		ActionButton.textBottom:SetTextColor(0, 1, 0, 1)
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
	
	healSpells[2136] = 1 		--Огненный взрыв

	absorbSpells[11426] = 1 	--Ледяная преграда
	absorbSpells[140468] = 1 	--Пламенное сияние

	--Жрец:
	damageSpells[585] = 1 		--Кара
	damageSpells[589] = 1 		--Слово Тьмы: Боль
	damageSpells[88625] = 1 	--Слово Света: Воздаяние
	damageSpells[15707] = 1 	--Пытка разума
	damageSpells[14914] = 1 	--Священный огонь
	damageSpells[8092] = 1 		--Взрыв разума
	damageSpells[48045] = 1 	--Иссушение разума
	damageSpells[34914] = 1 	--Прикосновение вампира
	damageSpells[78201] = 1 	--Сумеречный призрак
	damageSpells[73510] = 1 	--Пронзание разума
	damageSpells[129250] = 1 	--Слово силы: Утешение
	damageSpells[32379] = 1 	--Слово Тьмы: Смерть
	damageSpells[81209] = 2 	--Чакра: воздаяние ?
	damageSpells[122121] = 2 	--Божественная звезда
	damageSpells[155361] = 2 	--Энтропия Бездны

	healSpells[2061] = 1 		--Быстрое исцеление
	healSpells[88684] = 1 		--Слово Света: Безмятежность
	healSpells[2944] = 2 		--Всепожирающая чума
	healSpells[139] = 1 		--Обновление
	healSpells[2060] = 1 		--Исцеление
	healSpells[126135] = 3 		--Колодец Света
	healSpells[596] = 2 		--Молитва исцеления
	healSpells[32546] = 1 		--Связующее исцеление
	healSpells[34861] = 3 		--Круг исцеления
	healSpells[81206] = 2 		--Чакра: святилище
	healSpells[81208] = 1 		--Чакра: безмятежность ?
	healSpells[95649] = 1 		--Мгновенное обновление
	healSpells[33076] = 1 		--Молитва восстановления
	healSpells[64843] = 2 		--Божественный гимн
	healSpells[121135] = 1 		--Каскад
	healSpells[110740] = 2 		--Божественная звезда
	healSpells[152118] = 1 		--Ясность воли
	healSpells[155245] = 1 		--Ясная цель
	healSpells[152116] = 1 		--Спасительная сила
	
	absorbSpells[17] = 1 		--Слово силы: Щит

	--Охотник:
	damageSpells[3044] = 1 		--Чародейский выстрел
	damageSpells[56641] = 1 	--Верный выстрел
	damageSpells[117050] = 3 	--Бросок глеф
	damageSpells[109259] = 1 	--Мощный выстрел
	damageSpells[120360] = 1 	--Шквал
	damageSpells[152245] = 1 	--Сосредоточенный выстрел
	damageSpells[163485] = 1 	--Сосредоточенный выстрел
	
end

createABFrames()
createSpellsTable()