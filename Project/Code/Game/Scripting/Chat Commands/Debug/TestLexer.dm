/ChatCommand/TestLexer
	Command = "tl"

	Execute()
		var/ScriptName = "Test_Script_3.txt"
		var/Lexer/Lexer = new(new/StreamReader(ScriptName))
		world.log << "Reading tokens of script [ScriptName]"
		while (Lexer.Current())
			world.log << Lexer.Consume()
		world.log << "<EOF>"