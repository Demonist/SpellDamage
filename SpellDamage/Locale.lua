local L = []

local locale = GetLocale()

L["daggers"] = "Daggers"
L["lightning_shield"] = "Lightning Shield"
L["frost_bomb"] = "Frost Bomb"
L["haunt"] = "Haunt"

--------------------------------   ruRU   -------------------------------------

if locale == "ruRU" then
	L["daggers"] = "Кинжалы"
	L["lightning_shield"] = "Щит молний"
	L["frost_bomb"] = "Ледяная бомба"
	L["haunt"] = "Блуждающий дух"
	return
end

--------------------------------   deDE   -------------------------------------

if locale == "deDE" then
	L["daggers"] = "Dolche"
	L["lightning_shield"] = "Blitzschlagschild"
	L["frost_bomb"] = "Frostbombe"
	L["haunt"] = "Heimsuchung"
	return
end

--------------------------------   esES   -------------------------------------

if locale == "esES" then
	L["daggers"] = "Dagas"
	L["lightning_shield"] = "Escudo de relámpagos"
	L["frost_bomb"] = "Bomba de Escarcha"
	L["haunt"] = "Poseer"
	return
end

--------------------------------   frFR   -------------------------------------

if locale == "frFR" then
	L["daggers"] = "Dagues"
	L["lightning_shield"] = "Bouclier de foudre"
	L["frost_bomb"] = "Bombe de givre"
	L["haunt"] = "Hanter"
	return
end

--------------------------------   itIT   -------------------------------------

if locale == "itIT" then
	L["daggers"] = "Pugnali"
	L["lightning_shield"] = "Scudo di Fulmini"
	L["frost_bomb"] = "Bomba del Gelo"
	L["haunt"] = "Tormento"
	return
end

--------------------------------   ptBR   -------------------------------------

if locale == "ptBR" then
	L["daggers"] = "Daggers"
	L["lightning_shield"] = "Escudo de Raios"
	L["frost_bomb"] = "Bomba Gélida"
	L["haunt"] = "Possessão"
	return
end

--------------------------------   zhCN   -------------------------------------

if locale == "zhCN" then
	L["daggers"] = "匕首"
	L["lightning_shield"] = "闪电之盾"
	L["frost_bomb"] = "寒冰炸弹"
	L["haunt"] = "鬼影缠身"
	return
end

sdLocale = L