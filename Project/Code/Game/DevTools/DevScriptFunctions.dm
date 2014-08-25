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
	var/list/Files = GetMatchingFiles("Sounds\\Definitions", "*.txt")
	var/DefParser/Parser = new()
	var/list/Definitions = list()
	var/list/Overwritten = list()
	for(var/File in Files - "Count")
		File = Files[File]
		var/list/Added = Parser.ParseDefinitionFile(File)
		Overwritten |= (Definitions & Added)
		Definitions |= Added

	world.log << "<b>Loaded definitions:</b>"
	for(var/SFX in Definitions)
		world.log << SFX

	if (Overwritten.len)
		world.log << "<b>The following sound definitions are multiply-declared:</b>"
		for(var/SFX in Overwritten)
			world.log << SFX


/proc/RegisterDevScriptFunctions()
	ScriptFunctions["LoadLanguages"] = /proc/LoadLanguages
	ScriptFunctions["LoadSoundDefinitions"] = /proc/LoadSoundDefinitions