/ChatCommand/TestParser
	Command = "tparse"

	Execute()
		var/Parser/Parser = new()

		Parser.Functions = list("sleep" = "sleep()")

		var/ASTNode/Node = Parser.ParseScript("Test_Script_3.txt")
		if (Node)
			Node.Output()