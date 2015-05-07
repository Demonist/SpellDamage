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
	damageSpells[11366] = 1 	--Огненная глыба
	damageSpells[30451] = 1		--Чародейская вспышка
	damageSpells[116] = 1 		--Ледяная стрела
	damageSpells[133] = 1 		--Огненный шар
	damageSpells[1449] = 1 		--Чародейский взрыв
	damageSpells[2948] = 1 		--Ожог
	damageSpells[30455] = 1 	--Ледяное копье
	damageSpells[108853] = 1 	--Пламенный взрыв
	damageSpells[5143] = 3 		--Чародейские стрелы
	damageSpells[120] = 1 		--Конус холода
	damageSpells[2120] = 1 		--Огненный столб
	damageSpells[10] = 1 		--Снежная буря
	damageSpells[31661] = 1 	--Дыхание дракона
	damageSpells[84714] = 1 	--Ледяной шар
	damageSpells[114923] = 1 	--Буря Пустоты
	damageSpells[157981] = 1 	--Взрывная волна
	damageSpells[44457] = 1 	--Живая бомба
	damageSpells[157997] = 1 	--Кольцо обледенения
	damageSpells[157980] = 1 	--Сверхновая
	damageSpells[153595] = 2 	--Буря комет
	damageSpells[153561] = 2 	--Метеор
	damageSpells[153626] = 2 	--Чародейский шар

	absorbSpells[11426] = 1 	--Ледяная преграда

	--Жрец:
	damageSpells[585] = 1 		--Кара
	damageSpells[589] = 1 		--Слово Тьмы: Боль
	damageSpells[47540] = 1 	--Исповедь
	damageSpells[15407] = 1 	--Пытка разума
	damageSpells[88625] = 1 	--Слово Света: Воздаяние
	damageSpells[14914] = 1 	--Священный огонь
	damageSpells[132157] = 1 	--Кольцо света
	damageSpells[8092] = 1 		--Взрыв разума
	damageSpells[2944] = 2 		--Всепожирающая чума
	damageSpells[34914] = 1 	--Прикосновение вампира
	damageSpells[48045] = 1 	--Иссушение разума
	damageSpells[73510] = 1 	--Пронзание разума
	damageSpells[129250] = 1 	--Слово силы: Утешение
	damageSpells[32379] = 1 	--Слово Тьмы: Смерть
	damageSpells[122121] = 2 	--Божественная звезда
	damageSpells[127632] = 1 	--Каскад
	damageSpells[120644] = 2 	--Сияние
	damageSpells[155361] = 2 	--Энтропия Бездны

	healSpells[2061] = 1 		--Быстрое исцеление
	healSpells[47540] = 2 		--Исповедь
	healSpells[132157] = 3 		--Кольцо света
	healSpells[88684] = 1 		--Слово Света: Безмятежность
	healSpells[139] = 1 		--Обновление
	healSpells[2060] = 1 		--Исцеление
	healSpells[126135] = 3 		--Колодец Света
	healSpells[596] = 2 		--Молитва исцеления
	healSpells[32546] = 1 		--Связующее исцеление
	healSpells[34861] = 3 		--Круг исцеления
	healSpells[33076] = 1 		--Молитва восстановления
	healSpells[64843] = 2 		--Божественный гимн
	healSpells[110744] = 2 		--Божественная звезда
	healSpells[121135] = 1 		--Каскад
	healSpells[120517] = 2 		--Сияние
	healSpells[152116] = 1 		--Спасительная сила
	healSpells[155245] = 1 		--Ясная цель
	healSpells[152118] = 1 		--Ясность воли
	
	absorbSpells[17] = 1 		--Слово силы: Щит

	--Охотник:
	damageSpells[3044] = 1 		--Чародейский выстрел
	damageSpells[56641] = 1 	--Верный выстрел
	damageSpells[34026] = 1 	--Команда "Взять!"
	damageSpells[19434] = 1 	--Прицельный выстрел
	damageSpells[53301] = 1 	--Разрывной выстрел
	damageSpells[2643] = 2 		--Залп
	damageSpells[53351] = 1 	--Убийственный выстрел
	damageSpells[13813] = 1 	--Взрывная ловушка
	damageSpells[3674] = 1 		--Черная стрела
	damageSpells[77767] = 1 	--Выстрел кобры
	damageSpells[117050] = 3 	--Бросок глеф
	damageSpells[109259] = 1 	--Мощный выстрел
	damageSpells[120360] = 2 	--Шквал
	damageSpells[152245] = 1 	--Сосредоточенный выстрел
	damageSpells[163485] = 1 	--Сосредоточенный выстрел

	--Воин:
	damageSpells[156287] = 1 	--Опустошитель
	damageSpells[176318] = 1 	--Стенолом – левая рука
	damageSpells[78] = 1 		--Удар героя
	damageSpells[145585] = 1 	--Удар громовержца левой рукой
	damageSpells[34428] = 1 	--Победный раж
	damageSpells[5308] = 1 		--Казнь
	damageSpells[163201] = 1 	--Казнь
	damageSpells[772] = 1 		--Кровопускание
	damageSpells[163558] = 1 	--Внезапная казнь
	damageSpells[23881] = 1 	--Кровожадность
	damageSpells[23922] = 1 	--Мощный удар щитом
	damageSpells[12294] = 1 	--Смертельный удар
	damageSpells[6343] = 2 		--Удар грома
	damageSpells[100130] = 1 	--Зверский удар
	damageSpells[57755] = 1 	--Героический бросок
	damageSpells[1680] = 2 		--Вихрь
	damageSpells[20243] = 1 	--Сокрушение
	damageSpells[103840] = 1 	--Верная победа
	damageSpells[6572] = 1 		--Реванш
	damageSpells[85288] = 1 	--Яростный выпад
	damageSpells[1715] = 1 		--Подрезать сухожилия
	damageSpells[1464] = 1 		--Мощный удар
	damageSpells[118000] = 1 	--Рев дракона
	damageSpells[107570] = 1 	--Удар громовержца
	damageSpells[46968] = 1 	--Ударная волна
	damageSpells[12328] = 1 	--Размашистые удары
	damageSpells[64382] = 1 	--Сокрушительный бросок
	damageSpells[167105] = 1 	--Удар колосса
	damageSpells[6544] = 2 		--Героический прыжок
	damageSpells[46924] = 2 	--Вихрь клинков
	damageSpells[152277] = 1 	--Опустошитель
	damageSpells[176289] = 1 	--Стенолом

	absorbSpells[174926] = 1 	--Непроницаемый щит
	
	--Друид:
	damageSpells[5176] = 1 		--Гнев
	damageSpells[8921] = 1 		--Лунный огонь
	damageSpells[164812] = 1 	--Лунный огонь
	damageSpells[1822] = 1 		--Глубокая рана
	damageSpells[5221] = 1 		--Полоснуть
	damageSpells[33917] = 1 	--Увечье
	damageSpells[2912] = 1 		--Звездный огонь
	damageSpells[6807] = 1 		--Трепка
	damageSpells[78674] = 1 	--Звездный поток
	damageSpells[164815] = 1 	--Солнечный огонь
	damageSpells[106785] = 1 	--Размах
	damageSpells[770] = 1 		--Волшебный огонь
	damageSpells[77758] = 2 	--Взбучка
	damageSpells[106830] = 2 	--Взбучка
	damageSpells[33745] = 1 	--Растерзать
	damageSpells[33831] = 3 	--Сила Природы
	damageSpells[102703] = 2 	--Сила Природы
	damageSpells[102706] = 1 	--Сила Природы
	damageSpells[48505] = 2 	--Звездопад
	damageSpells[152221] = 1 	--Звездная вспышка
	damageSpells[80313] = 2 	--Раздавить

	healSpells[774] = 1 		--Омоложение
	healSpells[18562] = 1 		--Быстрое восстановление
	healSpells[8936] = 1 		--Восстановление
	healSpells[5185] = 1 		--Целительное прикосновение
	healSpells[102351] = 2		--Щит Кенария
	healSpells[33763] = 1 		--Жизнецвет
	healSpells[102693] = 1 		--Сила Природы
	healSpells[740] = 1 		--Спокойствие
	healSpells[48438] = 3 		--Буйный рост
	healSpells[145205] = 4 		--Дикий гриб
	
end

createABFrames()
createSpellsTable()