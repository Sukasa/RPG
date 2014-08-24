/proc/LoadLanguages()
	world.log << "Loading Languages"
	var/list/Files = GetMatchingFiles("Languages", "*.txt")
	world.log << "Found [Files["Count"]] language files"
	for(var/File in Files - "Count")
		File = Files[File]
		world.log << "<b>[File]</b>:"
		var/StreamReader/Stream = new(File)
		var/LanguageCode = Stream.TakeLine()
		var/list/LanguageTable = Config.Lang.Translations[LanguageCode]
		while (!Stream.EOF())
			var/Line = Stream.TakeLine()
			if(findtextEx(Line, "=") == 0 || findtextEx(Line, "#") == 1)
				continue
			world.log << Line
			var/KeySep = findtextEx(Line, "=")
			LanguageTable[copytext(Line, 1, KeySep)] = copytext(Line, KeySep + 1)
		Config.Lang.UpdateLanguageFile(LanguageCode, LanguageTable)

/proc/LoadSoundDefinitions()
	var/list/Files = GetMatchingFiles("Sounds/Definitions", ".txt")
	var/DefParser/Parser = new()
	for(var/File in Files)
		Parser.ParseDefinitionFile(File)

/proc/RegisterDevScriptFunctions()
	ScriptFunctions["LoadLanguages"] = /proc/LoadLanguages
	ScriptFunctions["LoadSoundDefinitions"] = /proc/LoadSoundDefinitions