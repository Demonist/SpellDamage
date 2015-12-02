local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex

--

local Items = Class:create(ClassItems)
SD.Items = Items

-- Зелья:

Items.spells[118]		= Heal({ru=1})								--Крохотный флакон с лечебным зельем
Items.spells[858]		= Heal({ru=1})								--Маленький флакон с лечебным зельем
Items.spells[2455]		= Mana({ru=1})								--Крохотный флакон с зельем маны
Items.spells[3087]		= Mana({ru=1})								--Кружка "Мерцающего портера"
Items.spells[4596]		= Heal({ru=1})								--Флакон с бесцветным лечебным зельем
Items.spells[6051]		= Absorb({ru=1})							--Зелье защиты от светлой магии
Items.spells[929]		= Heal({ru=1}) 								--Лечебное зелье
Items.spells[3385]		= Mana({ru=1}) 								--Маленький флакон с зельем маны
Items.spells[6048]		= Absorb({ru=1}) 							--Зелье защиты от темной магии
Items.spells[1710]		= Heal({ru=1}) 								--Средний флакон с лечебным зельем
Items.spells[3827]		= Mana({ru=1}) 								--Зелье маны
Items.spells[6049]		= Absorb({ru=1}) 							--Зелье защиты от огня
Items.spells[6050]		= Absorb({ru=1}) 							--Зелье защиты от магии льда
Items.spells[6052]		= Absorb({ru=1}) 							--Зелье защиты от сил природы
Items.spells[6149]		= Mana({ru=1}) 								--Средний флакон с зельем маны
Items.spells[3928]		= Heal({ru=1}) 								--Большой флакон с лечебным зельем
Items.spells[17349]		= Heal({ru=1}) 								--Наилучшее исцеляющее зелье
Items.spells[17352]		= Mana({ru=1}) 								--Наилучшее зелье возврата маны
Items.spells[18839]		= Heal({ru=1}) 								--Флакон с боевым лечебным зельем
Items.spells[13443]		= Mana({ru=1}) 								--Большой флакон с зельем маны
Items.spells[18841]		= Mana({ru=1}) 								--Флакон с боевым зельем маны
Items.spells[13446]		= Heal({ru=1}) 								--Огромный флакон с лечебным зельем
Items.spells[17348]		= Heal({ru=1}) 								--Хорошее исцеляющее зелье
Items.spells[17351]		= Mana({ru=1}) 								--Хорошее зелье возврата маны
Items.spells[13456]		= Absorb({ru=1}) 							--Сильное зелье защиты от магии льда
Items.spells[13457]		= Absorb({ru=1}) 							--Сильное зелье защиты от огня
Items.spells[13458]		= Absorb({ru=1}) 							--Сильное зелье защиты от сил природы
Items.spells[13459]		= Absorb({ru=1}) 							--Сильное зелье защиты от темной магии
Items.spells[13460]		= Absorb({ru=1}) 							--Сильное зелье защиты от светлой магии
Items.spells[13461]		= Absorb({ru=1}) 							--Сильное зелье защиты от тайной магии
Items.spells[13444]		= Mana({ru=1}) 								--Огромный флакон с зельем маны
Items.spells[13506]		= Absorb({ru=1}) 							--Зелье оцепенения
Items.spells[18253]		= HealAndMana 								--Большое зелье омоложения
Items.spells[28100]		= Heal({ru=1}) 								--Флакон с летучим лечебным зельем
Items.spells[33934]		= Heal({ru=1}) 								--Хрустальный флакон с лечебным зельем
Items.spells[116277]	= Absorb({ru=1}) 							--Зелье оцепенения
Items.spells[28101]		= Mana({ru=1}) 								--Флакон с нестойким зельем маны
Items.spells[33935]		= Mana({ru=1}) 								--Хрустальный флакон с зельем маны
Items.spells[22829]		= Heal({ru=1}) 								--Гигантский флакон с лечебным зельем
Items.spells[32904]		= Heal({ru=1}) 								--Кенарийский лечебный бальзам
Items.spells[32905]		= Heal({ru=1}) 								--Бутилированные пары Хаотического зелья
Items.spells[32947]		= Heal({ru=1}) 								--Аукенайский флакон с лечебным зельем
Items.spells[39327]		= Heal({ru=1}) 								--Особое пойло Нота
Items.spells[43531]		= Heal({ru=1}) 								--Флакон с лечебным зельем Серебряного Рассвета
Items.spells[23822]		= Heal({ru=1}) 								--Набор для лечебных инъекций
Items.spells[33092]		= Heal({ru=1}) 								--Набор для лечебных инъекций
Items.spells[22832]		= Mana({ru=1}) 								--Гигантский флакон с зельем маны
Items.spells[32902]		= Mana({ru=1}) 								--Бутилированное хаотическое зелье энергии
Items.spells[32903]		= Mana({ru=1}) 								--Кенарийский бальзам маны
Items.spells[32948]		= Mana({ru=1}) 								--Аукенайский флакон с зельем маны
Items.spells[43530]		= Mana({ru=1}) 								--Флакон с зельем маны Серебряного Рассвета
Items.spells[23823]		= Mana({ru=1}) 								--Набор для инъекций маны
Items.spells[33093]		= Mana({ru=1}) 								--Набор для инъекций маны
Items.spells[22841]		= Absorb({ru=1}) 							--Большое зелье защиты от огня
Items.spells[22842]		= Absorb({ru=1}) 							--Большое зелье защиты от магии льда
Items.spells[22844]		= Absorb({ru=1}) 							--Большое зелье защиты от сил природы
Items.spells[22845]		= Absorb({ru=1}) 							--Большое зелье защиты от тайной магии
Items.spells[22846]		= Absorb({ru=1}) 							--Большое зелье защиты от темной магии
Items.spells[22847]		= Absorb({ru=1}) 							--Большое зелье защиты от светлой магии
Items.spells[31838]		= Heal({ru=1}) 								--Большой флакон с боевым лечебным зельем
Items.spells[31839]		= Heal({ru=1}) 								--Большой флакон с боевым лечебным зельем
Items.spells[31840]		= Mana({ru=1}) 								--Большой флакон с боевым зельем маны
Items.spells[31841]		= Mana({ru=1}) 								--Большой флакон с боевым зельем маны
Items.spells[31852]		= Heal({ru=1}) 								--Большой флакон с боевым лечебным зельем
Items.spells[31853]		= Heal({ru=1}) 								--Большой флакон с боевым лечебным зельем
Items.spells[31854]		= Mana({ru=1}) 								--Большой флакон с боевым зельем маны
Items.spells[31855]		= Mana({ru=1}) 								--Большой флакон с боевым зельем маны
Items.spells[32783]		= Mana({ru=1}) 								--Огрское Синее
Items.spells[32784]		= Heal({ru=1}) 								--Огрское Красное
Items.spells[32840]		= Absorb({ru=1}) 							--Большое зелье защиты от огня
Items.spells[32844]		= Absorb({ru=1}) 							--Большое зелье защиты от магии льда
Items.spells[32845]		= Absorb({ru=1}) 							--Большое зелье защиты от сил природы
Items.spells[32846]		= Absorb({ru=1}) 							--Большое зелье защиты от тайной магии
Items.spells[32847]		= Absorb({ru=1}) 							--Большое зелье защиты от темной магии
Items.spells[32909]		= Mana({ru=1}) 								--Огрское Особое синее
Items.spells[32910]		= Heal({ru=1}) 								--Огрское Особое красное
Items.spells[35287]		= Mana({ru=1}) 								--Сверкающий синехвост
Items.spells[22850]		= HealAndMana 								--Гигантский флакон с зельем омоложения
Items.spells[34440]		= HealAndMana 								--Зелье безумного алхимика
Items.spells[39671]		= Heal({ru=1}) 								--Флакон с бодрящим лечебным зельем
Items.spells[40067]		= Mana({ru=1}) 								--Флакон с ледяным зельем маны
Items.spells[43569]		= Heal({ru=1}) 								--Бездонный флакон с лечебным зельем
Items.spells[43570]		= Mana({ru=1}) 								--Бездонный флакон с зельем маны
Items.spells[33447]		= Heal({ru=1}) 								--Рунический флакон с лечебным зельем
Items.spells[33448]		= Mana({ru=1}) 								--Рунический флакон с зельем маны
Items.spells[40213]		= Absorb({ru=1}) 							--Мощное зелье защиты от тайной магии
Items.spells[40214]		= Absorb({ru=1}) 							--Мощное зелье защиты от огня
Items.spells[40215]		= Absorb({ru=1}) 							--Мощное зелье защиты от магии льда
Items.spells[40216]		= Absorb({ru=1}) 							--Мощное зелье защиты от сил природы
Items.spells[40217]		= Absorb({ru=1}) 							--Мощное зелье защиты от темной магии
Items.spells[41166]		= Heal({ru=1}) 								--Рунический набор для лечебных инъекций
Items.spells[42545]		= Mana({ru=1}) 								--Рунический набор для инъекций маны
Items.spells[57191]		= Heal({ru=1}) 								--Легендарное лечебное зелье
Items.spells[57192]		= Mana({ru=1}) 								--Легендарное зелье маны
Items.spells[63300]		= Heal({ru=1}) 								--Зелье разбойника
Items.spells[63144]		= Heal({ru=1}) 								--Лечебное зелье защитников Тол Барада
Items.spells[63145]		= Mana({ru=1}) 								--Зелье маны защитников Тол Барада
Items.spells[64993]		= Mana({ru=1}) 								--Зелье маны батальона Адского Крика
Items.spells[64994]		= Heal({ru=1}) 								--Лечебное зелье батальона Адского Крика
Items.spells[76097]		= Heal({ru=1}) 								--Лечебное зелье мастера
Items.spells[76098]		= Mana({ru=1}) 								--Зелье маны мастера
Items.spells[92954]		= Heal({ru=1}) 								--Лечебное зелье бойца
Items.spells[118917]	= Heal({ru=1}) 								--Дренорское бездонное лечебное снадобье буяна
Items.spells[109222]	= Mana({ru=1}) 								--Дренорское зелье маны
Items.spells[109223]	= Heal({ru=1}) 								--Лечебное снадобье
Items.spells[115498]	= Heal({ru=1}) 								--Ашранское лечебное снадобье
Items.spells[117415]	= Heal({ru=1}) 								--Контрабандный тоник
Items.spells[118006]	= Absorb({ru=1}) 							--Щитотронный щит
Items.spells[118916]	= Heal({ru=1}) 								--Лечебное снадобье буяна
