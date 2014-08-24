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
				Reader.Replace("\\[X]", "[K]")
				X++
		else
			Reader.Replace("\\1", "[TextParams]")

	var/list/LineTextBuffer = list( )
	var/LineWidth = 0

	while (!Reader.EOF())
		var/Word = Reader.TakeUntil(Space, LineFeed)
		var/WordWidth = GetWordWidth(Word)

		if (LineWidth + WordWidth <= Width)
			LineWidth += (WordWidth + Font.VWFTable[33])
			LineTextBuffer += Word
			LastTextIndex = Reader.Index() + 1
			WordWidth = 0

		if (WordWidth || Reader.Is(LineFeed) || Reader.EOF())
			var/obj/CurrentLine = RenderLine(JoinList(LineTextBuffer, " "), Color)
			CurrentLine.pixel_y = (-(LinesOffset + NumLines) * Font.LineSpacing) + PixelY

			LineWidth -= Font.VWFTable[33] // 33 = Space character
			switch (Align)
				if (AlignRight)
					CurrentLine.pixel_x = Width - LineWidth
				if (AlignCenter)
					CurrentLine.pixel_x = (Width / 2) - (LineWidth / 2)

			CurrentLine.pixel_x += PixelX

			Base.overlays += CurrentLine
			NumLines++

			if (Reader.EOF() || NumLines >= MaxLines)
				break // Exit while loop

			if (Reader.Is(LineFeed))
				// Forced newline.
				LineWidth = 0
				LineTextBuffer = list( )

			else //Word needs to be added to next line
				LineWidth = WordWidth + Font.VWFTable[33]
				LineTextBuffer = list(Word)
				LastTextIndex = Reader.Index() + 1

		Reader.Advance()

	Completed = Reader.EOF()

	// Clean up and return Base image here
	return Base

FontRenderer/proc/RenderLine(var/Text, var/Color)
	var/obj/Line = new()
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
		XPos += Font.VWFTable[text2ascii(Char) + 1] + 1
	return Line

FontRenderer/proc/GetWordWidth(var/Word)
	. = 0
	for(var/X = 1, X <= lentext(Word), X++)
		. += Font.VWFTable[text2ascii(Word, X) + 1] + 1

/obj/Runtime/Text
	layer = TextLayer