local L = []

local locale = GetLocale()

L["daggers"] = "Daggers"
L["lightning_shield"] = "Lightning Shield"
L["frost_bomb"] = "Frost Bomb"

--------------------------------   ruRU   -------------------------------------

if locale == "ruRU" then
	L["daggers"] = "Кинжалы"
	L["lightning_shield"] = "Щит молний"
	L["frost_bomb"] = "Ледяная бомба"
	return
end

--------------------------------   deDE   -------------------------------------

if locale == "deDE" then
	L["daggers"] = "Dolche"
	L["lightning_shield"] = "Blitzschlagschild"
	L["frost_bomb"] = "Frostbombe"
	return
end

--------------------------------   esES   -------------------------------------

if locale == "esES" then
	L["daggers"] = "Dagas"
	L["lightning_shield"] = "Escudo de relámpagos"
	L["frost_bomb"] = "Bomba de Escarcha"
	return
end

--------------------------------   frFR   -------------------------------------

if locale == "frFR" then
	L["daggers"] = "Dagues"
	L["lightning_shield"] = "Bouclier de foudre"
	L["frost_bomb"] = "Bombe de givre"
	return
end

--------------------------------   itIT   -------------------------------------

if locale == "itIT" then
	L["daggers"] = "Pugnali"
	L["lightning_shield"] = "Scudo di Fulmini"
	L["frost_bomb"] = "Bomba del Gelo"
	return
end

--------------------------------   ptBR   -------------------------------------

if locale == "ptBR" then
	L["daggers"] = "Daggers"
	L["lightning_shield"] = "Escudo de Raios"
	L["frost_bomb"] = "Bomba Gélida"
	return
end

--------------------------------   zhCN   -------------------------------------

if locale == "zhCN" then
	L["daggers"] = "匕首"
	L["lightning_shield"] = "闪电之盾"
	L["frost_bomb"] = "寒冰炸弹"
	return
end

sdLocale = L