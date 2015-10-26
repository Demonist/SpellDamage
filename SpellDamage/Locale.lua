local L = []

local locale = GetLocale()

L["daggers"] = "Daggers"
L["lightning_shield"] = "Lightning Shield"
L["frost_bomb"] = "Frost Bomb"
L["haunt"] = "Haunt"
L["dizzying_haze"] = "Dizzying Haze"

L["item_use"] = "Use"
L["parsing_spell_error"] = "Error by parsing spell with"
L["parsing_item_error"] = "Error by parsing item with"
L["type_spell_error"] = "Error by detecting spell type with"
L["type_item_error"] = "Error by detecting item type with"
L["locale_error"] = "|cFFffff00SpellDamage|r addon can't work with NOT averaged values. Check 'Interface' settings, 'Display' tab, '|cFFffff00Average values|r' checkbox."
L["locale_error_fixed"] = "Excelent! Settings changed and |cFFffff00SpellDamage|r addon working again."
L["addon_off_language"] = "|cFFffff00SpellDamage|r addon is disabled becouse unsupported locale."
L["addon_off_average"] = "|cFFffff00SpellDamage|r addon is disabled becouse average values settings."

L["chat_help"] = "For display on macros just add |cFFffff00#sd <id>|r line to macros code. <id> - spell id to be displayed. For example, |cFFffff00#sd 56641|r will display Hunter's 'Steady Shot'."
L["chat_version"] = "version"
L["chat_settings"] = "|cFFffff00SpellDamage|r settings:"
L["chat_commands_list"] = "|cFFffff00SpellDamage|r commands:"
L["chat_command_status"] = "show current addon settings"
L["chat_command_items"] = "on/off display on items"
L["chat_command_errors"] = "on/off display errors in chat"
L["chat_command_help"] = "show addon macros help"
L["chat_command_version"] = "show addon version"

--------------------------------   ruRU   -------------------------------------

if locale == "ruRU" then
	L["daggers"] = "Кинжалы"
	L["lightning_shield"] = "Щит молний"
	L["frost_bomb"] = "Ледяная бомба"
	L["haunt"] = "Блуждающий дух"
	L["dizzying_haze"] = "Хмельная дымка"

	L["item_use"] = "Использование"
	L["parsing_spell_error"] = "Ошибка парсинга умения с"
	L["parsing_item_error"] = "Ошибка парсинга предмета с"
	L["type_spell_error"] = "Ошибка определения типа умения с"
	L["type_item_error"] = "Ошибка определения типа предмета с"
	L["locale_error"] = "Аддон |cFFffff00SpellDamage|r не может работать с НЕусредненными показателями. Зайдите в настройки интерфейса, изображение и установите галочку \"|cFFffff00Усредненные показатели|r\"."
	L["locale_error_fixed"] = "Отлично! Настройки изменены, аддон |cFFffff00SpellDamage|r вновь работает."
	L["addon_off_language"] = "Аддон |cFFffff00SpellDamage|r выключен из-за настроек языка."
	L["addon_off_average"] = "Аддон |cFFffff00SpellDamage|r не работает из-за настройки усредненных показателей."

	L["chat_help"] = "Для отображение данных на макросах, необходимо в код макроса добавить строчку |cFFffff00#sd <id>|r, где <id> - идентификатор умения, данные которого необходимо отобразить. Например, |cFFffff00#sd 56641|r отобразит 'Верный выстрел' у охотника."
	L["chat_version"] = "версия"
	L["chat_settings"] = "|cFFffff00SpellDamage|r, текущие настройки:"
	L["chat_commands_list"] = "|cFFffff00SpellDamage|r, доступные команды:"
	L["chat_command_status"] = "отображает текущие настройки"
	L["chat_command_items"] = "включает или выключает показ значений на предметах"
	L["chat_command_errors"] = "включает или выключает отображение ошибок"
	L["chat_command_help"] = "отображает помощь по использованию аддона с макросами"
	L["chat_command_version"] = "отображает текущую версию аддона"
end

--------------------------------   deDE   -------------------------------------

if locale == "deDE" then
	L["daggers"] = "Dolche"
	L["lightning_shield"] = "Blitzschlagschild"
	L["frost_bomb"] = "Frostbombe"
	L["haunt"] = "Heimsuchung"
	L["dizzying_haze"] = "Benebelnde Dämpfe"

	L["item_use"] = "Benutzen"
end

--------------------------------   esES   -------------------------------------

if locale == "esES" then
	L["daggers"] = "Dagas"
	L["lightning_shield"] = "Escudo de relámpagos"
	L["frost_bomb"] = "Bomba de Escarcha"
	L["haunt"] = "Poseer"
	L["dizzying_haze"] = "Estupor mareante"

	L["item_use"] = "Uso"
end

--------------------------------   frFR   -------------------------------------

if locale == "frFR" then
	L["daggers"] = "Dagues"
	L["lightning_shield"] = "Bouclier de foudre"
	L["frost_bomb"] = "Bombe de givre"
	L["haunt"] = "Hanter"
	L["dizzying_haze"] = "Brume vertigineuse"

	L["item_use"] = "Utilise"
end

--------------------------------   itIT   -------------------------------------

if locale == "itIT" then
	L["daggers"] = "Pugnali"
	L["lightning_shield"] = "Scudo di Fulmini"
	L["frost_bomb"] = "Bomba del Gelo"
	L["haunt"] = "Tormento"
	L["dizzying_haze"] = "Ebbrezza"

	L["item_use"] = "Usa"
end

--------------------------------   ptBR   -------------------------------------

if locale == "ptBR" then
	L["daggers"] = "Daggers"
	L["lightning_shield"] = "Escudo de Raios"
	L["frost_bomb"] = "Bomba Gélida"
	L["haunt"] = "Possessão"
	L["dizzying_haze"] = "Névoa Estonteante"

	L["item_use"] = "Uso"
end

--------------------------------   zhCN   -------------------------------------

if locale == "zhCN" then
	L["daggers"] = "匕首"
	L["lightning_shield"] = "闪电之盾"
	L["frost_bomb"] = "寒冰炸弹"
	L["haunt"] = "鬼影缠身"
	L["dizzying_haze"] = "迷醉酒雾"

	L["item_use"] = "使用"
end

sdLocale = L