/proc/LoadLanguages()
	var/list/Files = GetMatchingFiles("Languages", ".txt")
	for(var/File in Files)
		var/StreamReader/Stream = new(File)
		var/list/LanguageTable = Stream.TakeLine()
		LanguageTable = Config.Lang.Translations[LanguageTable]
		while (!Stream.EOF())
			var/Line = Stream.TakeLine()
			if(findtextEx(Line, "=") == 0 || findtextEx(Line, "#") == 1)
				continue
			var/KeySep = findtextEx(Line, "=")
			LanguageTable[copytext(1, KeySep)] = copytext(Line, KeySep + 1)

/proc/LoadSoundDefinitions()
	var/list/Files = GetMatchingFiles("Sounds/Definitions", ".txt")
	var/DefParser/Parser = new()
	for(var/File in Files)
		Parser.ParseDefinitionFile(File)

/proc/RegisterDevScriptFunctions()
	ScriptFunctions["LoadLanguages"] = /proc/LoadLanguages
	ScriptFunctions["LoadSoundDefinitions"] = /proc/LoadSoundDefinitions