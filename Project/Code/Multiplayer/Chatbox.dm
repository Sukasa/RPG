/datum/ChatLine
	var/list/Text = list()
	var/NumLines = 1

/obj/Runtime/LetterBG
	icon = 'TextBackground.dmi'
	icon_state = "Line"
	mouse_opacity = FALSE
	pixel_x = ChatboxOffsetX
	pixel_y = ChatboxOffsetY

/obj/Runtime/Chatbox
	icon = 'Text.dmi'
	mouse_opacity = FALSE
	screen_loc = "1,1"
	var/SkipTimedRemoval = 0	//Number of times to skip timed removal.  Only used if a high speech rate has overfilled the text box
	var/list/Lines = list()
	var/DrawnLines = 0

/obj/Runtime/Chatbox/proc/RemoveLine(var/Force = 0)
	if (!SkipTimedRemoval || Force)
		var/datum/ChatLine/Line = Lines[Lines.len]
		Lines.Cut(1, 2)
		DrawnLines -= Line.NumLines
		Render()
	if (SkipTimedRemoval && !Force)
		SkipTimedRemoval--

/obj/Runtime/Chatbox/proc/Render()
	overlays = null
	for(var/datum/ChatLine/ChatLine in Lines)
		overlays += ChatLine.Text

/obj/Runtime/Chatbox/proc/WriteLine(var/Line as text)
	var/datum/ChatLine/ChatLine = CreateChatLine(Line)
	for(var/datum/ChatLine/ExistingLine in Lines)
		for(var/atom/Letter in ExistingLine.Text)
			Letter.pixel_y += (12 * ChatLine.NumLines)
	while (DrawnLines + ChatLine.NumLines > MaxChatboxHeight)
		RemoveLine(TRUE)
		SkipTimedRemoval++
	Lines += ChatLine
	Render()
	DrawnLines+= ChatLine.NumLines
	spawn(SpeechLifetime)
		RemoveLine()

/obj/Runtime/Chatbox/proc/CreateChatLine(var/Line as text)
	var/datum/ChatLine/ChatLine = new()
	var/CurrentLineWidth = ChatboxOffsetX
	var/WordWidth = 0
	var/list/WordBuffer = list()
	ChatLine.Text += new/obj/Runtime/LetterBG()
	for(var/X = 1, X <= length(Line), X++)
		var/obj/Runtime/HUD/Letter/Letter = new()
		var/LetterASCII = text2ascii(Line, X)
		if (LetterASCII > VWF.len)
			continue
		var/LetterWidth = VWF[LetterASCII + 1]
		if (LetterASCII != 32) //Space
			Letter.pixel_x = WordWidth
			Letter.icon_state = "[LetterASCII]"
			WordWidth += LetterWidth + 1
			WordBuffer += Letter
		else
			if (CurrentLineWidth + WordWidth > 400 + ChatboxOffsetX)
				CurrentLineWidth = ChatboxOffsetX
				ChatLine.NumLines++
				for (var/atom/A in ChatLine.Text)
					A.pixel_y += 12
				ChatLine.Text += new/obj/Runtime/LetterBG()
			for(var/atom/A in WordBuffer)
				A.pixel_x += CurrentLineWidth
				ChatLine.Text += A
			WordBuffer = list()
			CurrentLineWidth += WordWidth + LetterWidth
			WordWidth = 0
	for(var/atom/A in WordBuffer)
		A.pixel_x += CurrentLineWidth
		ChatLine.Text += A
	return ChatLine