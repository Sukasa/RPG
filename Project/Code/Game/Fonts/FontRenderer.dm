/datum/FontRenderer
	var/LastTextIndex = -1
	var/Completed = FALSE

/datum/FontRenderer/proc/Create(var/Text = "", var/Lines = 2, var/Width = 200, var/FontFace = /datum/Font/CandelaBold26, var/Align = AlignLeft, var/X = 0, var/Y = 0, var/Color = ColorWhite, var/StartIndex = 0)

	// TODO Refactor and implement DRY

	var/obj/Runtime/Text/Base = new()
	var/obj/CurrentLine = new()
	var/NumLines = 0
	var/LineWidth = 0
	var/image/I = null
	var/datum/Font/Font = new FontFace()
	var/list/LetterBuffer = list( )
	var/WordOffset = 0
	var/NewLine = FALSE

	Completed = FALSE

	for(var/Index = 1, Index <= lentext(Text), Index++)
		var/Char = copytext(Text, Index, Index + 1)
		NewLine = FALSE
		switch(Char)
			if(" ")
				if (LineWidth + WordOffset <= Width)
					for (var/image/Letter in LetterBuffer)
						Letter.pixel_x += LineWidth
						CurrentLine.overlays += Letter
					LetterBuffer = list( )
					LineWidth += WordOffset + Font.VWFTable[33]
					WordOffset = 0
					LastTextIndex = Index + 1
				else
					// Newline
					NewLine = TRUE
			if ("\n")
				// Newline
				NewLine = TRUE
			else
				I = image(Font.IconFile, icon_state = Char)
				I.pixel_x = WordOffset + Font.XOffsets[Char]
				I.pixel_y = Font.YOffsets[Char]
				I.color = Color
				WordOffset += Font.VWFTable[text2ascii(Char) + 1] + 1
				LetterBuffer += I

		if (NewLine)
			LastTextIndex = Index + 1

			for (var/image/Letter in LetterBuffer)
				Letter.pixel_x += LineWidth
				CurrentLine.overlays += Letter

			LineWidth += WordOffset

			switch (Align)
				if (AlignRight)
				 CurrentLine.pixel_x = Width - LineWidth
				if (AlignCenter)
				 CurrentLine.pixel_x = (Width / 2) - (LineWidth / 2)

			Base.overlays += CurrentLine
			CurrentLine = new()

			LetterBuffer = list( )
			LineWidth = 0
			WordOffset = 0

			NumLines++
			if (NumLines >= Lines)
				return Base
			CurrentLine.pixel_y = -NumLines * Font.LineSpacing

	if ((LineWidth + WordOffset <= Width) || LetterBuffer.len)
		for (var/image/Letter in LetterBuffer)
			Letter.pixel_x += LineWidth
			CurrentLine.overlays += Letter

		LetterBuffer = list( )
		LineWidth += WordOffset

		switch (Align)
			if (AlignRight)
				CurrentLine.pixel_x = Width - LineWidth
			if (AlignCenter)
				CurrentLine.pixel_x = (Width / 2) - (LineWidth / 2)

		Base.overlays += CurrentLine

		Completed = TRUE
	return Base


/obj/Runtime/Text
	layer = UILayer