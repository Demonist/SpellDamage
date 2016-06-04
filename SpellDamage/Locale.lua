local L = {}
local locale = GetLocale()

L["daggers"] = "Daggers"
L["lightning_shield"] = "Lightning Shield"
L["frost_bomb"] = "Frost Bomb"
L["haunt"] = "Haunt"
L["dizzying_haze"] = "Dizzying Haze"
L["item_use"] = "Use"
L["holy_fire"] = "Holy Fire"
L["power_word_solace"] = "Power Word: Solace"

L["description_error"] = "Error by getting spell's description with"
L["parsing_spell_error"] = "Error by parsing spell with"
L["parsing_item_error"] = "Error by parsing item with"
L["type_spell_error"] = "Error by detecting spell type with"
L["type_item_error"] = "Error by detecting item type with"
L["too_many_errors"] = "|cFFffff00SpellDamage:|r |cFFff0000Too many errors.|r Errors display |cFFffc0c0disabled|r. But if you don't see them - it does not mean that they are not."
L["locale_error"] = "|cFFffff00SpellDamage|r addon can't work with NOT averaged values. Check 'Interface' settings, 'Display' tab, '|cFFffff00Display Point as Average|r' checkbox."
L["locale_error_fixed"] = "Excelent! Settings changed and |cFFffff00SpellDamage|r addon working again."
L["addon_off_language"] = "|cFFffff00SpellDamage|r addon is disabled becouse unsupported locale."
L["addon_off_average"] = "|cFFffff00SpellDamage|r addon is disabled becouse average values settings."

L["chat_items_on"] = "Display item's data |cFFc0ffc0enabled|r"
L["chat_items_off"] = "Display item's data |cFFffc0c0disabled|r"
L["chat_errors_on"] = "Errors display |cFFc0ffc0enabled|r"
L["chat_errors_off"] = "Errors display |cFFffc0c0disabled|r"
L["chat_auto_errors_on"] = "Auto off errors display |cFFc0ffc0enabled|r"
L["chat_auto_errors_off"] = "|cFFffff00SpellDamage:|r Auto off errors display |cFFffc0c0disabled|r"
L["macroshelp"] = "For display on macros just add |cFFffff00#sd <id>|r line to macros code. <id> - spell id to be displayed. For example, |cFFffff00#sd 56641|r will display Hunter's 'Steady Shot'."
L["chat_version"] = "version"
L["chat_settings"] = "|cFFffff00SpellDamage|r settings:"
L["chat_commands_list"] = "|cFFffff00SpellDamage|r commands:"
L["chat_command_status"] = "show current addon settings"
L["chat_command_items"] = "on/off display on items"
L["chat_command_errors"] = "on/off display errors in chat"
L["chat_command_help"] = "show addon macros help"
L["chat_command_font"] = "change the action bar font (UI will be automatically reloaded)"
L["chat_command_version"] = "show addon version"

--------------------------------   ruRU:   -------------------------------------

if locale == "ruRU" then
	L["daggers"] = "Кинжалы"
	L["lightning_shield"] = "Щит молний"
	L["frost_bomb"] = "Ледяная бомба"
	L["haunt"] = "Блуждающий дух"
	L["dizzying_haze"] = "Хмельная дымка"
	L["item_use"] = "Использование"
	L["holy_fire"] = "Священный огонь"
	L["power_word_solace"] = "Слово силы: Утешение"

	L["description_error"] = "Ошибка получения описания умения с"
	L["parsing_spell_error"] = "Ошибка парсинга умения с"
	L["parsing_item_error"] = "Ошибка парсинга предмета с"
	L["type_spell_error"] = "Ошибка определения типа умения с"
	L["type_item_error"] = "Ошибка определения типа предмета с"
	L["too_many_errors"] = "|cFFff0000Слишком много ошибок.|r Отображение ошибок |cFFffc0c0выключено|r. Но если вы их не видите - это не означает что их нет."
	L["locale_error"] = "Аддон |cFFffff00SpellDamage|r не может работать с НЕусредненными показателями. Зайдите в настройки интерфейса, изображение и установите галочку \"|cFFffff00Усредненные показатели|r\"."
	L["locale_error_fixed"] = "Отлично! Настройки изменены, аддон |cFFffff00SpellDamage|r вновь работает."
	L["addon_off_language"] = "Аддон |cFFffff00SpellDamage|r выключен из-за настроек языка."
	L["addon_off_average"] = "Аддон |cFFffff00SpellDamage|r не работает из-за настройки усредненных показателей."

	L["chat_items_on"] = "Отображение на предметах |cFFc0ffc0включено|r"
	L["chat_items_off"] = "Отображение на предметах |cFFffc0c0выключено|r"
	L["chat_errors_on"] = "Отображение ошибок |cFFc0ffc0включено|r"
	L["chat_errors_off"] = "Отображение ошибок |cFFffc0c0выключено|r"
	L["chat_auto_errors_on"] = "Авто выключение отображения ошибок |cFFc0ffc0включено|r"
	L["chat_auto_errors_off"] = "Авто выключение отображения ошибок |cFFffc0c0выключено|r"
	L["macroshelp"] = "Для отображение данных на макросах, необходимо в код макроса добавить строчку |cFFffff00#sd <id>|r, где <id> - идентификатор умения, данные которого необходимо отобразить. Например, |cFFffff00#sd 56641|r отобразит 'Верный выстрел' у охотника."
	L["chat_version"] = "версия"
	L["chat_settings"] = "|cFFffff00SpellDamage|r, текущие настройки:"
	L["chat_commands_list"] = "|cFFffff00SpellDamage|r, доступные команды:"
	L["chat_command_status"] = "отображает текущие настройки"
	L["chat_command_items"] = "включает или выключает показ значений на предметах"
	L["chat_command_errors"] = "включает или выключает отображение ошибок"
	L["chat_command_help"] = "отображает помощь по использованию аддона с макросами"
	L["chat_command_font"] = "меняет шрифт на панели умений (интерфейс будет автоматически перезагружен)"
	L["chat_command_version"] = "отображает текущую версию аддона"
end

--------------------------------   deDE:   -------------------------------------

if locale == "deDE" then
	L["daggers"] = "Dolche"
	L["lightning_shield"] = "Blitzschlagschild"
	L["frost_bomb"] = "Frostbombe"
	L["haunt"] = "Heimsuchung"
	L["dizzying_haze"] = "Benebelnde Dämpfe"
	L["item_use"] = "Benutzen"
	L["holy_fire"] = "Heiliges Feuer"
	L["power_word_solace"] = "Machtwort: Trost"
end

--------------------------------   esES:   -------------------------------------

if locale == "esES" then
	L["daggers"] = "Dagas"
	L["lightning_shield"] = "Escudo de relámpagos"
	L["frost_bomb"] = "Bomba de Escarcha"
	L["haunt"] = "Poseer"
	L["dizzying_haze"] = "Estupor mareante"
	L["item_use"] = "Uso"
	L["holy_fire"] = "Fuego Sagrado"
	L["power_word_solace"] = "Palabra de poder: consuelo"
end

--------------------------------   frFR:   -------------------------------------

if locale == "frFR" then
	L["daggers"] = "Dagues"
	L["lightning_shield"] = "Bouclier de foudre"
	L["frost_bomb"] = "Bombe de givre"
	L["haunt"] = "Hanter"
	L["dizzying_haze"] = "Brume vertigineuse"
	L["item_use"] = "Utilise"
	L["holy_fire"] = "Flammes sacrées"
	L["power_word_solace"] = "Mot de pouvoir : Réconfort"
end

--------------------------------   itIT:   -------------------------------------

if locale == "itIT" then
	L["daggers"] = "Pugnali"
	L["lightning_shield"] = "Scudo di Fulmini"
	L["frost_bomb"] = "Bomba del Gelo"
	L["haunt"] = "Tormento"
	L["dizzying_haze"] = "Ebbrezza"
	L["item_use"] = "Usa"
	L["holy_fire"] = "Fuoco Sacro"
	L["power_word_solace"] = "Parola del Potere: Conforto"
end

--------------------------------   ptBR:   -------------------------------------

if locale == "ptBR" then
	L["daggers"] = "Daggers"
	L["lightning_shield"] = "Escudo de Raios"
	L["frost_bomb"] = "Bomba Gélida"
	L["haunt"] = "Possessão"
	L["dizzying_haze"] = "Névoa Estonteante"
	L["item_use"] = "Uso"
	L["holy_fire"] = "Fogo Sagrado"
	L["power_word_solace"] = "Palavra de Poder: Consolo"
end

--------------------------------   zhCN:   -------------------------------------

if locale == "zhCN" then
	L["daggers"] = "匕首"
	L["lightning_shield"] = "闪电之盾"
	L["frost_bomb"] = "寒冰炸弹"
	L["haunt"] = "鬼影缠身"
	L["dizzying_haze"] = "迷醉酒雾"
	L["item_use"] = "使用"
	L["holy_fire"] = "神圣之火"
	L["power_word_solace"] = "真言术：慰"
end

--------------------------------   zhTW:   -------------------------------------

if locale == "zhTW" then
	L["daggers"] = "匕首"
	L["lightning_shield"] = "閃電之盾"
	L["frost_bomb"] = "冰霜炸彈"
	L["haunt"] = "蝕魂術"
	L["dizzying_haze"] = "微醺酒氣"
	L["item_use"] = "使用"
	L["holy_fire"] = "神聖之火"
	L["power_word_solace"] = "真言術:慰"
end

--------------------------------   koKR:   -------------------------------------

if locale == "koKR" then
	L["daggers"] = "단검"
	L["lightning_shield"] = "번개 보호막"
	L["frost_bomb"] = "냉기폭탄"
	L["haunt"] = "유령 출몰"
	L["dizzying_haze"] = "술안개"
	L["item_use"] = "사용 효과"
	L["holy_fire"] = "신성한 불꽃"
	L["power_word_solace"] = "신의 권능: 위안"
end

SD = {}
SD.L = L
