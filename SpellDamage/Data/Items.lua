local SleepingPotion = DoubleParser:create(SpellHealAndMana, 2, 3)
local HealAndMana = MultiParser:create(SpellHealAndMana, {1}, function(data, match)
	data.heal = match[1]
	data.mana = match[1]
end)
local TimeHealAndTimeMana = MultiParser:create(SpellHealAndMana, {1}, function(data, match)
	data.timeHeal = match[1]
	data.timeMana = match[1]
end)


Items = Class:create(ClassItems)

-- Зелья:

--Лечебное зелье(Предмет для сценария):
local HealingPotionScenario = MultiParser:create(SpelLHeal, {1}, function(data, match)
	data.heal = UnitHealthMax("player") * match[1] / 100
end)

Items.spells[118]		= SimpleHealParser								--Крохотный флакон с лечебным зельем
Items.spells[858]		= SimpleHealParser								--Маленький флакон с лечебным зельем
Items.spells[2455]		= SimpleManaParser								--Крохотный флакон с зельем маны
Items.spells[2456]		= DoubleParser:create(SpellHealAndMana, 2, 1)	--Слабое зелье омоложения
Items.spells[3087]		= SimpleManaParser								--Кружка "Мерцающего портера"
Items.spells[4596]		= SimpleHealParser								--Флакон с бесцветным лечебным зельем
Items.spells[6051]		= SimpleAbsorbParser							--Зелье защиты от светлой магии
Items.spells[929]		= SimpleHealParser 								--Лечебное зелье
Items.spells[3385]		= SimpleManaParser 								--Маленький флакон с зельем маны
Items.spells[6048]		= SimpleAbsorbParser 							--Зелье защиты от темной магии
Items.spells[1710]		= SimpleHealParser 								--Средний флакон с лечебным зельем
Items.spells[3827]		= SimpleManaParser 								--Зелье маны
Items.spells[6049]		= SimpleAbsorbParser 							--Зелье защиты от огня
Items.spells[6050]		= SimpleAbsorbParser 							--Зелье защиты от магии льда
Items.spells[6052]		= SimpleAbsorbParser 							--Зелье защиты от сил природы
Items.spells[6149]		= SimpleManaParser 								--Средний флакон с зельем маны
Items.spells[3928]		= SimpleHealParser 								--Большой флакон с лечебным зельем
Items.spells[9144] 		= DoubleHealManaParser 							--Зелье из дикой лозы
Items.spells[12190]		= SleepingPotion 								--Зелье сна без сновидений
Items.spells[17349]		= SimpleHealParser 								--Наилучшее исцеляющее зелье
Items.spells[17352]		= SimpleManaParser 								--Наилучшее зелье возврата маны
Items.spells[18839]		= SimpleHealParser 								--Флакон с боевым лечебным зельем
Items.spells[13443]		= SimpleManaParser 								--Большой флакон с зельем маны
Items.spells[18841]		= SimpleManaParser 								--Флакон с боевым зельем маны
Items.spells[13446]		= SimpleHealParser 								--Огромный флакон с лечебным зельем
Items.spells[17348]		= SimpleHealParser 								--Хорошее исцеляющее зелье
Items.spells[17351]		= SimpleManaParser 								--Хорошее зелье возврата маны
Items.spells[13456]		= SimpleAbsorbParser 							--Сильное зелье защиты от магии льда
Items.spells[13457]		= SimpleAbsorbParser 							--Сильное зелье защиты от огня
Items.spells[13458]		= SimpleAbsorbParser 							--Сильное зелье защиты от сил природы
Items.spells[13459]		= SimpleAbsorbParser 							--Сильное зелье защиты от темной магии
Items.spells[13460]		= SimpleAbsorbParser 							--Сильное зелье защиты от светлой магии
Items.spells[13461]		= SimpleAbsorbParser 							--Сильное зелье защиты от тайной магии
Items.spells[13444]		= SimpleManaParser 								--Огромный флакон с зельем маны
Items.spells[13506]		= SimpleAbsorbParser 							--Зелье оцепенения
Items.spells[18253]		= HealAndMana 									--Большое зелье омоложения
Items.spells[20002]		= SleepingPotion 								--Сильное зелье сна без сновидений
Items.spells[28100]		= SimpleHealParser 								--Флакон с летучим лечебным зельем
Items.spells[33934]		= SimpleHealParser 								--Хрустальный флакон с лечебным зельем
Items.spells[116277]	= SimpleAbsorbParser 							--Зелье оцепенения
Items.spells[28101]		= SimpleManaParser 								--Флакон с нестойким зельем маны
Items.spells[33935]		= SimpleManaParser 								--Хрустальный флакон с зельем маны
Items.spells[22829]		= SimpleHealParser 								--Гигантский флакон с лечебным зельем
Items.spells[32904]		= SimpleHealParser 								--Кенарийский лечебный бальзам
Items.spells[32905]		= SimpleHealParser 								--Бутилированные пары Хаотического зелья
Items.spells[32947]		= SimpleHealParser 								--Аукенайский флакон с лечебным зельем
Items.spells[39327]		= SimpleHealParser 								--Особое пойло Нота
Items.spells[43531]		= SimpleHealParser 								--Флакон с лечебным зельем Серебряного Рассвета
Items.spells[23822]		= SimpleHealParser 								--Набор для лечебных инъекций
Items.spells[33092]		= SimpleHealParser 								--Набор для лечебных инъекций
Items.spells[22832]		= SimpleManaParser 								--Гигантский флакон с зельем маны
Items.spells[32902]		= SimpleManaParser 								--Бутилированное хаотическое зелье энергии
Items.spells[32903]		= SimpleManaParser 								--Кенарийский бальзам маны
Items.spells[32948]		= SimpleManaParser 								--Аукенайский флакон с зельем маны
Items.spells[43530]		= SimpleManaParser 								--Флакон с зельем маны Серебряного Рассвета
Items.spells[23823]		= SimpleManaParser 								--Набор для инъекций маны
Items.spells[31676]		= SimpleTimeHealParser 							--Оскверненное зелье регенерации
Items.spells[33093]		= SimpleManaParser 								--Набор для инъекций маны
Items.spells[22836]		= SleepingPotion 								--Большое зелье сна без сновидений
Items.spells[22841]		= SimpleAbsorbParser 							--Большое зелье защиты от огня
Items.spells[22842]		= SimpleAbsorbParser 							--Большое зелье защиты от магии льда
Items.spells[22844]		= SimpleAbsorbParser 							--Большое зелье защиты от сил природы
Items.spells[22845]		= SimpleAbsorbParser 							--Большое зелье защиты от тайной магии
Items.spells[22846]		= SimpleAbsorbParser 							--Большое зелье защиты от темной магии
Items.spells[22847]		= SimpleAbsorbParser 							--Большое зелье защиты от светлой магии
Items.spells[31838]		= SimpleHealParser 								--Большой флакон с боевым лечебным зельем
Items.spells[31839]		= SimpleHealParser 								--Большой флакон с боевым лечебным зельем
Items.spells[31840]		= SimpleManaParser 								--Большой флакон с боевым зельем маны
Items.spells[31841]		= SimpleManaParser 								--Большой флакон с боевым зельем маны
Items.spells[31852]		= SimpleHealParser 								--Большой флакон с боевым лечебным зельем
Items.spells[31853]		= SimpleHealParser 								--Большой флакон с боевым лечебным зельем
Items.spells[31854]		= SimpleManaParser 								--Большой флакон с боевым зельем маны
Items.spells[31855]		= SimpleManaParser 								--Большой флакон с боевым зельем маны
Items.spells[32783]		= SimpleManaParser 								--Огрское Синее
Items.spells[32784]		= SimpleHealParser 								--Огрское Красное
Items.spells[32840]		= SimpleAbsorbParser 							--Большое зелье защиты от огня
Items.spells[32844]		= SimpleAbsorbParser 							--Большое зелье защиты от магии льда
Items.spells[32845]		= SimpleAbsorbParser 							--Большое зелье защиты от сил природы
Items.spells[32846]		= SimpleAbsorbParser 							--Большое зелье защиты от тайной магии
Items.spells[32847]		= SimpleAbsorbParser 							--Большое зелье защиты от темной магии
Items.spells[32909]		= SimpleManaParser 								--Огрское Особое синее
Items.spells[32910]		= SimpleHealParser 								--Огрское Особое красное
Items.spells[35287]		= SimpleManaParser 								--Сверкающий синехвост
Items.spells[31677]		= SimpleTimeManaParser 							--Оскверненное зелье маны
Items.spells[22850]		= HealAndMana 									--Гигантский флакон с зельем омоложения
Items.spells[34440]		= HealAndMana 									--Зелье безумного алхимика
Items.spells[39671]		= SimpleHealParser 								--Флакон с бодрящим лечебным зельем
Items.spells[40067]		= SimpleManaParser 								--Флакон с ледяным зельем маны
Items.spells[43569]		= SimpleHealParser 								--Бездонный флакон с лечебным зельем
Items.spells[43570]		= SimpleManaParser 								--Бездонный флакон с зельем маны
Items.spells[33447]		= SimpleHealParser 								--Рунический флакон с лечебным зельем
Items.spells[33448]		= SimpleManaParser 								--Рунический флакон с зельем маны
Items.spells[40077]		= DoubleHealManaParser 							--Зелье сумасшедшего алхимика
Items.spells[40081]		= HealAndMana 									--Зелье ночных кошмаров
Items.spells[40087]		= HealAndMana 									--Мощное зелье омоложения
Items.spells[40213]		= SimpleAbsorbParser 							--Мощное зелье защиты от тайной магии
Items.spells[40214]		= SimpleAbsorbParser 							--Мощное зелье защиты от огня
Items.spells[40215]		= SimpleAbsorbParser 							--Мощное зелье защиты от магии льда
Items.spells[40216]		= SimpleAbsorbParser 							--Мощное зелье защиты от сил природы
Items.spells[40217]		= SimpleAbsorbParser 							--Мощное зелье защиты от темной магии
Items.spells[41166]		= SimpleHealParser 								--Рунический набор для лечебных инъекций
Items.spells[42545]		= SimpleManaParser 								--Рунический набор для инъекций маны
Items.spells[57191]		= SimpleHealParser 								--Легендарное лечебное зелье
Items.spells[57192]		= SimpleManaParser 								--Легендарное зелье маны
Items.spells[63300]		= SimpleHealParser 								--Зелье разбойника
Items.spells[67415]		= DoubleHealManaParser 							--Глоток войны
Items.spells[57193]		= HealAndMana 									--Могучее зелье омоложения
--Items.spells[57099]	=  		--Загадочное зелье
Items.spells[57194]		= SimpleTimeManaParser 							--Зелье сосредоточения
Items.spells[63144]		= SimpleHealParser 								--Лечебное зелье защитников Тол Барада
Items.spells[63145]		= SimpleManaParser 								--Зелье маны защитников Тол Барада
Items.spells[64993]		= SimpleManaParser 								--Зелье маны батальона Адского Крика
Items.spells[64994]		= SimpleHealParser 								--Лечебное зелье батальона Адского Крика
Items.spells[76092]		= SimpleTimeManaParser 							--Зелье внимательности
Items.spells[76094]		= DoubleHealManaParser 							--Алхимическое зелье омоложения
Items.spells[76097]		= SimpleHealParser 								--Лечебное зелье мастера
Items.spells[76098]		= SimpleManaParser 								--Зелье маны мастера
Items.spells[92954]		= SimpleHealParser 								--Лечебное зелье бойца
Items.spells[93742]		= HealingPotionScenario 						--Лечебное зелье (Предмет для сценария)
Items.spells[113585]	= DoubleHealManaParser 							--Зелье омоложения Железной Орды
Items.spells[118278]	= SimpleTimeManaParser 							--Зелье кошмаров наяву
Items.spells[118917]	= SimpleHealParser 								--Дренорское бездонное лечебное снадобье буяна
Items.spells[109221]	= SimpleTimeManaParser 							--Дренорское зелье потока маны
Items.spells[109222]	= SimpleManaParser 								--Дренорское зелье маны
Items.spells[109223]	= SimpleHealParser 								--Лечебное снадобье
Items.spells[109226]	= DoubleHealManaParser 							--Дренорское зелье омоложения
Items.spells[115498]	= SimpleHealParser 								--Ашранское лечебное снадобье
Items.spells[117415]	= SimpleHealParser 								--Контрабандный тоник
Items.spells[118006]	= SimpleAbsorbParser 							--Щитотронный щит
Items.spells[118262]	= SimpleTimeManaParser 							--Бриллиантовый мечтоцвет
Items.spells[118916]	= SimpleHealParser 								--Лечебное снадобье буяна

-- Бинты:

Items.spells[8544]		= SimpleTimeHealParser 	--Бинты из магической ткани
Items.spells[6451]		= SimpleTimeHealParser 	--Плотные шелковые бинты
Items.spells[6450]		= SimpleTimeHealParser 	--Шелковые бинты
Items.spells[6531]		= SimpleTimeHealParser 	--Плотные шерстяные бинты
Items.spells[3530]		= SimpleTimeHealParser 	--Шерстяные бинты
Items.spells[2581]		= SimpleTimeHealParser 	--Плотные льняные бинты
Items.spells[1251]		= SimpleTimeHealParser 	--Льняные бинты
Items.spells[8545]		= SimpleTimeHealParser 	--Плотные бинты из магической ткани
Items.spells[20244]		= SimpleTimeHealParser 	--Шелковые бинты горца
Items.spells[20235]		= SimpleTimeHealParser 	--Шелковые бинты Осквернителя
Items.spells[20067]		= SimpleTimeHealParser 	--Шелковые бинты из Низины Арати
Items.spells[19068]		= SimpleTimeHealParser 	--Шелковые бинты из Ущелья Песни Войны
Items.spells[19067]		= SimpleTimeHealParser 	--Бинты Ущелья Песни Войны из магической ткани
Items.spells[20065]		= SimpleTimeHealParser 	--Бинты Низины Арати из магической ткани
Items.spells[20232]		= SimpleTimeHealParser 	--Бинты Осквернителя из магической ткани
Items.spells[20237]		= SimpleTimeHealParser 	--Бинты горца из магической ткани
Items.spells[14529]		= SimpleTimeHealParser 	--Бинты из рунической ткани
Items.spells[20243]		= SimpleTimeHealParser 	--Бинты горца из рунической ткани
Items.spells[20234]		= SimpleTimeHealParser 	--Бинты Осквернителя из рунической ткани
Items.spells[20066]		= SimpleTimeHealParser 	--Бинты из рунической ткани из Низины Арати
Items.spells[19066]		= SimpleTimeHealParser 	--Бинты из рунической ткани из Ущелья Песни Войны
Items.spells[14530]		= SimpleTimeHealParser 	--Плотные бинты из рунической ткани
Items.spells[19307]		= SimpleTimeHealParser 	--Плотные альтеракские бинты из рунической ткани
Items.spells[21990]		= SimpleTimeHealParser 	--Бинты из ткани Пустоты
Items.spells[21991]		= SimpleTimeHealParser 	--Плотные бинты из ткани Пустоты
Items.spells[34721]		= SimpleTimeHealParser 	--Бинты из ледяной ткани
Items.spells[34722]		= SimpleTimeHealParser 	--Плотные бинты из ледяной ткани
Items.spells[53049]		= SimpleTimeHealParser 	--Бинты из угольного шелка
Items.spells[53050]		= SimpleTimeHealParser 	--Плотные бинты из угольного шелка
Items.spells[53051]		= SimpleTimeHealParser 	--Крепкие бинты из угольного шелка
Items.spells[63391]		= SimpleTimeHealParser 	--Бинты защитников Тол Барада
Items.spells[94995]		= SimpleTimeHealParser 	--Бинты батальона Адского Крика
Items.spells[72985]		= SimpleTimeHealParser 	--Бинты из ветрошерсти
Items.spells[72986]		= SimpleTimeHealParser 	--Плотные бинты из ветрошерсти
Items.spells[111603]	= SimpleTimeHealParser 	--Пропитанные антисептиком бинты
Items.spells[115497]	= SimpleTimeHealParser 	--Ашранские бинты

--Разное:

--Воспламеняющая смесь:
local OilOfImmolation = MultiParser:create(SpellTimeDamage, {1, 3, 4}, function(data, match)
	data.timeDamage = match[1] * math.floor(match[4] / match[3])
end)
local GoblinDragonGunMarkII = OilOfImmolation

--Фрагмент духа стихии:
local ElementalFragment = MultiParser(SpelLHeal, {1}, function(data, match)
	data.heal = UnitHealthMax("player") * match[1] / 100
end)

Items.spells[1399]		= DoubleDamageParser 	--Волшебная свеча
Items.spells[1178]		= SimpleDamageParser 	--Взрывчатая ракета
Items.spells[5512]		= SimpleHealParser 		--Камень здоровья
Items.spells[6458]		= SimpleTimeHealParser 	--Рыба в масле
Items.spells[5205]		= SimpleTimeHealParser	--Росток папоротника
Items.spells[118699]	= OilOfImmolation		--Воспламеняющая смесь
Items.spells[8956]		= OilOfImmolation		--Воспламеняющая смесь
Items.spells[11952]		= DoubleParser:create(SpellHealAndMana, 2, 1)	--Дыхание ночного дракона
Items.spells[11950]		= SimpleTimeHealParser	--Ягоды ветроцвета
Items.spells[29531]		= TimeHealAndTimeMana	--Барабаны восстановления
Items.spells[49634]		= TimeHealAndTimeMana	--Барабаны дикой природы
Items.spells[86607]		= GoblinDragonGunMarkII	--Гоблинское драконье ружье, модель II
Items.spells[113545]	= SimpleManaParser 		--Резной рог для питья
Items.spells[115466]	= ElementalFragment 	--Фрагмент духа стихии