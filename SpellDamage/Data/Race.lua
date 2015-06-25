--Эльф крови, Волшебный поток:
local ArcaneTorrent = MultiParser:create(SpellMana, {3}, function(data, match)
	data.mana = match[3] * UnitManaMax("player") / 100
end)

--Дреней, Дар наару:
local GiftOfTheNaaru = MultiParser:create(SpellTimeMana, {1}, function(data, match)
	data.timeMana = match[1] * UnitHealthMax("player") / 100
end)

--Нежить, Каннибализм:
local Cannibalize = MultiParser:create(SpellTimeHealAndTimeMana, {1, 2, 3}, function(data, match)
	local times = match[3] / match[2]
	data.timeHeal = match[1] * UnitHealthMax("player") / 100 * times
	data.timeMana = match[1] * UnitManaMax("player") / 100 * times
end)

Race = Class:create(ClassSpells)
Race.spells[28730]	= ArcaneTorrent 						--Эльф крови, Волшебный поток
Race.spells[121093]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[28880]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59544]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59548]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59543]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59542]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59545]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[59547]	= GiftOfTheNaaru 						--Дреней, Дар наару
Race.spells[20577]	= Cannibalize 							--Нежить, Каннибализм
Race.spells[69041]	= SimpleParser:create(SpellDamage, 1) 	--Гоблин, Ракетный обстрел
