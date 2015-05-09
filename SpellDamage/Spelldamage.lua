local buttons = {}

local classes = {}
local currentClass = nil
local emptyClass = Class:create()

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
function debug(msg)
	if debugFlag == true then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("UNIT_STATS")
EventFrame:RegisterEvent("UNIT_AURA")
EventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local _, className = UnitClass("player")
		currentClass = classes[className]
		if currentClass == nil then currentClass = emptyClass end
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIONBAR_SLOT_CHANGED" then
		for _, button in pairs(buttons) do
			button.centerText:SetText("")
			button.bottomText:SetText("")
		end
	end

	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_LOGIN" or event == "ACTIONBAR_SLOT_CHANGED"
		or (event == "UNIT_STATS" and select(1, ...) == "player")
		or (event == "UNIT_AURA" and select(1, ...) == "player") then
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
	classes["MAGE"] = Mage
end

local function createSpellsTable()
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

	--Монах:
	damageSpells[100780] = 1 	--Дзуки
	damageSpells[100787] = 1 	--Лапа тигра
	damageSpells[100784] = 1 	--Нокаутирующий удар
	damageSpells[113656] = 1 	--Неистовые кулаки
	damageSpells[121253] = 1 	--Удар бочонком
	damageSpells[115181] = 1 	--Пламенное дыхание
	damageSpells[101545] = 2 	--Удар летящего змея
	damageSpells[115098] = 1 	--Волна ци
	damageSpells[123986] = 2 	--Выброс ци
	damageSpells[124081] = 2 	--Сфера дзен
	damageSpells[101546] = 1 	--Танцующий журавль
	damageSpells[117952] = 1 	--Сверкающая нефритовая молния
	damageSpells[107428] = 1 	--Удар восходящего солнца
	damageSpells[116847] = 1 	--Порыв нефритового ветра
	damageSpells[123904] = 4 	--Призыв Сюэня, Белого Тигра
	damageSpells[152174] = 3 	--Взрыв ци
	damageSpells[157676] = 3 	--Взрыв ци
	damageSpells[152175] = 2 	--Ураганный удар
	
	healSpells[116645] = 1 		--Монастырские знания
	healSpells[115175] = 1 		--Успокаивающий туман
	healSpells[116694] = 1 		--Благотворный туман
	healSpells[124682] = 1 		--Окутывающий туман
	healSpells[115151] = 1 		--Заживляющий туман
	healSpells[115072] = 1 		--Устранение вреда
	healSpells[115098] = 2 		--Волна ци
	healSpells[123986] = 3 		--Выброс ци
	healSpells[124081] = 1 		--Сфера дзен
	healSpells[116670] = 1 		--Духовный подъем
	healSpells[15310] = 2 		--Восстановление сил
	healSpells[117907] = 3 		--Искусность: дар змеи
	healSpells[157675] = 3 		--Взрыв ци
	
	absorbSpells[115295] = 1 	--Защита
	absorbSpells[116849] = 1 	--Исцеляющий кокон

	--Паладин:
	damageSpells[35395] = 1 	--Удар воина Света
	damageSpells[20271] = 1 	--Правосудие
	damageSpells[85256] = 1 	--Вердикт храмовника
	damageSpells[20473] = 1 	--Шок небес
	damageSpells[31935] = 1 	--Щит мстителя
	damageSpells[119072] = 1 	--Гнев небес
	damageSpells[53595] = 1 	--Молот праведника
	damageSpells[53385] = 1 	--Божественная буря
	damageSpells[26573] = 1 	--Освящение
	damageSpells[24275] = 1 	--Молот гнева
	damageSpells[879] = 1 		--Экзорцизм
	damageSpells[114165] = 1 	--Божественная призма
	damageSpells[114158] = 4 	--Молот Света
	damageSpells[114157] = 1 	--Смертный приговор
	damageSpells[157048] = 1 	--Окончательный приговор
	
	healSpells[130552] = 2 		--Резкое слово
	healSpells[85673] = 2 		--Торжество
	healSpells[136494] = 2 		--Торжество
	healSpells[20473] = 2 		--Шок небес
	healSpells[19750] = 1 		--Вспышка Света
	healSpells[82327] = 1 		--Святое сияние
	healSpells[114163] = 1 		--Вечное пламя
	healSpells[82326] = 1 		--Свет небес
	healSpells[85222] = 4 		--Свет зари
	healSpells[114165] = 3 		--Божественная призма
	healSpells[114158] = 8 		--Молот Света
	healSpells[114157] = 3 		--Смертный приговор
	
	absorbSpells[20925] = 2 	--Священный щит
	absorbSpells[148039] = 2 	--Священный щит

	--Разбойник:
	damageSpells[1752] = 1 		--Коварный удар
	damageSpells[8676] = 1 		--Внезапный удар
	damageSpells[16511] = 1 	--Кровоизлияние
	damageSpells[1329] = 1 		--Расправа
	damageSpells[84617] = 1 	--Пробивающий удар
	damageSpells[53] = 1 		--Удар в спину
	damageSpells[111240] = 2 	--Устранение
	damageSpells[51723] = 2 	--Веер клинков
	damageSpells[154904] = 1 	--Внутреннее кровотечение
	damageSpells[114014] = 1 	--Бросок сюрикена
	damageSpells[152150] = 1 	--Смерть с небес

	--Рыцарь смерти:
	damageSpells[49184] = 1 	--Воющий ветер
	damageSpells[50842] = 1 	--Вскипание крови
	damageSpells[45477] = 1 	--Ледяное прикосновение
	damageSpells[47541] = 1 	--Лик смерти
	damageSpells[45462] = 1 	--Удар чумы
	damageSpells[55090] = 1 	--Удар Плети
	damageSpells[49020] = 1 	--Уничтожение
	damageSpells[43265] = 1 	--Смерть и разложение
	damageSpells[85948] = 1 	--Удар разложения
	damageSpells[108196] = 1 	--Смертельное поглощение
	damageSpells[114866] = 1 	--Жнец душ
	damageSpells[130735] = 1 	--Жнец душ
	damageSpells[130736] = 1 	--Жнец душ
	damageSpells[152279] = 1 	--Дыхание Синдрагосы
	damageSpells[152281] = 1 	--Мертвящая чума
	damageSpells[152280] = 2 	--Осквернение
	
	healSpells[47541] = 2 		--Лик смерти

	--Чернокнижник:
	damageSpells[686] = 1 		--Стрела Тьмы
	damageSpells[172] = 1 		--Порча
	damageSpells[689] = 1 		--Похищение жизни
	damageSpells[29722] = 1 	--Испепеление
	damageSpells[116858] = 1 	--Стрела Хаоса
	damageSpells[30108] = 1 	--Нестабильное колдовство
	damageSpells[17962] = 1 	--Поджигание
	damageSpells[348] = 1 		--Жертвенный огонь
	damageSpells[6353] = 1 		--Ожог души
	damageSpells[105174] = 1 	--Рука Гул'дана
	damageSpells[5740] = 1 		--Огненный ливень
	damageSpells[27243] = 1 	--Семя порчи
	damageSpells[1949] = 2 		--Адское пламя
	damageSpells[103103] = 1 	--Похищение души
	damageSpells[980] = 1 		--Агония
	damageSpells[17877] = 1 	--Ожог Тьмы
	damageSpells[48181] = 1 	--Блуждающий дух
	damageSpells[157695] = 1 	--Демонический заряд
	damageSpells[152108] = 1 	--Катаклизм

	--Шаман:
	damageSpells[403] = 1 		--Молния
	damageSpells[73899] = 1 	--Стихийный удар
	damageSpells[8042] = 1 		--Земной шок
	damageSpells[324] = 1 		--Щит молний
	damageSpells[60103] = 1 	--Вскипание лавы
	damageSpells[51490] = 1 	--Гром и молния
	damageSpells[8050] = 1 		--Огненный шок
	damageSpells[3599] = 5 		--Опаляющий тотем
	damageSpells[8056] = 1 		--Ледяной шок
	damageSpells[17364] = 1 	--Удар бури
	damageSpells[421] = 1 		--Цепная молния
	damageSpells[51505] = 1 	--Выброс лавы
	damageSpells[8190] = 4 		--Тотем магмы
	damageSpells[1535] = 2 		--Кольцо огня
	damageSpells[61882] = 2 	--Землетрясение
	damageSpells[117014] = 1 	--Удар духов стихии

	healSpells[8004] = 1 		--Исцеляющий всплеск
	healSpells[61295] = 1 		--Быстрина
	healSpells[974] = 2 		--Щит земли
	healSpells[5394] = 3 		--Тотем исцеляющего потока
	healSpells[1064] = 1 		--Цепное исцеление
	healSpells[77472] = 1 		--Волна исцеления
	healSpells[73920] = 1 		--Целительный ливень
	healSpells[108280] = 5 		--Тотем целительного прилива

	absorbSpells[18270] = 3 	--Тотем каменной преграды
end

createClasses()
createButtons()