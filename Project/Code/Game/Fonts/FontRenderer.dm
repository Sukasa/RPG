/FontRenderer
	var/LastTextIndex = -1
	var/Completed = FALSE

	var/Font/Font

//Render text to a Runtime/Text object
/FontRenderer/proc/Create(var/Text = "", var/MaxLines = 1, var/Width = 608, var/FontFace = /Font/CandelaBold26, var/Align = AlignLeft, var/Color = ColorWhite, var/StartIndex = 1, var/LinesOffset = 0, var/PixelX = 0, var/PixelY = 0, var/TextParams = null)
	Font = new FontFace()

	var/NumLines  = 0

	var/obj/Runtime/Text/Base = new()
	Base.layer = TextLayer

	var/StreamReader/Reader = new(Config.Lang.String(Text), TRUE)

	Reader.StripCarriageReturns()
	Reader.Seek(StartIndex)
	LastTextIndex = StartIndex

	// If we have been passed in text params, then inject them here
	if (!isnull(TextParams))
		if (IsList(TextParams))
			var/X = 1
			for(var/K in TextParams)
				Reader.Replace("\\[X]", "[TextParams[K]]")
				X++
		else
			Reader.Replace("\\1", "[TextParams]")

	var/list/LineTextBuffer = list( )
	var/LineWidth = 0

	while (!Reader.EOF())
		var/Word = Reader.TakeUntil(Space, LineFeed)
		var/WordWidth = GetWordWidth(Word) // Take one word at a time from the text to be rendered

		if (LineWidth + WordWidth <= Width) // If it fits on this line, add it to the text buffer for this line
			LineWidth += (WordWidth + Font.VWFTable[33]) // Increase the current line width
			LineTextBuffer += Word
			LastTextIndex = Reader.Index() + 1 // Save our place in the text in case we need to break it into a second text box line
			WordWidth = 0 // And zero the word width as a flag

		if (WordWidth || Reader.Is(LineFeed) || Reader.EOF()) // If the word didn't fit on the line, it's a line feed, or we're EOF
			var/obj/CurrentLine = RenderLine(JoinList(LineTextBuffer, " "), Color) // Render the new line of text
			CurrentLine.pixel_y = (-(LinesOffset + NumLines) * Font.LineSpacing) + PixelY // Set the Y position

			// Slice off the width of the last space character
			LineWidth -= Font.VWFTable[33] // 33 = Space character (ASCII 0x20 plus 1-based array)

			// Now X-position the line based on paragraph align
			switch (Align)
				if (AlignRight)
					CurrentLine.pixel_x = Width - LineWidth
				if (AlignCenter)
					CurrentLine.pixel_x = (Width / 2) - (LineWidth / 2)

			CurrentLine.pixel_x += PixelX
			Base.overlays += CurrentLine
			NumLines++

			// Now, if we're EOF or the textbox is full...
			if (Reader.EOF() || NumLines >= MaxLines)
				break // Exit while loop

			// Otherwise if it's a line feed create a new blank line
			if (Reader.Is(LineFeed))
				// Forced newline.
				LineWidth = 0
				LineTextBuffer = list( )

			// Lastly if the word didn't fit on the previous line, add it to this new line
			else //Word needs to be added to next line
				LineWidth = WordWidth + Font.VWFTable[33]
				LineTextBuffer = list(Word)
				LastTextIndex = Reader.Index() + 1

		Reader.Advance() // Advance past the linefeed / space character we stopped at

	Completed = Reader.EOF()

	// Clean up and return Base image here
	return Base

// Create a new line object and add the letters on as overlays
FontRenderer/proc/RenderLine(var/Text, var/Color)
	var/obj/Runtime/Line = new()
	var/image/I = image(Font.IconFile, layer = TextLayer)
	var/XPos = 0
	for(var/X = 1, X <= lentext(Text), X++)
		var/Char = copytext(Text, X, X + 1)
		if (Char != " ")
			I.icon_state = Char
			I.pixel_x = XPos + Font.XOffsets[Char]
			I.pixel_y = Font.YOffsets[Char]
			I.color = Color
			Line.overlays += I
		XPos += Font.VWFTable[text2ascii(Char) + 1] + 1 // CharWidths[CharASCII + 1-based array] + 1px base spacing
	return Line

FontRenderer/proc/GetWordWidth(var/Word)
	. = 0
	for(var/X = 1, X <= lentext(Word), X++)
		. += Font.VWFTable[text2ascii(Word, X) + 1] + 1

/obj/Runtime/Text
	layer = TextLayer