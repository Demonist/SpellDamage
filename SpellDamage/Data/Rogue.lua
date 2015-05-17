--Кровоизлияние:
local Hemorrhage = DoubleParser:create(SpellDamageAndTimeDamage, 1, 3)

--Расправа:
local Mutilate = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1] + match[3]
end)

--Заживление ран:
local Recuperate = MultiParser:create(SpellTimeHeal, {1, 2}, function(data, match)
	local heal = match[1] * UnitHealthMax("player") / 100
	data.timeHeal = UnitPower("player", SPELL_COMBO_POINTS) * 2 * heal
end)

--Череда убийств:
local KillingSpree = MultiParser:create(SpellDamage, {3, 4}, function(data, match)
	data.damage = (match[3] + match[4]) * 7
end)

--Кровавый вихрь:
local CrimsonTempest = SpellParser:create()
function CrimsonTempest:getData(description)
	local data = SpellData:create(SpellUnknown)
	local timeMulpiplier = matchDigit(description, 2)
	local match = matchDigits(description, {5, 7, 9, 11, 13})
	local index = comboMatch({5, 7, 9, 11, 13})
	if timeMulpiplier ~= nil and match ~= nil and index ~= nil then
		data.type = SpellDamageAndTimeDamage
		data.damage = match[index]
		data.timeDamage = data.damage * timeMulpiplier / 100
	end
	return data
end

Rogue = Class:create()
Rogue.dependFromPower = true
Rogue.dependPowerTypes["COMBO_POINTS"] = true
Rogue.spells[1752]		= SimpleDamageParser 		--Коварный удар
Rogue.spells[2098]		= comboHelper(SpellDamage, "damage", {2, 4, 6, 8, 10})			--Потрошение
Rogue.spells[8676]		= SimpleDamageParser 		--Внезапный удар
Rogue.spells[16511]		= Hemorrhage 			 	--Кровоизлияние
Rogue.spells[1329]		= Mutilate 			 		--Расправа
Rogue.spells[73651]		= Recuperate 				--Заживление ран
Rogue.spells[32645]		= comboHelper(SpellTimeDamage, "timeDamage", {3, 6, 9, 12, 15}) --Отравление
Rogue.spells[84617]		= SimpleDamageParser 		--Пробивающий удар
Rogue.spells[26679]		= comboHelper(SpellDamage, "damage", {5, 7, 9, 11, 13})			--Смертельный бросок
Rogue.spells[53]		= SimpleDamageParser 		--Удар в спину
Rogue.spells[111240]	= SimpleDamageParser2 		--Устранение
Rogue.spells[1943]		= comboHelper(SpellTimeDamage, "timeDamage", {2, 5, 8, 11, 14}) --Рваная рана
Rogue.spells[703]		= SimpleTimeDamageParser	--Гаррота
Rogue.spells[51723]		= SimpleDamageParser2 		--Веер клинков
Rogue.spells[51690]		= KillingSpree 				--Череда убийств
Rogue.spells[121411]	= CrimsonTempest			--Кровавый вихрь
Rogue.spells[114014]	= SimpleDamageParser 		--Бросок сюрикена
Rogue.spells[152150]	= SimpleDamageParser 		--Смерть с небес