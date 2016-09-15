local L = {}
local locale = GetLocale()

L["flame_shock"] = "Flame Shock"
L["lightning_rod"] = "Lightning Rod"
L["conflagration"] = "Conflagration"
L["fingers_of_frost"] = "Fingers of Frost"
L["keg_smash"] = "Keg Smash"

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
L["addon_off_version"] = "|cFFffff00SpellDamage|r addon is disabled becouse it's not compatible with this WOW version."

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
	L["flame_shock"] = "Огненный шок"
	L["lightning_rod"] = "Грозовой разрядник"
	L["conflagration"] = "Воспламенение"
	L["fingers_of_frost"] = "Ледяные пальцы"
	L["keg_smash"] = "Удар бочонком"

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
	L["addon_off_version"] = "|cFFffff00SpellDamage|r не работает из-за несовместимости с данной версией WOW."

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
	L["flame_shock"] = "Flammenschock"
	L["lightning_rod"] = "Blitzableiter"
	L["conflagration"] = "Großbrand"
	L["fingers_of_frost"] = "Eisige Finger"
	L["keg_smash"] = "Fasshieb"
end

--------------------------------   esES:   -------------------------------------

if locale == "esES" then
	L["flame_shock"] = "Choque de llamas"
	L["lightning_rod"] = "Pararrayos"
	L["conflagration"] = "Conflagración"
	L["fingers_of_frost"] = "Dedos de Escarcha"
	L["keg_smash"] = "Embate con barril"
end

--------------------------------   frFR:   -------------------------------------

if locale == "frFR" then
	L["flame_shock"] = "Horion de flammes"
	L["lightning_rod"] = "Paratonnerre"
	L["conflagration"] = "Déflagration"
	L["fingers_of_frost"] = "Doigts de givre"
	L["keg_smash"] = "Fracasse-tonneau"
end

--------------------------------   itIT:   -------------------------------------

if locale == "itIT" then
	L["flame_shock"] = "Folgore del Fuoco"
	L["lightning_rod"] = "Parafulmine"
	L["conflagration"] = "Pirocombustione"
	L["fingers_of_frost"] = "Dita di Gelo"
	L["keg_smash"] = "Lancio del Barile"
end

--------------------------------   ptBR:   -------------------------------------

if locale == "ptBR" then
	L["flame_shock"] = "Choque Flamejante"
	L["lightning_rod"] = "Para-raios"
	L["conflagration"] = "Conflagração"
	L["fingers_of_frost"] = "Dedos Glaciais"
	L["keg_smash"] = "Pancada de Barril"
end

--------------------------------   zhCN:   -------------------------------------

if locale == "zhCN" then
	L["flame_shock"] = "烈焰震击"
	L["lightning_rod"] = "引雷针"
	L["conflagration"] = "洪荒烈火"
	L["fingers_of_frost"] = "寒冰指"
	L["keg_smash"] = "醉酿投"
end

--------------------------------   koKR:   -------------------------------------

if locale == "koKR" then
	L["flame_shock"] = "화염 충격"
	L["lightning_rod"] = "피뢰침"
	L["conflagration"] = "거대한 불길"
	L["fingers_of_frost"] = "서리의 손가락"
	L["keg_smash"] = "맥주통 휘두르기"
end

SD = {}
SD.L = L
