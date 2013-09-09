/datum/TranslationController
	var/list/Strings = list( )
	var/list/Languages = list( )
	var/CurrentLang = DefaultLanguage
	var/savefile/Translations = null

/datum/TranslationController/proc/Init()
	if (fexists("LDATA"))
		Translations = new/savefile("LDATA")
		Translations[".index"] >> Languages
	if (fexists("DLANG"))
		var/savefile/DefaultLang = new/savefile("DLANG")
		var/Lang
		DefaultLang >> Lang
		del DefaultLang
		LoadLanguageFile(Lang)
	else
		LoadLanguageFile(DefaultLanguage)


/datum/TranslationController/proc/LoadLanguageFile(var/Code)
	if (Translations)
		Translations[Code] >> Strings
		if (!Strings)
			Strings = list( )
	var/savefile/DefaultLang = new/savefile("DLANG")
	DefaultLang << Code


/datum/TranslationController/proc/String(var/StringCode)
	. = Strings[StringCode]
	if (!.)
		return StringCode