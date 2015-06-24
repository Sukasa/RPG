// Updates all languages in the translation table with new entries from file
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

// Outputs a list of known sound definitions to the world logfile
/proc/ListSoundDefinitions()
	for(var/K in Config.Audio.DefinitionIndex)
		world.log << K

// Outputs detailed information about a given sound definition
/proc/DisplaySoundDef(var/DefKey)
	var/datum/D = Config.Audio.Definitions[DefKey]
	world.log << "[DefKey]: [D]"
	if (D)
		for(var/K in D.vars)
			world.log << "[K]: [D.vars[K]]"

// Loads all sound definitions on file to cache
/proc/LoadSoundDefinitions()
	var/list/Files = GetMatchingFiles("Sounds\\Definitions", "*.txt")
	var/DefParser/Parser = new()
	var/list/OriginalDefs = Config.Audio.DefinitionIndex.Copy()
	var/list/Definitions = list()
	var/list/Overwritten = list()
	for(var/File in Files - "Count")
		File = Files[File]
		var/list/Added = Parser.ParseDefinitionFile(File)
		Overwritten |= (Definitions & Added)
		Definitions |= Added

	world.log << "<b>Updated definitions:</b>"
	for(var/SFX in Definitions & OriginalDefs)
		world.log << SFX

	world.log << "<b>Loaded definitions:</b>"
	for(var/SFX in Definitions - OriginalDefs)
		world.log << SFX

	if (Overwritten.len)
		world.log << "<b><font color=\"#990000\">The following sound definitions are multiply-declared:</font></b>"
		for(var/SFX in Overwritten)
			world.log << SFX

// Registers the dev scripting functions into the function list passed to the script parser
/proc/RegisterDevScriptFunctions()
	ScriptFunctions["LoadLanguages"] = /proc/LoadLanguages
	ScriptFunctions["LoadSoundDefinitions"] = /proc/LoadSoundDefinitions
	ScriptFunctions["ListSoundDefinitions"] = /proc/ListSoundDefinitions
	ScriptFunctions["DisplaySoundDef"] = /proc/DisplaySoundDef