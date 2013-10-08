StreamReader
	var
		SeekPosition = 1
		TextFile

	New(var/File)
		if (istext(File))
			if(Debug && fexists(File))
				TextFile = file2text(file(File))
			else
				TextFile = File
		else
			TextFile = file2text(File)

	proc
		Replace(var/Needle, var/Replacement)
			var/Pos = findtextEx(TextFile, Needle)
			var/NLen = length(Needle)
			var/RLen = length(Replacement)

			while (Pos)
				TextFile = copytext(TextFile, 1, Pos) + Replacement + copytext(TextFile, Pos + NLen)
				Pos = findtextEx(TextFile, Needle, Pos + RLen)

		Index()
			return SeekPosition

		EOF()
			return SeekPosition > lentext(TextFile)

		Find(var/Needle, var/Start=1, var/End = 0)
			return findtext(TextFile, Needle, Start, End)

		Advance(var/Amt = 1)
			SeekPosition += Amt

		StripCarriageReturns()
			var/Pos = findtext(TextFile, ascii2text(13), 1)
			while (Pos)
				TextFile = copytext(TextFile, 1, Pos) + copytext(TextFile, Pos + 1)
				Pos = findtext(TextFile, ascii2text(13), Pos)

		Seek(var/Position)
			SeekPosition = Position

		SeekTo()
			while (Isnt(args))
				Advance()
				ASSERT(SeekPosition < lentext(TextFile))

		SeekAfter()
			SeekThrough(args)
			Advance()

		SeekThrough()
			while (Isnt(Denest(args)))
				Advance()
				ASSERT(SeekPosition < lentext(TextFile))
			do
				Advance()
			while (Is(Denest(args)))
			Advance(-1)

		Isnt()
			return !Is(Denest(args))

		Is()
			return Char() in Denest(args)

		Denest(var/list/A)
			return IsList(A[1]) ? A[1] : A

		Char()
			return text2ascii(TextFile, SeekPosition)

		TChar()
			return ascii2text(Char())

		Take(var/Chars = 1)
			ASSERT(SeekPosition <= lentext(TextFile))
			. = copytext(TextFile, SeekPosition, SeekPosition + Chars)
			SeekPosition += Chars

		TakeUntil()
			ASSERT(SeekPosition <= lentext(TextFile))
			while (!EOF() && Isnt(Denest(args)))
				. += Take()
