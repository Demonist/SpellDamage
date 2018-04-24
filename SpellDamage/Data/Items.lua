local L, shortNumber, matchDigit, matchDigits, printTable, SPELL_COMBO_POINTS, comboMatch, comboHelper, strstarts = SD.L, SD.shortNumber, SD.matchDigit, SD.matchDigits, SD.printTable, SD.SPELL_COMBO_POINTS, SD.comboMatch, SD.comboHelper, SD.strstarts
local SpellUnknown, SpellEmpty, SpellDamage, SpellTimeDamage, SpellHeal, SpellTimeHeal, SpellMana, SpellTimeMana, SpellAbsorb = SD.SpellUnknown, SD.SpellEmpty, SD.SpellDamage, SD.SpellTimeDamage, SD.SpellHeal, SD.SpellTimeHeal, SD.SpellMana, SD.SpellTimeMana, SD.SpellAbsorb
local SpellDamageAndTimeDamage, SpellDamageAndMana, SpellHealAndMana, SpellHealAndTimeHeal, SpellDamageAndHeal, SpellTimeDamageAndTimeHeal, SpellDamageAndTimeHeal, SpellManaAndTimeMana, SpellTimeHealAndTimeMana, SpellAbsorbAndHeal = SD.SpellDamageAndTimeDamage, SD.SpellDamageAndMana, SD.SpellHealAndMana, SD.SpellHealAndTimeHeal, SD.SpellDamageAndHeal, SD.SpellTimeDamageAndTimeHeal, SD.SpellDamageAndTimeHeal, SD.SpellManaAndTimeMana, SD.SpellTimeHealAndTimeMana, SD.SpellAbsorbAndHeal
local SpellData, Class, ClassSpells, ClassItems = SD.SpellData, SD.Class, SD.ClassSpells, SD.ClassItems
local Damage, TimeDamage, Heal, TimeHeal, Mana, TimeMana, Absorb, CriticalDamage, DamageAndTimeDamage, HealAndTimeHeal, DamageAndHeal, DamageAndTimeHeal, HealAndMana, TimeHealAndTimeMana, DamageAndDamage, DamageAndMana, TimeDamageAndTimeHeal, Custom, getLocaleIndex = SD.Damage, SD.TimeDamage, SD.Heal, SD.TimeHeal, SD.Mana, SD.TimeMana, SD.Absorb, SD.CriticalDamage, SD.DamageAndTimeDamage, SD.HealAndTimeHeal, SD.DamageAndHeal, SD.DamageAndTimeHeal, SD.HealAndMana, SD.TimeHealAndTimeMana, SD.DamageAndDamage, SD.DamageAndMana, SD.TimeDamageAndTimeHeal, SD.Custom, SD.SimpleSpell.getLocaleIndex

--

local Items = Class:create(ClassItems)
SD.Items = Items

Items.spells[122664]	= Heal({ru=1}) 		--Вечное колье горизонта

	--Камень здоровья:
	local Healthstone = function(data, match)
		data.type = SpellHeal
		data.heal = UnitHealthMax("player") * match / 100
	end

	--Перерожденная ненависть Архимонда:
	local ArchimondesHatredReborn = function(data, match)
		data.type = SpellAbsorb
		data.heal = UnitHealthMax("player") * match / 100
	end

-- Зелья:

Items.spells[152615]	= Heal({ru=1}) 		--Астральное лечебное зелье
Items.spells[127834]	= Heal({ru=1}) 		--Древнее лечебное зелье
Items.spells[127835]	= Mana({ru=1}) 		--Древнее зелье маны
Items.spells[127846]	= TimeMana({ru=1}) 		--Зелье силового потока
Items.spells[127836]	= HealAndMana({ru={1,1}}) 		--Древнее зелье омоложения
Items.spells[5512]		= Heal({ru=1}, Healthstone) 		--Камень здоровья
Items.spells[144249]	= Heal({ru=2}, ArchimondesHatredReborn) 		--Перерожденная ненависть Архимонда
Items.spells[136569]	= Heal({ru=1}) 		--Выдержанное зелье здоровья
Items.spells[140347]	= Mana({ru=1}) 		--Ягоды духов
Items.spells[140351]	= Heal({ru=1}) 		--Солнечный фрукт
Items.spells[109222]	= Mana({ru=1}) 		--Дренорское зелье маны
Items.spells[109223]	= Heal({ru=1}) 		--Лечебное снадобье
Items.spells[109226]	= HealAndMana({ru={1,1}}) 		--Дренорское зелье омоложения
Items.spells[117415]	= Heal({ru=1}) 		--Контрабандный тоник
Items.spells[118916]	= Heal({ru=1}) 		--Лечебное снадобье буяна
Items.spells[118917]	= Heal({ru=1}) 		--Дренорское бездонное лечебное снадобье буяна
Items.spells[76094]		= HealAndMana({ru={1,1}}) 		--Алхимическое зелье омоложения
Items.spells[76097]		= Heal({ru=1}) 		--Лечебное зелье мастера
Items.spells[76098]		= Mana({ru=1}) 		--Зелье маны мастера
Items.spells[92954]		= Heal({ru=1}) 		--Лечебное зелье бойца
Items.spells[113585]	= HealAndMana({ru={1,1}}) 		--Зелье омоложения Железной Орды
Items.spells[63144]		= Heal({ru=1}) 		--Лечебное зелье защитников Тол Барада
Items.spells[63145]		= Mana({ru=1}) 		--Зелье маны защитников Тол Барада
Items.spells[64993]		= Mana({ru=1}) 		--Зелье маны батальона Адского Крика
Items.spells[64994]		= Heal({ru=1}) 		--Лечебное зелье батальона Адского Крика
Items.spells[57191]		= Heal({ru=1}) 		--Легендарное лечебное зелье
Items.spells[57192]		= Mana({ru=1}) 		--Легендарное зелье маны
Items.spells[63300]		= Heal({ru=1}) 		--Зелье разбойника
Items.spells[67415]		= HealAndMana({ru={1,1}}) 		--Глоток войны
Items.spells[33447]		= Heal({ru=1}) 		--Рунический флакон с лечебным зельем
Items.spells[33448]		= Mana({ru=1}) 		--Рунический флакон с зельем маны
Items.spells[40077]		= HealAndMana({ru={1,1}}) 		--Зелье сумасшедшего алхимика
Items.spells[41166]		= Heal({ru=1}) 		--Рунический набор для лечебных инъекций
Items.spells[42545]		= Mana({ru=1}) 		--Рунический набор для инъекций маны
Items.spells[43569]		= Heal({ru=1}) 		--Бездонный флакон с лечебным зельем
Items.spells[43570]		= Mana({ru=1}) 		--Бездонный флакон с зельем маны
Items.spells[39671]		= Heal({ru=1}) 		--Флакон с бодрящим лечебным зельем
Items.spells[40067]		= Mana({ru=1}) 		--Флакон с ледяным зельем маны
Items.spells[31677]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Оскверненное зелье маны
Items.spells[31838]		= Heal({ru=1}) 		--Большой флакон с боевым лечебным зельем
Items.spells[31839]		= Heal({ru=1}) 		--Большой флакон с боевым лечебным зельем
Items.spells[31840]		= Mana({ru=1}) 		--Большой флакон с боевым зельем маны
Items.spells[31841]		= Mana({ru=1}) 		--Большой флакон с боевым зельем маны
Items.spells[31852]		= Heal({ru=1}) 		--Большой флакон с боевым лечебным зельем
Items.spells[31853]		= Heal({ru=1}) 		--Большой флакон с боевым лечебным зельем
Items.spells[31854]		= Mana({ru=1}) 		--Большой флакон с боевым зельем маны
Items.spells[31855]		= Mana({ru=1}) 		--Большой флакон с боевым зельем маны
Items.spells[32783]		= Mana({ru=1}) 		--Огрское Синее
Items.spells[32909]		= Mana({ru=1}) 		--Огрское Особое синее
Items.spells[35287]		= Mana({ru=1}) 		--Сверкающий синехвост
Items.spells[23823]		= Mana({ru=1}) 		--Набор для инъекций маны
Items.spells[31676]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Оскверненное зелье регенерации
Items.spells[33093]		= Mana({ru=1}) 		--Набор для инъекций маны
Items.spells[22832]		= Mana({ru=1}) 		--Гигантский флакон с зельем маны
Items.spells[32902]		= Mana({ru=1}) 		--Бутилированное хаотическое зелье энергии
Items.spells[32903]		= Mana({ru=1}) 		--Кенарийский бальзам маны
Items.spells[32948]		= Mana({ru=1}) 		--Аукенайский флакон с зельем маны
Items.spells[43530]		= Mana({ru=1}) 		--Флакон с зельем маны Серебряного Рассвета
Items.spells[23822]		= Heal({ru=1}) 		--Набор для лечебных инъекций
Items.spells[33092]		= Heal({ru=1}) 		--Набор для лечебных инъекций
Items.spells[22829]		= Heal({ru=1}) 		--Гигантский флакон с лечебным зельем
Items.spells[32904]		= Heal({ru=1}) 		--Кенарийский лечебный бальзам
Items.spells[32905]		= Heal({ru=1}) 		--Бутилированные пары Хаотического зелья
Items.spells[32947]		= Heal({ru=1}) 		--Аукенайский флакон с лечебным зельем
Items.spells[43531]		= Heal({ru=1}) 		--Флакон с лечебным зельем Серебряного Рассвета
Items.spells[28101]		= Mana({ru=1}) 		--Флакон с нестойким зельем маны
Items.spells[33935]		= Mana({ru=1}) 		--Хрустальный флакон с зельем маны
Items.spells[28100]		= Heal({ru=1}) 		--Флакон с летучим лечебным зельем
Items.spells[33934]		= Heal({ru=1}) 		--Хрустальный флакон с лечебным зельем
Items.spells[13444]		= Mana({ru=1}) 		--Огромный флакон с зельем маны
Items.spells[13446]		= Heal({ru=1}) 		--Огромный флакон с лечебным зельем
Items.spells[17348]		= Heal({ru=1}) 		--Хорошее исцеляющее зелье
Items.spells[17351]		= Mana({ru=1}) 		--Хорошее зелье возврата маны
Items.spells[13443]		= Mana({ru=1}) 		--Большой флакон с зельем маны
Items.spells[18841]		= Mana({ru=1}) 		--Флакон с боевым зельем маны
Items.spells[3928]		= Heal({ru=1}) 		--Большой флакон с лечебным зельем
Items.spells[9144]		= HealAndMana({ru={1,1}}) 		--Зелье из дикой лозы
Items.spells[17349]		= Heal({ru=1}) 		--Наилучшее исцеляющее зелье
Items.spells[17352]		= Mana({ru=1}) 		--Наилучшее зелье возврата маны
Items.spells[18839]		= Heal({ru=1}) 		--Флакон с боевым лечебным зельем
Items.spells[6149]		= Mana({ru=1}) 		--Средний флакон с зельем маны
Items.spells[3827]		= Mana({ru=1}) 		--Зелье маны
Items.spells[1710]		= Heal({ru=1}) 		--Средний флакон с лечебным зельем
Items.spells[3385]		= Mana({ru=1}) 		--Маленький флакон с зельем маны
Items.spells[929]		= Heal({ru=1}) 		--Лечебное зелье
Items.spells[2455]		= Mana({ru=1}) 		--Крохотный флакон с зельем маны
Items.spells[4596]		= Heal({ru=1}) 		--Флакон с бесцветным лечебным зельем
Items.spells[858]		= Heal({ru=1}) 		--Маленький флакон с лечебным зельем
Items.spells[118]		= Heal({ru=1}) 		--Крохотный флакон с лечебным зельем

--Еда и напитки:

Items.spells[128764]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Влажная азсунская фета
Items.spells[128835]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гренки Крутогорья
Items.spells[128838]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Брусника
Items.spells[128840]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ветчина в медовой глазури
Items.spells[128844]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сушеное манго
Items.spells[128846]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тирамису
Items.spells[128847]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Испеченный с любовью и морковью пирог
Items.spells[128849]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кимчи из лука-шалота
Items.spells[128850]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Холодная сотворенная вода
Items.spells[128851]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная сочная хрустящая морковь
Items.spells[133565]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Энергетические ребрышки
Items.spells[133566]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Жаркое по-сурамарски
Items.spells[133567]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Барракуда Мрглгагх
Items.spells[133568]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Штормовой скат под соусом из кои
Items.spells[133569]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Лосось по-дрогбарски
Items.spells[133570]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Голодный магистр
Items.spells[133571]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Салат по-азшарски
Items.spells[133572]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Деликатесное угощение ночнорожденных
Items.spells[133573]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Ассорти из рыбы в панировке
Items.spells[133574]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Коронное блюдо рыбрула
Items.spells[133575]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Нарезка из сушеной скумбрии
Items.spells[133576]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Медвежий тартар
Items.spells[133577]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Бойцовская жратва
Items.spells[133578]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Обильное угощение
Items.spells[133579]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Щедрое сурамарское угощение
Items.spells[136544]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусок брюнуста
Items.spells[136545]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Черви в кляре Сколада
Items.spells[136546]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежий крабовый салат
Items.spells[136547]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Котлеты из глубоководной ставриды
Items.spells[136548]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Чипсы из вяленой барракуды
Items.spells[136549]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Воздушный бисквит
Items.spells[136550]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящая соломка из корня земли
Items.spells[136551]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вяленое мясо старорога
Items.spells[136552]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Бифштекс из саблерога
Items.spells[136553]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Азсунский изюм
Items.spells[136554]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сушеная брусника
Items.spells[136555]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стандартные мясные пайки
Items.spells[136557]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирог из маракуйи
Items.spells[136558]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тщательно завернутый кекс
Items.spells[136559]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Бесовское шоколадное пирожное
Items.spells[136560]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Концентрированные брызги маны
Items.spells[138290]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мини-скаты на гриле
Items.spells[138291]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сладкое зеленое яблоко
Items.spells[138292]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Вода, заряженная силой
Items.spells[138978]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сыр, богатый клетчаткой
Items.spells[138982]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Кадка с теплым молоком
Items.spells[138983]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Мягкое мороженое Курды
Items.spells[138986]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Йогурт Курды
Items.spells[139345]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Крысиные лапки
Items.spells[139347]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Желе Клоаки Даларана
Items.spells[139398]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Багеты-штаны
Items.spells[140184]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хорошая партия фруктов
Items.spells[140265]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Кофе слабой обжарки
Items.spells[140266]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Кафа с хмелем
Items.spells[140269]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Ледяная свежесть Крутогорья
Items.spells[140272]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сурамарский чай со специями
Items.spells[140273]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Круассан с медом
Items.spells[140275]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Валь'шарский ягодный пирог
Items.spells[140286]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ночное лакомство
Items.spells[140296]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мармеладный угорь
Items.spells[140297]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мороженое шал'дорай
Items.spells[140298]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Игристый сидр Мананель
Items.spells[140299]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Смесь магистра
Items.spells[140300]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежие чародейские плоды
Items.spells[140301]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Бисквит из маны
Items.spells[140302]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Биск катакомб Сурамара
Items.spells[140627]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Каменная закуска
Items.spells[140629]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Водоворот в бутылках
Items.spells[140631]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ночная груша
Items.spells[140679]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Нетающее мороженое
Items.spells[141207]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Смесь Джилла
Items.spells[141208]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ночной сморчок
Items.spells[141212]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Насыщенное маной яйцо
Items.spells[141213]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Засахаренные яйца песочника
Items.spells[141214]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Икра манаугря
Items.spells[141215]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сок чароягоды
Items.spells[128761]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Азсунские оливки
Items.spells[128836]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ячменный хлеб
Items.spells[128837]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сушеная черника
Items.spells[128839]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченое мясо старорога
Items.spells[128843]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Азсунский виноград
Items.spells[128845]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сладкий пирог с рисом
Items.spells[128848]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареный маис
Items.spells[128853]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Ключевая вода Крутогорья
Items.spells[133557]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Соленая и перченая рулька
Items.spells[133561]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Прожаренный мохножабрый окунь
Items.spells[133562]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Маринованный штормовой скат
Items.spells[133563]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Фаронаарская шипучка
Items.spells[133564]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Острые жареные ребрышки
Items.spells[136556]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Порченые фрукты Легиона
Items.spells[138285]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Закуска из синехвоста
Items.spells[138975]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Родниковая вода Крутогорья
Items.spells[138976]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Безвкусный рисовый пирог Громового Тотема
Items.spells[138977]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирог с рисом Громового Тотема
Items.spells[138979]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Очень острый чеддер
Items.spells[139344]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Банан маны
Items.spells[139346]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Запатентованный напиток Туни
Items.spells[140276]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Даларанский рисовый пудинг
Items.spells[140626]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ледяные мини-хлопья
Items.spells[140628]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Лава-колада
Items.spells[140668]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мясистые ребрышки мускена
Items.spells[141527]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Слегка проржавевшая фляжка
Items.spells[111431]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Толстый стейк из мяса элекка
Items.spells[111433]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Ветчина Черной горы
Items.spells[111434]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Подрумяненное на сковороде мясо талбука
Items.spells[111436]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тушеное речное чудище
Items.spells[111437]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Блинчики из яиц рилака
Items.spells[111438]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Сосиски из копытня
Items.spells[111439]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Скорпион на пару
Items.spells[111441]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Мешкорот на гриле
Items.spells[111442]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Похлебка из осетра
Items.spells[111444]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Пироги с толстопузиком
Items.spells[111445]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Огненные аммониты
Items.spells[111446]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Уха из скрытиуса
Items.spells[111447]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Жаркое по-таладорски
Items.spells[111449]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Барбекю Черной горы
Items.spells[111450]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Морозное рагу
Items.spells[111452]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Сюрприз из толстопузика
Items.spells[111453]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Блинчики с аммонитами
Items.spells[111454]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Горгрондская уха
Items.spells[111455]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Бульон из рыбы-сабли
Items.spells[111456]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная рыба-сабля
Items.spells[111457]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Кровавый пир
Items.spells[111458]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Морской пир
Items.spells[111544]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вяленое мясо морозного вепря
Items.spells[113099]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Грибы - теневые шапки
Items.spells[115352]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Твердый сыр Телмора-Арууны
Items.spells[115353]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Танаанская дыня
Items.spells[115354]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Нарезанные зангарские молодые грибы
Items.spells[115355]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мраморный стейк из копытня
Items.spells[116120]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вкусный таладорский обед
Items.spells[117452]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Горгрондская минеральная вода
Items.spells[117454]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Горгрондский виноград
Items.spells[117457]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кровавые яблоки
Items.spells[117469]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Заварное печенье в сахарной пудре
Items.spells[117470]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Многозерновая буханка
Items.spells[117471]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Лепешки из какао
Items.spells[117472]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареный горгрондский сюрприз
Items.spells[117473]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Маринованные копыта элекка
Items.spells[117474]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Колбаса из мяса рилака
Items.spells[117475]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Молоко копытня
Items.spells[118050]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зачарованное яблоко
Items.spells[118051]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зачарованный апельсин
Items.spells[118268]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Мохнатая груша
Items.spells[118269]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Зеленое яблоко
Items.spells[118270]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Апельсин о'рук
Items.spells[118271]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Стальношкурый банан
Items.spells[118272]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Огромная награндская вишня
Items.spells[118416]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Рыбья икра
Items.spells[118424]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Слепая бледнорыба
Items.spells[118428]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Чили Легиона
Items.spells[118576]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Дикое пиршество
Items.spells[120168]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Миска лапши быстрого приготовления
Items.spells[120293]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Чуть теплая похлебка из мяса яка
Items.spells[122343]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Суши из толстопузика
Items.spells[122344]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Рулетик из соленого кальмара
Items.spells[122345]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Маринованный угорь
Items.spells[122346]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Огромный морской хотдог
Items.spells[122347]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Филе хлыстохвоста
Items.spells[122348]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Осетр в масле
Items.spells[128219]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сквернокопченая ветчина
Items.spells[128385]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Вода стихийной перегонки
Items.spells[128498]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Яичница Скверны с ветчиной
Items.spells[129179]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Бойцовская жратва
Items.spells[130192]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Похлебка из остроклюя с картофелем
Items.spells[130259]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Древняя бандана
Items.spells[132752]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рацион иллидари
Items.spells[132753]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рацион демонов
Items.spells[133586]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Бурдюк для воды иллидари
Items.spells[133893]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Бургер с грибами Темной пещеры
Items.spells[133979]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Поджаренная на гриле улитка
Items.spells[133981]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сырая пещерная рыба
Items.spells[135557]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Адские крабьи ножки с карри
Items.spells[140355]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Налитое яблоко
Items.spells[74646]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Ребрышки с черным перцем и раками
Items.spells[74648]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Рисовая лапша морских туманов
Items.spells[74650]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Рыбная похлебка могу
Items.spells[74653]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Крабовый сюрприз на пару
Items.spells[74656]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Весенние рулетики монастыря Тянь
Items.spells[74919]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Пандаренское угощение
Items.spells[75016]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Большое пандаренское угощение
Items.spells[79320]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Половинка яблочка
Items.spells[80618]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Сотворенные булочки из маны
Items.spells[81408]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирожок с красной фасолью
Items.spells[81410]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зеленый карри с рыбой
Items.spells[81411]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Персиковый пирог
Items.spells[81413]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Курица с арахисом на вертеле
Items.spells[81414]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Чай с перламутровым молоком
Items.spells[81916]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Огромный гриб
Items.spells[81918]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Маринованный свиной пятачок
Items.spells[81920]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Крупный инжир
Items.spells[81921]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сыр Чилтона
Items.spells[81923]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Кобо Кола
Items.spells[82449]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Уха из морских уточек
Items.spells[82451]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареный хлеб
Items.spells[86073]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Острый лосось
Items.spells[86074]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Острые овощные чипсы
Items.spells[86508]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежий хлеб
Items.spells[87226]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Угощение на гриле
Items.spells[87228]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Большое угощение на гриле
Items.spells[87230]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Угощение вок
Items.spells[87232]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Большое угощение вок
Items.spells[87234]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Угощение в горшочке
Items.spells[87236]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Большое угощение в горшочке
Items.spells[87238]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Угощение на пару
Items.spells[87240]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Большое угощение на пару
Items.spells[87242]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Угощение из печи
Items.spells[87244]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Большое угощение из печи
Items.spells[87246]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Освежающее угощение
Items.spells[87248]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Большое освежающее угощение
Items.spells[87253]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Бесконечное застолье
Items.spells[90135]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Нарезной бекон
Items.spells[94535]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Жареная нога динозавра
Items.spells[98111]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--КГУ
Items.spells[98116]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Замороженное мясо гиены
Items.spells[98118]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Хрустящие скорпионы
Items.spells[98121]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Булочка с янтарными желудями
Items.spells[98123]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Икра китовой акулы
Items.spells[98124]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кровяничный пирог
Items.spells[98126]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Фуа-гра из механобипа
Items.spells[101745]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Мороженое из манго
Items.spells[101746]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Пряные ломтики тыблока
Items.spells[101747]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Лакомство фермера
Items.spells[101748]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Цветочный суп со специями
Items.spells[101749]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Фаршированные мягкогрибы
Items.spells[101750]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Воздушный омлет из яиц шелкоперого ястреба
Items.spells[104196]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Изысканный огрский тошнозин
Items.spells[104339]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гармоничная речная лапша
Items.spells[104340]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Лапша чокнутой змеи
Items.spells[104341]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кипящая лапша с козлятиной
Items.spells[104342]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пряная лапша с мясом мушана
Items.spells[104343]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Лапша золотого дракона
Items.spells[104344]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Счастливая лапша с грибами
Items.spells[105719]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сиг в остром отваре
Items.spells[105720]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Засахаренное яблоко
Items.spells[105721]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Горячее молоко с папайей
Items.spells[105722]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Булка со вкусом орехового отвара
Items.spells[105723]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Куски свинины с арахисом
Items.spells[108920]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Цветочно-лимонный пуддинг
Items.spells[112449]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Пайки Железной Орды
Items.spells[113290]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Плод горной лозы
Items.spells[115300]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Маринованный стейк из мяса элекка
Items.spells[74645]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Рыба по-дольски
Items.spells[74647]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Стир-фрай долины
Items.spells[74649]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тушеное черепашье мясо
Items.spells[74652]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Лосось духов огня
Items.spells[74655]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Блюдо из двух рыб
Items.spells[75037]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Отвар нефритовой ведьмы
Items.spells[86069]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Рисовый пудинг
Items.spells[86070]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Суп из дичи с женьшенем
Items.spells[74636]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Консоме из золотистого карпа
Items.spells[74641]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рыбный пирог
Items.spells[74642]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Жаренный на углях стейк из тигриного мяса
Items.spells[74643]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Пассерованная морковь
Items.spells[74644]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Суп из клубящегося тумана
Items.spells[74651]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Клецки с раками-богомолами
Items.spells[74654]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Жареная дичь
Items.spells[75026]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Женьшеневый чай
Items.spells[81400]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Торт из молотого риса
Items.spells[81401]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Домашний сыр из молока яка
Items.spells[81402]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Подрумяненная соленая рыба
Items.spells[81403]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сушеные персики
Items.spells[81404]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сушеные опята
Items.spells[81405]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Отварная куколка шелкопряда
Items.spells[85501]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Суп из шустрого краба
Items.spells[86026]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Идеальная лапша быстрого приготовления
Items.spells[86057]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Разрезанные персики
Items.spells[105700]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Куньлайский сногсшибатель
Items.spells[105701]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Отвар Зеленой Скалы
Items.spells[105703]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Отвар Буйных Портеров
Items.spells[105704]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Пылающий отвар Янь-Чжу
Items.spells[105705]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Горький отвар Чани
Items.spells[105706]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Отвар Шадо-Пан
Items.spells[105707]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Отвар унга
Items.spells[105708]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мерцающий янтарный отвар
Items.spells[105711]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Диковинное обезьянье пойло
Items.spells[58257]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Высокогорная ключевая вода
Items.spells[58259]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Высокогорная брынза
Items.spells[58261]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пшеничный рогалик с маслом
Items.spells[58263]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Акула-гриль
Items.spells[58265]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Горный гранат
Items.spells[58267]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Алый трутовик
Items.spells[58269]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жирная ножка индейки
Items.spells[63251]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Великолепное пиво Мей
Items.spells[68140]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Живительный ананасовый пунш
Items.spells[70924]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вечное око Элуны
Items.spells[70925]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вечная лунная груша
Items.spells[70926]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вечная луноягода
Items.spells[70927]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вечный солнцеплод
Items.spells[73260]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Морской хот-дог
Items.spells[74822]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Саспарилья
Items.spells[74921]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пончик Новолуния
Items.spells[81175]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящий доцзяньский угорь
Items.spells[81889]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Перченый гриб-дождевик
Items.spells[81917]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тушеная баранина
Items.spells[81919]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Красная малина
Items.spells[81922]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рокфор Красногорья
Items.spells[81924]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Газированная вода
Items.spells[82448]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Подкопченое брюшко кальмара
Items.spells[82450]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Печенье из кукурузной муки
Items.spells[83097]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вяленое черепашье мясо
Items.spells[88379]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирожное груммелей
Items.spells[88388]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Извивающийся деликатес
Items.spells[88398]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рагу из корнеплодов
Items.spells[88532]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Лотосовая вода
Items.spells[88578]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Чашка кафы
Items.spells[88586]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Печенье Чао
Items.spells[89594]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Змеиный отвар безмятежности
Items.spells[89601]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тигровый отвар безмятежности
Items.spells[90457]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Отварные хвосты яков Ма
Items.spells[101616]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Суп с лапшой
Items.spells[101617]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Изысканный суп с лапшой
Items.spells[101618]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Легендарный пандаренский суп с лапшой
Items.spells[140340]	= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Бутылка газированной воды
Items.spells[140343]	= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Экзотический извивающийся деликатес
Items.spells[62289]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Угощение из жареного дракона
Items.spells[62290]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Волшебное угощение из морепродуктов
Items.spells[62649]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Печенье с предсказанием
Items.spells[62651]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Слегка поджаренный скрытень
Items.spells[62652]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Краб с приправами
Items.spells[62653]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Засоленный глаз
Items.spells[62654]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Филе лавочешуйчатой рыбы
Items.spells[62655]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Жареная горная форель
Items.spells[62656]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Белопенная морская похлебка
Items.spells[62657]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Обед со скрытнем
Items.spells[62658]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Нежное печеное черепашье мясо
Items.spells[62659]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Сытный суп из морепродуктов
Items.spells[62660]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Маринованная гуппи
Items.spells[62661]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Запеченный морской окунь
Items.spells[62662]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Дракон на гриле
Items.spells[62663]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Минестроне с лавочешуйчатой рыбой
Items.spells[62664]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Кроколиск о-гратен
Items.spells[62665]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Ливер-дог из василиска
Items.spells[62666]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Деликатесный хвост шалфокуня
Items.spells[62667]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Ильная рыба в грибном соусе
Items.spells[62668]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Суши с чернобрюхом
Items.spells[62669]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Угорь на вертеле
Items.spells[62670]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вымоченный в пиве кроколиск
Items.spells[62671]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Отрубленная голова шалфокуня
Items.spells[62675]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Эспрессо Звездного огня
Items.spells[62676]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Почерневший сюрприз
Items.spells[58256]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Газированная оазисная вода
Items.spells[58258]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченый чечил
Items.spells[58260]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хлеб с кедровыми орешками
Items.spells[58262]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Нарезанная ломтиками сырая макайра
Items.spells[58264]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кислое зеленое яблоко
Items.spells[58266]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Лиловый сморчок
Items.spells[58268]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная говядина
Items.spells[59029]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Жирное китовое молоко
Items.spells[59228]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мерзкая лиловая поганка
Items.spells[59230]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Грибные выжимки
Items.spells[59232]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жаркое непонятно из кого
Items.spells[62677]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная рыбка
Items.spells[89593]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Змеиный отвар опавших цветов
Items.spells[89600]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тигриный отвар опавших цветов
Items.spells[33445]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Мятный чай с медом
Items.spells[35947]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Искрящийся морозный гриб
Items.spells[35948]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пряная снежная слива
Items.spells[35950]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Бататовый хлеб
Items.spells[35951]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вареный императорский лосось
Items.spells[35952]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Соленый сыр
Items.spells[35953]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Карибу в медовом соусе
Items.spells[38706]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мозги и кишки
Items.spells[40202]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пережаренный бок гризли
Items.spells[41729]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тушеная драконятина
Items.spells[41731]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Молоко йети
Items.spells[42431]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Даларанское шоколадное пирожное
Items.spells[42434]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусочек восхитительного торта
Items.spells[42777]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Бурдюк Авангарда
Items.spells[42778]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Паек Авангарда
Items.spells[42779]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Горячий куриный бульон
Items.spells[43087]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящее даларанское яблоко
Items.spells[43236]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Звездная печаль
Items.spells[44049]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежепойманный императорский лосось
Items.spells[44071]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хорошо прожаренный угорь
Items.spells[44072]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареный загадочный зверь
Items.spells[44607]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Выдержанный даларанский острый сыр
Items.spells[44722]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Подсохший желток
Items.spells[44940]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сосиска в кукурузных сухариках
Items.spells[58274]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Свежая вода
Items.spells[58275]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сухарь
Items.spells[58276]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гилнеасская брынза
Items.spells[58277]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тушеный на медленном огне кальмар
Items.spells[58278]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тропический солнечный фрукт
Items.spells[58279]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вкусный гриб-дождевик
Items.spells[58280]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тушеная крольчатина
Items.spells[59227]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Твердокаменное печенье
Items.spells[59229]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Мутная вода
Items.spells[59231]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Маслянистые потроха
Items.spells[89592]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Змеиный отвар медитации
Items.spells[89599]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тигриный отвар медитации
Items.spells[140341]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вареный дикий императорский лосось
Items.spells[28112]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Плод подспорника
Items.spells[33444]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Едкая тюленья сыворотка
Items.spells[34125]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Суп из черпорога
Items.spells[34747]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Северная похлебка
Items.spells[34748]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кушанье из мамонта
Items.spells[34749]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из черпорога
Items.spells[34750]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Деликатес из змея
Items.spells[34751]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареный ворг
Items.spells[34752]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сосиски из люторога
Items.spells[34754]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сытное кушанье из мамонта
Items.spells[34755]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Нежный стейк из черпорога
Items.spells[34757]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пережаренное мясо ворга
Items.spells[34758]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сочные сосиски из люторога
Items.spells[34759]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Копченый камнеперый окунь
Items.spells[34760]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Костечешуйный луциан - гриль
Items.spells[34761]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Соте из бычков
Items.spells[34762]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Подкаменщик-гриль
Items.spells[34763]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Копченый лосось
Items.spells[34764]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вареная медуза
Items.spells[34765]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Маринованная клыкозубая сельдь
Items.spells[34766]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вареный северный подкаменщик
Items.spells[34767]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Лосось с дымком
Items.spells[34768]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Синяя медуза с пряностями
Items.spells[34769]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Стейк из королевского ската
Items.spells[38698]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Горькая плазма
Items.spells[39691]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Наваристая похлебка из косатки
Items.spells[42428]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Морковный кекс
Items.spells[42430]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Даларанский пончик
Items.spells[42432]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусок ягодного пирога
Items.spells[42433]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусок шоколадного торта
Items.spells[42942]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Печеный морской дьявол
Items.spells[42993]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Острая жареная сельдь
Items.spells[42995]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сочное мясо люторога
Items.spells[42996]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Луциан особого приготовления
Items.spells[42997]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Подкопченный стейк из ворга
Items.spells[42998]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Стейк из каракатицы
Items.spells[42999]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Подкопченная дракоперая рыба-ангел
Items.spells[43000]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Филе дракоперой рыбы-ангела
Items.spells[43001]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Завтрак следопыта
Items.spells[43086]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Свежий яблочный сок
Items.spells[43268]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Даларанская похлебка из моллюсков
Items.spells[44941]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Свежевыжатый лимеад
Items.spells[44953]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Карпаччо из ворга
Items.spells[69243]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусочек торта-мороженого
Items.spells[22018]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная ледниковая вода
Items.spells[22019]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенный круассан
Items.spells[27860]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Очищенная дренорская вода
Items.spells[29394]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хлеб Лири
Items.spells[29395]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Небесный мед
Items.spells[29401]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Игристый сидр с Южнобережья
Items.spells[29448]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Плавленый сыр маг'харов
Items.spells[29449]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Бублик Камнерогов
Items.spells[29450]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Телаарский виноград
Items.spells[29451]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Грудинка копытня
Items.spells[29452]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зангарская форель
Items.spells[29453]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Спореггарский гриб
Items.spells[30355]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареные клубни долины Призрачной Луны
Items.spells[30357]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Корень здоровья Оронока
Items.spells[30358]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Корень ловкости Оронока
Items.spells[30359]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Корень силы Оронока
Items.spells[30361]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Корень силы заклинаний Оронока
Items.spells[30457]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Гилнеасская шипучка
Items.spells[32453]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Слезы Звезд
Items.spells[32668]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Дос Огрос
Items.spells[32685]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Цыплячьи крылышки из Огри'лы
Items.spells[32686]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Потрошки удачи Минго
Items.spells[32722]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Сироп из сока терошишки
Items.spells[33042]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Черный кофе
Items.spells[33048]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тушеная форель
Items.spells[33052]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рыбацкая услада
Items.spells[33053]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Жареная форель
Items.spells[33443]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кислый козий сыр
Items.spells[33449]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящая лепешка
Items.spells[33451]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Филе ледоспина
Items.spells[33452]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Лишайник с медом
Items.spells[33454]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Соленая оленина
Items.spells[33825]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Суп из рыбы-черепа
Items.spells[33872]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Острый стейк из талбука
Items.spells[34062]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Сотворенный бисквит из маны
Items.spells[34411]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Горячий яблочный сидр
Items.spells[34780]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Рацион наару
Items.spells[35949]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тундровая ягода
Items.spells[35954]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Подслащенное козье молоко
Items.spells[37252]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ягоды снежевики
Items.spells[37253]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Снежевичный сок
Items.spells[37452]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жирный голубой тунец
Items.spells[38428]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Перченый крендель
Items.spells[38431]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Обогащенная вода Черной горы
Items.spells[40356]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ворчуника
Items.spells[40357]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Ворчуничный сок
Items.spells[40358]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сырое мясо высокорогого оленя
Items.spells[40359]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежее мясо орла
Items.spells[44608]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Даларанский сыр
Items.spells[44609]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусок свежего даларанского хлеба
Items.spells[44749]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Соленый сыр йети
Items.spells[44750]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Вода из горных источников
Items.spells[89591]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Змеиный отвар странствий
Items.spells[89598]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тигровый отвар странствий
Items.spells[28399]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Фильтрованная дренорская вода
Items.spells[29454]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Серебрянка
Items.spells[30703]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная горная вода
Items.spells[38430]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Минеральная вода Черной горы
Items.spells[8079]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная талая вода
Items.spells[18300]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Хиджальский нектар
Items.spells[20031]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Концентрат манго
Items.spells[21023]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зажигательные отбивные Могиля из химерока
Items.spells[22895]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная плюшка с корицей
Items.spells[24008]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Паек из сухих грибов
Items.spells[24009]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Паек из сухофруктов
Items.spells[24338]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пламенный шиполист
Items.spells[24539]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Болотные сыроежки
Items.spells[27651]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Закуска из канюка
Items.spells[27655]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сосиска из мяса опустошителя
Items.spells[27657]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченый василиск
Items.spells[27658]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареное мясо копытня
Items.spells[27659]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Котлета из прыгуаны
Items.spells[27660]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из талбука
Items.spells[27661]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченая форель
Items.spells[27662]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Лакомство из сквернохвоста
Items.spells[27663]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченый спороус
Items.spells[27664]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная ильница
Items.spells[27665]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вареный луфарь
Items.spells[27666]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Палочки из золотой рыбки
Items.spells[27667]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рак с пряностями
Items.spells[27854]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченый дикий талбук
Items.spells[27855]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зерновой хлеб маг'харов
Items.spells[27856]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Скетильские ягоды
Items.spells[27857]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гарадарская закуска
Items.spells[27858]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Карп Солнечного Источника
Items.spells[27859]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зангарские шляпки
Items.spells[28486]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Изумительный кекс Мозера
Items.spells[28501]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Омлет из яйца опустошителя
Items.spells[29292]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зловепревая ветчина
Items.spells[29393]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Алмазные ягоды
Items.spells[29412]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Особая похлебка Джессена
Items.spells[30155]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Батончик из мяса моллюска
Items.spells[30458]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мюнстерский сыр из Стромгарда
Items.spells[30610]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченое мясо черного медведя
Items.spells[31672]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ребрышки Мок'Натала
Items.spells[31673]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Поджаристый змей
Items.spells[32455]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Плач Звезд
Items.spells[32721]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Паек Стражи Небес
Items.spells[33867]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зажаренный на открытом огне афиохаракс
Items.spells[38427]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Маринованное яйцо
Items.spells[41751]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Черный гриб
Items.spells[89590]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Змеиный отвар бедствия
Items.spells[89597]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тигриный отвар бедствия
Items.spells[140342]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Постные ребрышки Мок'Натала
Items.spells[140344]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Консервированное маринованное яйцо
Items.spells[19301]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Альтеракский манный бисквит
Items.spells[8076]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная сладкая булочка
Items.spells[8078]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная шипучка
Items.spells[8766]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Роса с цветков вьюнка
Items.spells[8932]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Альтеракский сыр
Items.spells[8948]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сушеные белые грибы
Items.spells[8950]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Домашний пирог с вишней
Items.spells[8952]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная куропатка
Items.spells[8953]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареные бананы
Items.spells[8957]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гребнеплавничный палтус
Items.spells[11415]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Смесь ягод
Items.spells[11951]		= Heal({ru=1}) 		--Плод кнутокорня
Items.spells[13724]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Сытное манное печенье
Items.spells[13810]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Благословенный солнцеплод
Items.spells[13893]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Крупная сырая мощь-рыба
Items.spells[13933]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Похлебка из омаров
Items.spells[13934]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из мощь-рыбы
Items.spells[13935]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Печеный лосось
Items.spells[18254]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Десерт из корня Рун-Тум
Items.spells[18255]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Корень Рун-Тум
Items.spells[19225]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Поджаристый шоколадный батончик
Items.spells[20452]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченые пустынные клецки
Items.spells[21031]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Капуста кимчи
Items.spells[21033]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кимчи с редькой
Items.spells[22324]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зимнее кимчи
Items.spells[23160]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хлеб дружбы
Items.spells[38429]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Ключевая вода Черной горы
Items.spells[67270]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Бок Урсиуса
Items.spells[67271]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Барбекю из Смертоуха
Items.spells[67272]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из Ши-Ротам
Items.spells[67273]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Омлет из яиц хладнокрылой химеры
Items.spells[89589]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Змеиный отвар послушника
Items.spells[89596]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тигриный отвар послушника
Items.spells[140339]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Альтеракский сыр без гормонов
Items.spells[12216]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Острое крабовое чили
Items.spells[12218]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Чудовищный омлет
Items.spells[16971]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мидии с сюрпризом
Items.spells[18045]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Нежный стейк из волчатины
Items.spells[63691]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящее эскимо Бливельверпа
Items.spells[69244]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Брикет мороженого
Items.spells[1645]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сок луноягоды
Items.spells[3927]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусок старого чеддера
Items.spells[4599]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кусок ветчины
Items.spells[4601]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежий банановый хлеб
Items.spells[4602]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Полуночная тыква
Items.spells[4608]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежий черный трюфель
Items.spells[6887]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пятнистый желтохвост
Items.spells[8075]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенный батон
Items.spells[8077]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная минеральная вода
Items.spells[9681]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареные ножки королевского краба
Items.spells[12215]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сытная похлебка из кодо
Items.spells[13546]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рыба-кровобрюх
Items.spells[13755]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Зимний кальмар
Items.spells[13927]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мощь-рыба в кляре
Items.spells[13928]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кальмар-гриль
Items.spells[13929]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Окунь горячего копчения
Items.spells[13930]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Филе краснобородки
Items.spells[13931]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Суп из ночного луциана
Items.spells[13932]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вареный радужный лосось
Items.spells[16168]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Небесный персик
Items.spells[16766]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Шахтерская похлебка из моллюсков
Items.spells[17222]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Паучья колбаска
Items.spells[17408]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Острый бифштекс
Items.spells[18635]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ореховая паста Беллары
Items.spells[19300]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Бутылка талой воды
Items.spells[19306]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящая лягушка
Items.spells[21030]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Дарнасский пирог с кимчи
Items.spells[21552]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Полосатый желтохвост
Items.spells[61382]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Лаймонад Гарра
Items.spells[63023]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сладкий чай
Items.spells[89588]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Змеиный отвар новичка
Items.spells[89595]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Тигриный отвар новичка
Items.spells[21217]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Деликатес из шалфокуня
Items.spells[63692]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Замороженный заварной крем
Items.spells[57519]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Особое жаркое Пирожка
Items.spells[1487]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенный хлеб грубого помола
Items.spells[1707]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Штормградский бри
Items.spells[1708]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сладкий нектар
Items.spells[3728]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сочный стейк из мяса льва
Items.spells[3729]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Нежный черепаховый суп
Items.spells[3771]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Рулька дикой свиньи
Items.spells[3772]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная ключевая вода
Items.spells[4457]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареное крыло канюка
Items.spells[4539]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Золотистое яблоко
Items.spells[4544]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мулгорский хлеб с пряностями
Items.spells[4594]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Каменношкурая треска
Items.spells[4607]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вкуснейший пещерный гриб
Items.spells[4791]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Заколдованная вода
Items.spells[6038]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гигантский жареный моллюск
Items.spells[6807]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Похлебка из лягушачьих окорочков
Items.spells[8364]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мифрилоголовая форель
Items.spells[10841]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Чай из златошипа
Items.spells[12210]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареный ящер
Items.spells[12213]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Десерт из мертвечины
Items.spells[12214]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Загадочная похлебка
Items.spells[13851]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Острая волчья грудинка
Items.spells[16169]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирожок с диким рисом
Items.spells[17407]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Домашний пирожок Гракку
Items.spells[18632]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Изумительный соус из Луноречья
Items.spells[19224]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Крылышки с красным перцем
Items.spells[20074]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сытная похлебка из кроколиска
Items.spells[61383]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Лаймовый пирог Гарра
Items.spells[63694]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Фруктовое мороженое без силитида
Items.spells[422]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Дворфийский мягкий сыр
Items.spells[733]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Похлебка Западного Края
Items.spells[1017]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Приправленная котлета из волчатины
Items.spells[1082]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гуляш по-красногорски
Items.spells[1114]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенный ржаной хлеб
Items.spells[1205]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Дынный сок
Items.spells[2136]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная чистая вода
Items.spells[2685]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сочные свиные ребрышки
Items.spells[3663]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Суп из плавников мурлока
Items.spells[3664]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Суп из кроколиска
Items.spells[3665]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Невероятно вкусный омлет
Items.spells[3666]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирожок из паучатины
Items.spells[3726]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Большой медвежий стейк
Items.spells[3727]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Острая отбивная из мяса льва
Items.spells[3770]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Баранья котлета
Items.spells[4538]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Дикий арбуз
Items.spells[4542]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Подмокший кукурузный хлеб
Items.spells[4593]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ощетиненная зубатка
Items.spells[4606]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Губчатые сморчки
Items.spells[5478]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Похлебка из пещерной крысы
Items.spells[5479]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящий хвост ящерицы
Items.spells[5480]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Постная оленина
Items.spells[5526]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Похлебка из моллюсков
Items.spells[5527]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мидии по-гоблински
Items.spells[7228]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Клубничное мороженое Тигуля и Форора
Items.spells[9451]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Вода с пузырьками
Items.spells[12209]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Постный стейк из волчатины
Items.spells[16170]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Манты на пару
Items.spells[19299]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Ярмарочная шипучка
Items.spells[19305]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Маринованная ножка кодо
Items.spells[46392]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из оленины
Items.spells[57518]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Потрясающее мороженое мистера Булька
Items.spells[60375]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Чудесный вишневый пирог
Items.spells[60377]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Очень мясной пирог
Items.spells[60378]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Втыквенный пирог
Items.spells[60379]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Куличик
Items.spells[65730]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сэндвичи с олениной
Items.spells[65731]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Шашлык из сердец йети
Items.spells[90660]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Черный чай
Items.spells[140753]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Недоеденный сладкий батончик
Items.spells[140754]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Промокший вафельный рожок
Items.spells[60267]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Деревенская тыква
Items.spells[60268]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Привет бродяги
Items.spells[60269]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Вода из колодца
Items.spells[21072]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Копченый шалфокунь
Items.spells[24105]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная вырезка лунного оленя
Items.spells[27635]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из рысятины
Items.spells[414]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Даларанский острый сыр
Items.spells[724]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирожок из печени кровоклыка
Items.spells[961]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Целебная трава
Items.spells[1113]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенный хлеб
Items.spells[1179]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Ледяное молоко
Items.spells[1326]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Соте из рыбы-луны
Items.spells[2287]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Окорок
Items.spells[2288]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная свежая вода
Items.spells[2682]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Вареная клешня краба
Items.spells[2683]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирожок с мясом краба
Items.spells[2684]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из койота
Items.spells[2687]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сушеные свиные ребрышки
Items.spells[3220]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кровяная колбаса
Items.spells[3448]		= TimeHealAndTimeMana({ru={1,2}, de={2,3}, cn={2,3}, kr={2,3}}) 		--Корень сенджины
Items.spells[3662]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Стейк из кроколиска
Items.spells[4537]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тел'абимские бананы
Items.spells[4541]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Свежевыпеченный хлеб
Items.spells[4592]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Острозубый илистый луциан
Items.spells[4605]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гриб с красной шляпкой
Items.spells[5066]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Ущельник
Items.spells[5095]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Радужный тунец
Items.spells[5476]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Филе бешенки
Items.spells[5477]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Похлебка из долгонога
Items.spells[5525]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Отварные мидии
Items.spells[6316]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Деликатес из бешенки
Items.spells[6890]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Копченая медвежатина
Items.spells[11584]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кактусовый десерт
Items.spells[12238]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Морской окунь Темных берегов
Items.spells[16167]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Разноцветный десерт
Items.spells[17119]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Шашлык из подземной крысы
Items.spells[17404]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сборная солянка с фасолью
Items.spells[17406]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Праздничный сыр
Items.spells[18633]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Леденцы Стилины
Items.spells[19304]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Острая бастурма
Items.spells[22645]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящий паучий десерт
Items.spells[24072]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Грушевый пирог
Items.spells[27636]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Закуска из летучей мыши
Items.spells[49365]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Отвар из древовидного вереска
Items.spells[49397]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Полусъеденная крыса
Items.spells[49600]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гоблинское песочное печенье
Items.spells[49601]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Вулканическая ключевая вода
Items.spells[63530]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Освежающий ананасовый пунш
Items.spells[67230]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Вяленая оленина
Items.spells[69920]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пряная похлебка из тараканов
Items.spells[90659]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Жасминовый чай
Items.spells[112095]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Полусъеденный банан
Items.spells[140338]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сдобренный маной пирожок из печени кровоклыка
Items.spells[117]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жесткая солонина
Items.spells[159]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Освежающая ключевая вода
Items.spells[787]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Скользкокожая скумбрия
Items.spells[2070]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Дарнасский блю
Items.spells[2679]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Волчатина на углях
Items.spells[2680]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Волчатина с пряностями
Items.spells[2681]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареная кабанина
Items.spells[2888]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кабаньи ребрышки в пиве
Items.spells[4536]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Спелое красное яблоко
Items.spells[4540]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Черствая краюха хлеба
Items.spells[4604]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Шляпка лесного гриба
Items.spells[4656]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Маленькая тыква
Items.spells[5057]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Спелый арбуз
Items.spells[5349]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сотворенный кекс
Items.spells[5350]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Сотворенная вода
Items.spells[5472]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Калдорайский шашлык из паука
Items.spells[5474]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Жареное мясо кодо
Items.spells[6290]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Блестящая рыбка
Items.spells[6299]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хилая рыбка
Items.spells[6888]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Яйцо с травами
Items.spells[7097]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Окорочок
Items.spells[7806]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Леденец
Items.spells[7807]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Сладкий батончик
Items.spells[7808]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Плитка шоколада
Items.spells[11109]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Цыплячий корм
Items.spells[12224]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хрустящее крылышко летучей мыши
Items.spells[16166]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Фасолевый суп
Items.spells[17197]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Имбирное печенье
Items.spells[17198]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Гоголь-моголь Зимнего Покрова
Items.spells[17344]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Конфетка
Items.spells[19223]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хот-дог Новолуния
Items.spells[20857]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Медовые лепешки
Items.spells[23495]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Закуска из прыголапа
Items.spells[23756]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Крабовый супчик поваренка
Items.spells[30816]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Хлеб с пряностями
Items.spells[44854]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кислая клюква из Болотины
Items.spells[44855]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Тельдрассильский батат
Items.spells[46690]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Шоколадный череп
Items.spells[46784]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Спелая элвиннская тыква
Items.spells[46793]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Кислая клюква с берегов реки Строптивой
Items.spells[46796]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Спелая тирисфальская тыква
Items.spells[46797]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Мулгорский батат
Items.spells[49253]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Слегка изъеденный червями сухарь
Items.spells[49254]		= TimeMana({ru=1, de=2, cn=2, kr=2}) 		--Собравшаяся на парусине роса
Items.spells[57544]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Остатки кабанины
Items.spells[77264]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Короткий побег бамбука
Items.spells[77272]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Короткий стебель сахарного тростника
Items.spells[77273]		= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Пирожок с рисом
Items.spells[140337]	= TimeHeal({ru=1, de=2, cn=2, kr=2}) 		--Заморская жесткая солонина
