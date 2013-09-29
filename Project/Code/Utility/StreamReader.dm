/datum/StreamReader
	var
		SeekPosition = 1
		TextFile

	New(var/File)
		// If is (Filename or File data as text)
		if (istext(File))
			if(fexists(File)) // Is it a filename?
				TextFile = file2text(file(File)) // Then load it
			else
				TextFile = File // Nope, just the file text.  Use as-is
		else // Is file object
			TextFile = file2text(File)

	proc
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
