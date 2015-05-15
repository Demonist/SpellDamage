--Удар бури:
local Stormstrike = MultiParser:create(SpellDamage, {1, 2}, function(data, match)
	data.damage = match[1] + match[2]
end)

--Тотем исцеляющего потока:
local HealingStreamTotem = MultiParser:create(SpellTimeHeal, {3}, function(data, match)
	data.timeHeal = match[3] * 7
end)

--Тотем магмы:
local MagmaTotem = MultiParser:create(SpellTimeDamage, {4}, function(data, match)
	data.timeDamage = match[3] * 30
end)

--Тотем целительного прилива:
local HealingTideTotem = MultiParser:create(SpellTimeHeal, {5}, function(data, match)
	data.timeHeal = match[5] * 5
end)

Shaman = Class:create()
Shaman.spells[403]		= SimpleDamageParser 		--Молния
Shaman.spells[73899]	= SimpleDamageParser 		--Стихийный удар
Shaman.spells[8042]		= SimpleDamageParser 		--Земной шок
Shaman.spells[8004]		= SimpleHealParser 			--Исцеляющий всплеск
Shaman.spells[61295]	= DoubleParser:create(SpellHealAndTimeHeal, 1, 2) 	--Быстрина
Shaman.spells[60103]	= SimpleDamageParser 		--Вскипание лавы
Shaman.spells[51490]	= SimpleDamageParser 		--Гром и молния
Shaman.spells[8050]		= DoubleDamageParser 		--Огненный шок
Shaman.spells[18270]	= SimpleParser:create(SpellAbsorb, 3) 				--Тотем каменной преграды
Shaman.spells[3599]		= SimpleParser:create(SpellDamage, 5) 				--Опаляющий тотем
Shaman.spells[8056]		= SimpleDamageParser 		--Ледяной шок
Shaman.spells[17364]	= Stormstrike 			 	--Удар бури
Shaman.spells[421]		= SimpleDamageParser 		--Цепная молния
Shaman.spells[5394]		= HealingStreamTotem 		--Тотем исцеляющего потока
Shaman.spells[51505]	= SimpleDamageParser 		--Выброс лавы
Shaman.spells[8190]		= MagmaTotem 				--Тотем магмы
Shaman.spells[1535]		= SimpleDamageParser2 		--Кольцо огня
Shaman.spells[1064]		= SimpleHealParser  		--Цепное исцеление
Shaman.spells[77472]	= SimpleHealParser 			--Волна исцеления
Shaman.spells[61882]	= SimpleTimeDamage2 	 	--Землетрясение
Shaman.spells[73920]	= SimpleTimeHealParser 		--Целительный ливень
Shaman.spells[108280]	= HealingTideTotem 			--Тотем целительного прилива
Shaman.spells[117014]	= SimpleDamageParser 	 	--Удар духов стихии
