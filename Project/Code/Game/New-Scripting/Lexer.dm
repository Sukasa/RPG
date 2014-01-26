/*

	Lexical Analyzer for the new scripting engine

	Includes small hack to track line number for script errors

*/
/Lexer
	var
		StreamReader/Stream

		const
			Semicolon = ";"
			Colon = ":"
			Operator = "!-+*/%^&|=<>"
			Parentheses = "()\[]{}"
			Newline = "\n"
			StringCap = "\""
			Space = " "
			Tab = "\t"
			LineComment = "//"
			BlockCommentStart = "/*"

			EscapeCharacter = "\\"
			ForwardSlash = "/"
			Equals = "="
			BeginBlockCommentEnd = "*"

			EqualityOp = "=="

			Numeric = "0123456789."
			Identifier = "abcdefghijklmnopqrstuvwxyz0123456789_"

		list/Groups
		list/Terminals
		list/Escapes = list( "n" = "\n" )

		Line = 1
		LastTokenStart = 1
		RetrieveAsString = FALSE
		Token = ""

	// Setup
	New(var/UseStream)
		Stream = UseStream
		Stream.StripCarriageReturns()
		Groups = list(Semicolon, Parentheses, Colon, Operator, Numeric, Identifier, Newline)
		Terminals = list(Parentheses, Equals)
		Token = Get()


	// Get the current token without consuming it
	proc/Current()
		. = Token

	// Consume the current token and get the next one
	proc/Consume()
		. = Token
		Token = Get()

	// Get the next token from the input stream.  Comments and proper strings are handled in this and strings are returned as three tokens: Quote, String, Quote
	proc/Get()
		if(Stream.EOF())
			return null

		LastTokenStart = Line

		. = ""
		Stream.Skip(Space, Tab) // Skip whitespace

		if (RetrieveAsString)
			if (Stream.Is(StringCap))
				RetrieveAsString = FALSE
				Stream.Advance()
				return "\""
			else
				var/Escaped = FALSE

				while (!Stream.EOF())
					if (Escaped)
						var/C = TakeChar()
						. += (Escapes[C] ? Escapes[C] : C)
						Escaped = FALSE
					else if (Stream.Is(EscapeCharacter))
						Stream.Advance()
						Escaped = TRUE
					else if (Stream.Is(StringCap))
						return .
					else
						. += TakeChar()
				return null

		if (Stream.Is(StringCap))
			RetrieveAsString = TRUE
			Stream.Advance()
			return "\""

		var/Group = GetGroup(Stream.TChar())

		do
			var/Char = TakeChar()
			. += Char

			if (IsTerminal(Char))
				if (. == Equals && Stream.TChar() == Equals)
					Stream.Advance()
					return EqualityOp
				return .

			if (. == LineComment)
				Stream.SeekAfter(Newline)
				Line++

				if (Stream.EOF())
					return null

				. = TakeChar()
				Group = GetGroup(.)

			if (. == BlockCommentStart)
				do
					Stream.SeekTo(BeginBlockCommentEnd, Newline)
					if (Stream.Is(Newline))
						Line++
					Stream.Advance()
				while (!Stream.EOF() && Stream.Isnt(Backslash))

				if (Stream.EOF())
					return null

				. = TakeChar()
				Group = GetGroup(.)

		while (!Stream.EOF() && Group && GetGroup(Stream.TChar()) == Group)

	proc/TakeChar()
		. = Stream.Take()
		if (. == Newline)
			Line++

	proc/GetGroup(var/Character)
		for(var/S in Groups)
			if (findtext(S, Character))
				. = S
				return

	proc/IsTerminal(var/Character)
		. = FALSE
		for(var/S in Terminals)
			if (findtext(S, Character))
				. = TRUE
				return