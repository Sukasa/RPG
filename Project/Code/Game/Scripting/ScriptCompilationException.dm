/ScriptCompilationException
	var
		Message
		Line
		Character

	New(var/nMessage, var/nLine = -1, var/nCharacter = -1)
		Message = nMessage
		Line = nLine
		Character = nCharacter

	proc
		GetFormattedMessage()
			. = "Script compilation error:\n"
			. += Message
			. += "\n"
			if (Line >= 0)
				. += "at line [Line]\n"
				if (Line >= 0)
					. += "character [Character]"