local L, shortNumber, matchDigit, matchDigits, printTable, strstarts, Buff, Debuff = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.strstarts, SD.Buff, SD.Debuff
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex
local Glyphs = SD.Glyphs

--

local DeathKnight = Class:create(ClassSpells)
DeathKnight.dependFromPower = true
DeathKnight.dependPowerTypes["SPELL_POWER_RUNIC_POWER"] = true
SD.classes["DEATHKNIGHT"] = DeathKnight

function DeathKnight:init()
	--Буря костей:
	local Bonestorm = function(data)
		data.type = SpellTimeDamageAndTimeHeal
		local power = UnitPowerMax("player")
		if power > 10 then
			if power > 100 then power = 100; end
			local ticks = math.floor(power / 10)
			data.timeDamage = data.timeDamage * ticks
			data.timeHeal = UnitHealthMax("player") * 0.02 * ticks
		else
			data.timeHeal = UnitHealthMax("player") * 0.02
		end
	end

	--Дыхание Синдрагосы:
	local BreathOfSindragosa = function(data)
		data.timeDamage = data.timeDamage * (UnitPowerMax("player") / 13 + 1)
	end

	--Кровопийца:
	local Blooddrinker = function(data)
		data.type = SpellTimeDamageAndTimeHeal
		data.timeHeal = data.timeDamage
	end

	--Увядание:
	local Consumption = function(data)
		data.type = SpellDamageAndHeal
		data.heal = data.damage
	end

	--Алчущее руническое оружие:
	local HungeringRuneWeapon = function(data)
		data.type = SpellTimeMana
		data.timeMana = data.mana * 10
	end
	
	--Удар смерти:
	local DeathStrike = function(data)
		data.type = SpellDamageAndHeal
		data.heal = UnitHealthMax("player") * 0.1
	end

--Смертельный союз:
	local DeathPact = function(data, match)		
		data.heal = UnitHealthMax("player") * (match / 100)
	end


	self.spells[194844]	= TimeDamage({ru=1, en=2, de=3, es=2, fr=2, it=2, pt=2, cn=2, kr=3}, Bonestorm) 		--Буря костей
	self.spells[152279]	= TimeDamage({ru=1, de=2, cn=2, kr=2}, BreathOfSindragosa) 								--Дыхание Синдрагосы
	self.spells[130736]	= Damage({ru=1}) 																		--Жнец душ
	self.spells[194913]	= Damage({ru=1}) 																		--Ледяной натиск
	self.spells[152280]	= TimeDamage({ru=2, en=1, de=2, es=1, fr=1, it=1, pt=1, cn=2, kr=2}) 					--Осквернение
	self.spells[207230]	= Damage({ru=1}) 																		--Ледяная коса
	self.spells[207311]	= Damage({ru=1}) 																		--Стискивающие тени
	self.spells[207317]	= Damage({ru=1}) 																		--Эпидемия
	self.spells[206931]	= TimeDamage({ru=1, de=2, cn=2, kr=2}, Blooddrinker) 									--Кровопийца
	self.spells[43265]	= TimeDamage({ru=1, de=2, cn=2}) 														--Смерть и разложение
	self.spells[196770]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 													--Беспощадность зимы
	self.spells[49184]	= Damage({ru=1}) 																		--Воющий ветер
	self.spells[50842]	= Damage({ru=1}) 																		--Вскипание крови
	self.spells[77575]	= Damage({ru=1}) 																		--Вспышка болезни
	self.spells[195182]	= Damage({ru=1}) 																		--Дробление хребта
	self.spells[49143]	= Damage({ru=1}) 																		--Ледяной удар
	self.spells[47541]	= Damage({ru=1}) 																		--Лик смерти
	self.spells[195292]	= Damage({ru=1}) 																		--Прикосновение смерти
	self.spells[206930]	= Damage({ru=1, en=2, fr=2, it=2, pt=2, cn=2}) 											--Удар в сердце
	self.spells[55090]	= DamageAndDamage({ru={1,2}}) 															--Удар Плети
	self.spells[85948]	= Damage({ru=1}) 																		--Удар разложения
	self.spells[49020]	= Damage({ru=1}) 																		--Уничтожение
	self.spells[48707]	= Absorb({ru=2}) 																		--Антимагический панцирь
	self.spells[220143]	= Damage({ru=1}) 																		--Апокалипсис
	self.spells[190780]	= Damage({ru=1}) 																		--Ледяное дыхание
	self.spells[55095]	= TimeDamage({ru=1, de=2, cn=2, kr=2}) 													--Озноб
	self.spells[205223]	= Damage({ru=1}, Consumption) 															--Увядание
	self.spells[274156]	= Damage({ru=1}, Consumption)															--Пожирание
	self.spells[205224]	= self.spells[190778]																	--Пожирание
	self.spells[49998]	= Damage({ru=1}, DeathStrike) 															--Удар смерти
	self.spells[190778]	= Damage({ru=2, es=1}) 																	--Ярость Синдрагосы
	self.spells[279302]	= self.spells[190778] 																	--Ярость ледяного змея
	self.spells[57330]	= Mana({ru=2})		 																	--Зимний горн
	self.spells[47568]	= Mana({ru=1})		 																	--Усиление рунического оружия
	self.spells[207127]	= Mana({ru=2, en=2, de=4, es=2, fr=2, it=2, pt=2, cn=2, kr=4}, HungeringRuneWeapon)		--Алчущее руническое оружие
	self.spells[210764]	= Damage({ru=1})		 																--Рунический удар 
	self.spells[115989]	= Damage({ru=2, de=3, cn=3}) 															--Нечестивая порча
	self.spells[48743]	= Heal({ru=1}, DeathPact) 																--Смертельный союз
end
