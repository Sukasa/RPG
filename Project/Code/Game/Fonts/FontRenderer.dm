/FontRenderer
	var/LastTextIndex = -1
	var/Completed = FALSE

	var/datum/Font/Font

/FontRenderer/proc/Create(var/Text = "", var/Lines = 1, var/Width = 200, var/FontFace = /datum/Font/CandelaBold26, var/Align = AlignLeft, var/Color = ColorWhite, var/StartIndex = 1, var/LinesOffset = 0)
	var/NumLines  = 0

	var/obj/Runtime/Text/Base = new()
	Base.layer = UILayer

	var/StreamReader/Reader = new(Config.Lang.String(Text))
	Reader.StripCarriageReturns()
	Reader.Seek(StartIndex)
	LastTextIndex = StartIndex

	var/list/LineTextBuffer = list( )
	Font = new FontFace()

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
			CurrentLine.pixel_y = -(LinesOffset + NumLines) * Font.LineSpacing

			LineWidth -= Font.VWFTable[33]
			switch (Align)
				if (AlignRight)
					CurrentLine.pixel_x = Width - (LineWidth)
				if (AlignCenter)
					CurrentLine.pixel_x = (Width / 2) - (LineWidth / 2)


			Base.overlays += CurrentLine
			NumLines++

			LineTextBuffer = list( )
			LineWidth = 0

			if (Reader.EOF() || NumLines >= Lines)
				break // Exit while loop

			else if (Reader.Is(LineFeed))
				// Forced newline.  No need to do anything special

			else //Word needs to be added to next line
				LineWidth = WordWidth + Font.VWFTable[33]
				LineTextBuffer += Word
				LastTextIndex = Reader.Index() + 1

		Reader.Advance()

	Completed = Reader.EOF()

	// Clean up and return Base image here

	return Base

FontRenderer/proc/RenderLine(var/Text, var/Color)
	var/obj/Line = new()
	var/XPos = 0
	for(var/X = 1, X <= lentext(Text), X++)
		var/Char = copytext(Text, X, X + 1)
		if (Char != " ")
			var/image/I = image(Font.IconFile, icon_state = Char, layer = UILayer)
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
	layer = UILayer