/TranslationController
	var/list/Strings = list( )
	var/list/Languages = list( )
	var/CurrentLang = DefaultLanguage
	var/savefile/Translations = null

/TranslationController/proc/Init()
	if (fexists("LDATA"))
		Translations = new/savefile("LDATA")
		Translations[".index"] >> Languages
	else
		Translations = new/savefile("LDATA")
	if (fexists("DLANG"))
		var/savefile/DefaultLang = new/savefile("DLANG")
		var/Lang
		DefaultLang >> Lang
		del DefaultLang
		LoadLanguageFile(Lang)
	else
		LoadLanguageFile(DefaultLanguage)

/TranslationController/proc/UpdateLanguageFile(var/Code, var/list/Table)
	Translations[Code] << Table
	Languages |= Code
	Translations[".index"] << Languages
	LoadLanguageFile(Code)

/TranslationController/proc/LoadLanguageFile(var/Code)
	if (Translations)
		Translations[Code] >> Strings
		if (!Strings)
			Strings = list( )
	var/savefile/DefaultLang = new/savefile("DLANG")
	DefaultLang << Code
	del DefaultLang

/TranslationController/proc/String(var/StringCode)
	return Strings[StringCode] || StringCode