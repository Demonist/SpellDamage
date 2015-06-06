--Пламенный взрыв:
local InfernoBlast = MultiParser:create(SpellDamage, {1}, function(data, match)
	data.damage = match[1] * 2
end)

--Прилив сил:
local Evocation = MultiParser:create(SpellManaAndTimeMana, {1, 2}, function(data, match)
	local maxMana = UnitManaMax("player")
	data.mana = match[1] * maxMana / 100
	data.timeMana = match[2] * maxMana / 100
end)

Mage = Class:create()
Mage.spells[44614]		= SimpleDamageParser					--Стрела ледяного огня
Mage.spells[122]		= SimpleDamageParser2					--Кольцо льда
Mage.spells[2136]		= SimpleDamageParser					--Огненный взрыв
Mage.spells[11366]		= DoubleDamageParser					--Огненная глыба
Mage.spells[30451]		= SimpleDamageParser					--Чародейская вспышка
Mage.spells[116]		= SimpleDamageParser 					--Ледяная стрела
Mage.spells[133]		= SimpleDamageParser				 	--Огненный шар
Mage.spells[44425]		= SimpleDamageParser					--Чародейский обстрел
Mage.spells[1449]		= SimpleDamageParser 					--Чародейский взрыв
Mage.spells[2948]		= SimpleDamageParser 					--Ожог
Mage.spells[30455]		= SimpleDamageParser 					--Ледяное копье
Mage.spells[108853]		= InfernoBlast 							--Пламенный взрыв
Mage.spells[5143]		= SimpleParser:create(SpellDamage, 3) 	--Чародейские стрелы
Mage.spells[120]		= SimpleDamageParser				 	--Конус холода
Mage.spells[11426]		= SimpleAbsorbParser 					--Ледяная преграда
Mage.spells[12051]		= Evocation 							--Прилив сил
Mage.spells[2120]		= DoubleDamageParser					--Огненный столб
Mage.spells[10]			= SimpleTimeDamageParser 				--Снежная буря
Mage.spells[31661]		= SimpleDamageParser 					--Дыхание дракона
Mage.spells[84714]		= SimpleTimeDamageParser 				--Ледяной шар
Mage.spells[114923]		= SimpleTimeDamageParser 				--Буря Пустоты
Mage.spells[157981]		= SimpleDamageParser 				 	--Взрывная волна
Mage.spells[44457]		= SimpleTimeDamageParser 			 	--Живая бомба
Mage.spells[157997]		= SimpleDamageParser 				 	--Кольцо обледенения
Mage.spells[157980]		= SimpleDamageParser 				 	--Сверхновая
Mage.spells[153595]		= SimpleDamageParser2				 	--Буря комет
Mage.spells[153561]		= SimpleDamageParser2				 	--Метеор
Mage.spells[153626]		= SimpleDamageParser2				 	--Чародейский шар