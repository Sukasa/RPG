/ChatCommand/ImportLang
	Command = "importlang"

/ChatCommand/ImportLang/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len != 2)
		DebugText("Usage: importlang \[File] \[LanguageCode]")
		return
	if (!fexists(Params[1]))
		ErrorText("That file does not exist")
		return
	world.log << "Updating language file: [Params[1]] => [Params[2]]"
	var/StreamReader/Reader = new(Params[1])
	Reader.StripCarriageReturns()
	var/list/L = list( )
	while (!Reader.EOF())
		var/Key = Reader.TakeUntil(Equals)
		if (Key in L)
			ErrorText("Key '[Key]' already present in language file!")
			return
		Reader.Advance()
		L[Key] = replacetext(Reader.TakeUntil(LineFeed), "\\n", "\n")
		//world.log << "[Key] => [L[Key]]"
		Reader.Advance()

	Config.Lang.UpdateLanguageFile(Params[2], L)