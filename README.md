#SpellDamage
It is a World Of Warcraft addon that displays spell's damage, heal or absorb on the action bar.

#Restrictions
Works only in WOW **6.2** version and only if **Display Point as Average** setting is **on**.   
Supports user interfaces: standard, ElvUi.

Works only in next locales:

* English (enUS, enGB),  
* Russian (ruRU),
* German (deDE),
* Spanish (esES),
* French (frFR),
* Italian (itIT),
* Brazilian Portuguese (ptBR),
* Simplified Chinese (zhCN).

This addon doesn't works in Korean (koKR), Latin American Spanish (esMX) and Traditional Chinese (zhTW) locales. Sorry.

Is Russian locale additionally displays items's (potions, food & drinks, bandages, ...) data on action bar.

#Installation
Just copy **SpellDamage** folder to **World of Warcraft\\Interface\\AddOns\\**.


#How does is works?!
This addon just take some digits from spell's description and displays it.

Unlike **DrDamage** this addon don't calculate values\* and unlike **MyDamage**, values is absolute and independent from the target\*\*.  
_\*Actually, in some cases this addon calculate values if it needed. For example, if spell always critical hits.  
\**Actually, values may depends from the target. For example, 'Breath of Fire' makes also DOT damage if target has 'Dizzying Haze' debuff._

#Chat commands
>**/sd** or **/spelldamage** - show commands list  
>**/sd status** - show current settings  
>**/sd items** - enable/disable displays data on items (works only in Russian locale)  
>**/sd errors** - enable/disable errors printing in chat  
>**/sd macroshelp** -  show help for macros usage  
>**/sd version** - show current addon version

#Usage with macros
This addon supports data displaying on a macros. For this just add to macros code `\#sd *id*`, where *id* - spell's id, which data you want to see. For example, **\#sd 56641** displays  data of "Steady Shot" spell on your macros on the action bar.

#Screenshots
![_image not found_](screenshots/1.jpg)

![_image not found_](screenshots/2.jpg)

More in [screenshots folder](https://github.com/Demonist/SpellDamage/tree/master/screenshots/).

#Have a question?
Write - **demonist616@gmail.com**