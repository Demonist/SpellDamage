local L, shortNumber, matchDigit, matchDigits, printTable, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex, AverageDamage = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex, SD.AverageDamage
local Glyphs = SD.Glyphs

--

local Monk = Class:create(ClassSpells)
Monk.dependFromTarget = true
SD.classes["MONK"] = Monk

function Monk:init()
	--Призыв Сюэня, Белого Тигра:
	local InvokeXuenTheWhiteTiger = function(data)
		data.timeDamage = data.timeDamage * 45
	end

	--Пламенное дыхание:
	local BreathOfFire = function(data)
		if UnitExists("target") and UnitDebuff("target", L["keg_smash"]) then 	--Удар бочонком
			data.type = SpellDamageAndTimeDamage
		else
			data.type = SpellDamage
		end
	end

	--Лапа тигра:
	local TigerPalm = function(data)
		if IsPlayerSpell(196607) then 	--Глаз тигра
			local eyeOfTheTigerDescr = GetSpellDescription(196607)
			if eyeOfTheTigerDescr then
				local match = matchDigit(eyeOfTheTigerDescr, getLocaleIndex({ru=2, en=1, de=1, es=1, fr=1, it=1, pt=1, kr=1}))
				if match then
					data.type = SpellDamageAndTimeDamage
					data.timeDamage = match
				end
			end
		end
	end

	--Смертельное касание:
	local TouchOfDeath = function(data)
		data.type = SpellDamage
		data.damage = UnitHealthMax("player")
	end

	--Целебный эликсир:
	local HealingElixir = function(data)
		data.type = SpellHeal
		data.heal = UnitHealthMax("player") * 0.15
	end


	self.spells[196743]	= TimeDamage({ru=2}) 															--Сгусток ци
	self.spells[152175]	= Damage({ru=1}) 																--Удар крутящегося дракона
	self.spells[196725]	= TimeHeal({ru=1, de=4, cn=4, kr=4}) 											--Освежающий нефритовый ветер
	self.spells[116847]	= TimeDamage({ru=1, de=3, cn=3, kr=3}) 											--Порыв нефритового ветра
	self.spells[123904]	= TimeDamage({ru=1}, InvokeXuenTheWhiteTiger) 									--Призыв Сюэня, Белого Тигра
	self.spells[198664]	= TimeHeal({ru=2}) 																--Призыв Чи-Цзи, Красного Журавля
	self.spells[115098]	= DamageAndHeal({ru={1,2}}) 													--Волна ци
	self.spells[123986]	= DamageAndHeal({ru={2,3}}) 													--Выброс ци
	self.spells[124081]	= DamageAndHeal({ru={1,3}, de={2,3}, cn={2,3}, kr={2,3}}) 						--Дзен-импульс
	self.spells[197945]	= Heal({ru=1}) 																	--Странник туманов
	self.spells[101546]	= TimeDamage({ru=1, de=2, cn=3, kr=3}) 											--Танцующий журавль
	self.spells[115151]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 											--Заживляющий туман
	self.spells[116849]	= Absorb({ru=2}) 																--Исцеляющий кокон
	self.spells[191837]	= HealAndTimeHeal({ru={5,6}, de={5,7}, cn={5,7}, kr={5,7}}) 					--Купель сущности
	self.spells[205523]	= Damage({ru=1}) 																--Нокаутирующая атака
	self.spells[116670]	= Heal({ru=1, en=2}) 															--Оживить
	self.spells[124682]	= TimeHeal({ru=1}) 																--Окутывающий туман
	self.spells[115181]	= DamageAndTimeDamage({ru={1,2}, de={1,3}, cn={1,3}, kr={1,3}}, BreathOfFire) 	--Пламенное дыхание
	self.spells[220357]	= TimeDamage({ru=1, de=2, cn=3, kr=3}) 											--Порывы вихря
	self.spells[107428]	= Damage({ru=1}) 																--Удар восходящего солнца
	self.spells[101545]	= Damage({ru=2, de=3, cn=3, kr=3}) 												--Удар летящего змея
	self.spells[214326]	= Damage({ru=1}) 																--Взрывной бочонок
	self.spells[205406]	= Heal({ru=1}) 																	--Дар Шей-луна
	self.spells[100780]	= Damage({ru=1}, TigerPalm) 													--Лапа тигра
	self.spells[100784]	= Damage({ru=1}) 																--Нокаутирующий удар
	self.spells[117952]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 											--Сверкающая нефритовая молния
	self.spells[205320]	= Damage({ru=1}) 																--Удар Владыки Ветра
	self.spells[205414]	= self.spells[205320] 															--Удар Владыки Ветра
	self.spells[222029]	= self.spells[205320] 															--Удар Владыки Ветра
	self.spells[209525]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 											--Успокаивающий туман
	self.spells[115080]	= Custom(TouchOfDeath) 															--Смертельное касание
	self.spells[116694]	= Heal({ru=1}) 																	--Излияние
	self.spells[113656]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 											--Неистовые кулаки
	self.spells[122281]	= Custom(HealingElixir) 														--Целебный эликсир
	self.spells[121253]	= Damage({ru=1, de=2, cn=2, kr=2}) 												--Удар бочонком
	self.spells[115310]	= Heal({ru=2, es=1, fr=1, pt=1}) 												--Восстановление сил
end
