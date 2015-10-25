function useDaggers()
	local slotId = GetInventorySlotInfo("MainHandSlot")
	if slotId then
		local mainHandLink = GetInventoryItemLink("player", slotId)
		if mainHandLink then
			local _, _, _, _, _, _, itemType = GetItemInfo(mainHandLink)
			if itemType == sdLocale["daggers"] then
				return true
			end
		end
	end
	return false
end


--Расправа:
local Mutilate = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1] + match[2]
end)

--Внезапный удар:
local Ambush = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	if useDaggers() == true then data.damage = match[1] + match[1] * match[2] / 100 
	else data.damage = match[1] end
end)

--Кровоизлияние:
local Hemorrhage = MultiParser:create(SpellDamage, {1, 2, 3}, function(data, match)
	if useDaggers() == true then data.damage = match[1] + match[1] * match[2] / 100
	else data.damage = match[1] end
	data.timeDamage = match[3]
end)

--Череда убийств:
local KillingSpree = MultiParser:create(SpellDamage, {3, 4}, function(data, match)
	data.damage = (match[3] + match[4]) * 7
end)

--Заживление ран:
local Recuperate = MultiParser:create(SpellTimeHeal, {1, 2}, function(data, match)
	local heal = match[1] * UnitHealthMax("player") / 100
	data.timeHeal = UnitPower("player", SPELL_COMBO_POINTS) * 2 * heal
end)

--Кровавый вихрь:
local CrimsonTempest = CustomParser:create(function(data, description)
	local timeMulpiplier = matchDigit(description, 2)
	local match = matchDigits(description, {5, 7, 9, 11, 13})
	local index = comboMatch({5, 7, 9, 11, 13})
	if timeMulpiplier and match then
		if index then
			data.type = SpellDamageAndTimeDamage
			data.damage = match[index]
			data.timeDamage = data.damage * timeMulpiplier / 100
		else
			data.type = SpellEmpty
		end
	end
end)

--Смерть с небес:
local DeathFromAbove = MultiParser:create(SpellDamage, {1}, function(data, match)
	data.damage = match[1]

	local eviscerateDescription = GetSpellDescription(2098)	--Потрошение
	if eviscerateDescription then
		local damageValues = matchDigits(eviscerateDescription, {2, 4, 6, 8, 10})
		local comboIndex = comboMatch({2, 4, 6, 8, 10})
		if damageValues and comboIndex then
			data.damage = data.damage + (damageValues[comboIndex] * 1.5)
		end
	end
end)

Rogue = Class:create(ClassSpells)
Rogue.dependFromPower = true
Rogue.dependPowerTypes["COMBO_POINTS"] = true
Rogue.spells[53]		= SimpleDamageParser 											--Удар в спину
Rogue.spells[703]		= SimpleTimeDamageParser										--Гаррота
Rogue.spells[1329]		= Mutilate 			 											--Расправа
Rogue.spells[1752]		= SimpleDamageParser 											--Коварный удар
Rogue.spells[1943]		= comboHelper(SpellTimeDamage, "timeDamage", {2, 5, 8, 11, 14}) --Рваная рана
Rogue.spells[2098]		= comboHelper(SpellDamage, "damage", {2, 4, 6, 8, 10})			--Потрошение
Rogue.spells[5938]		= SimpleDamageParser2											--Отравляющий укол
Rogue.spells[8676]		= Ambush 			 											--Внезапный удар
Rogue.spells[16511]		= Hemorrhage 			 										--Кровоизлияние
Rogue.spells[26679]		= comboHelper(SpellDamage, "damage", {4, 6, 8, 10, 12})			--Смертельный бросок
Rogue.spells[32645]		= comboHelper(SpellTimeDamage, "timeDamage", {3, 6, 9, 12, 15}) --Отравление
Rogue.spells[51690]		= KillingSpree 													--Череда убийств
Rogue.spells[51723]		= SimpleDamageParser2 											--Веер клинков
Rogue.spells[73651]		= Recuperate 													--Заживление ран
Rogue.spells[84617]		= SimpleDamageParser 											--Пробивающий удар
Rogue.spells[111240]	= SimpleDamageParser2 											--Устранение
Rogue.spells[114014]	= SimpleDamageParser 											--Бросок сюрикена
Rogue.spells[121411]	= CrimsonTempest												--Кровавый вихрь
Rogue.spells[152150]	= DeathFromAbove 												--Смерть с небес

-------------------------------------------------------------------------------

local locale = GetLocale()

if locale == "enGB" or locale == "enUS" then
	--Череда убийств:
	local KillingSpree_en = MultiParser:create(SpellDamage, {4, 5}, function(data, match)
		data.damage = (match[4] + match[5]) * 7
	end)

	Rogue.spells[703]		= SimpleTimeDamageParser2									--Гаррота
	Rogue.spells[51690]		= KillingSpree_en 											--Череда убийств
	return
end

if locale == "deDE" then
	--Кровоизлияние:
	local Hemorrhage_de = MultiParser:create(SpellDamage, {1, 2, 4}, function(data, match)
		if useDaggers() == true then data.damage = match[1] + match[1] * match[2] / 100
		else data.damage = match[1] end
		data.timeDamage = match[4]
	end)

	--Кровавый вихрь:
	local CrimsonTempest_de = CustomParser:create(function(data, description)
		local timeMulpiplier = matchDigit(description, 3)
		local match = matchDigits(description, {5, 7, 9, 11, 13})
		local index = comboMatch({5, 7, 9, 11, 13})
		if timeMulpiplier and match then
			if index then
				data.type = SpellDamageAndTimeDamage
				data.damage = match[index]
				data.timeDamage = data.damage * timeMulpiplier / 100
			else
				data.type = SpellEmpty
			end
		end
	end)

	--Смерть с небес:
	local DeathFromAbove_de = MultiParser:create(SpellDamage, {2}, function(data, match)
		data.damage = match[2]

		local eviscerateDescription = GetSpellDescription(2098)	--Потрошение
		if eviscerateDescription then
			local damageValues = matchDigits(eviscerateDescription, {2, 4, 6, 8, 10})
			local comboIndex = comboMatch({2, 4, 6, 8, 10})
			if damageValues and comboIndex then
				data.damage = data.damage + (damageValues[comboIndex] * 1.5)
			end
		end
	end)

	Rogue.spells[703]		= SimpleParser:create(SpellTimeDamage, 3)					--Гаррота
	Rogue.spells[16511]		= Hemorrhage_de 			 								--Кровоизлияние
	Rogue.spells[121411]	= CrimsonTempest_de											--Кровавый вихрь
	Rogue.spells[152150]	= DeathFromAbove_de 										--Смерть с небес
	return
end

if locale == "esES" then
	--Череда убийств:
	local KillingSpree_es = MultiParser:create(SpellDamage, {4, 5}, function(data, match)
		data.damage = (match[4] + match[5]) * 7
	end)

	Rogue.spells[703]		= SimpleTimeDamageParser2									--Гаррота
	Rogue.spells[51690]		= KillingSpree_es 											--Череда убийств
	return
end

if locale == "frFR" then
	--Череда убийств:
	local KillingSpree_fr = MultiParser:create(SpellDamage, {4, 5}, function(data, match)
		data.damage = (match[4] + match[5]) * 7
	end)

	Rogue.spells[703]		= SimpleTimeDamageParser2									--Гаррота
	Rogue.spells[51690]		= KillingSpree_fr 											--Череда убийств
	return
end

if locale == "itIT" then
	--Череда убийств:
	local KillingSpree_it = MultiParser:create(SpellDamage, {4, 5}, function(data, match)
		data.damage = (match[4] + match[5]) * 7
	end)

	Rogue.spells[703]		= SimpleTimeDamageParser2									--Гаррота
	Rogue.spells[51690]		= KillingSpree_it 											--Череда убийств
	return
end

if locale == "ptBR" then
	--Череда убийств:
	local KillingSpree_pt = MultiParser:create(SpellDamage, {4, 5}, function(data, match)
		data.damage = (match[4] + match[5]) * 7
	end)

	Rogue.spells[703]		= SimpleTimeDamageParser2									--Гаррота
	Rogue.spells[51690]		= KillingSpree_pt 											--Череда убийств
	return
end

if locale == "zhCN" then
	--Череда убийств:
	local KillingSpree_cn = MultiParser:create(SpellDamage, {4, 5}, function(data, match)
		data.damage = (match[4] + match[5]) * 7
	end)

	--Кровавый вихрь:
	local CrimsonTempest_cn = CustomParser:create(function(data, description)
		local timeMulpiplier = matchDigit(description, 3)
		local match = matchDigits(description, {5, 7, 9, 11, 13})
		local index = comboMatch({5, 7, 9, 11, 13})
		if timeMulpiplier and match then
			if index then
				data.type = SpellDamageAndTimeDamage
				data.damage = match[index]
				data.timeDamage = data.damage * timeMulpiplier / 100
			else
				data.type = SpellEmpty
			end
		end
	end)

	--Смерть с небес:
	local DeathFromAbove_cn = MultiParser:create(SpellDamage, {2}, function(data, match)
		data.damage = match[2]

		local eviscerateDescription = GetSpellDescription(2098)	--Потрошение
		if eviscerateDescription then
			local damageValues = matchDigits(eviscerateDescription, {2, 4, 6, 8, 10})
			local comboIndex = comboMatch({2, 4, 6, 8, 10})
			if damageValues and comboIndex then
				data.damage = data.damage + (damageValues[comboIndex] * 1.5)
			end
		end
	end)

	Rogue.spells[703]		= SimpleParser:create(SpellTimeDamage, 3)						--Гаррота
	Rogue.spells[1943]		= comboHelper(SpellTimeDamage, "timeDamage", {3, 6, 9, 12, 15}) --Рваная рана
	Rogue.spells[51690]		= KillingSpree_cn 												--Череда убийств
	Rogue.spells[121411]	= CrimsonTempest_cn												--Кровавый вихрь
	Rogue.spells[152150]	= DeathFromAbove_cn 											--Смерть с небес
	return
end
