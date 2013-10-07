Menu/Dialogue
	var
		EnterEnabled = FALSE
		obj/Text
		obj/Name
		obj/Runtime/TextBox/TB
		obj/Runtime/DialogueAdvance/Advance
		list/Params[]
		NextLineTime = 0
		Drawing = FALSE
		Delay = 10
		var/QueuedDialogue/Dialogue

		var/LineNum = 0
		var/TextIndex = 1
		const
			TextScreenLocation = "SOUTH + 4, WEST"

Menu/Dialogue/Init()

	// Create title graphic
	TB = new()
	StaticElements += TB

	Advance = new()
	StaticElements += Advance

	..()

	Next()

Menu/Dialogue/proc/Next()
	if (Client.QueuedDialogue.IsEmpty())
		Dialogue = null
	else
		Dialogue = Client.QueuedDialogue.Dequeue()
		Drawing = TRUE
		ClearDynamicElements()
		Delay = 0
		LineNum = initial(LineNum)
		TextIndex = initial(TextIndex)
		if (Dialogue.Name)
			return

Menu/Dialogue/Tick()
	if (Drawing && Delay <= 0)
		Delay += initial(Delay)
		DrawLine()

Menu/Dialogue/proc/DrawLine()
	Text = Config.Text.Create(Dialogue.Text, Lines = 1, Width = 532, StartIndex = TextIndex, LinesOffset = LineNum)
	Text.screen_loc = TextScreenLocation
	DynamicElements += Text
	if (Config.Text.Completed)
		Drawing = FALSE
		LineNum = 0
		Delay = 0
	else
		LineNum++
		if (LineNum == 5)
			Drawing = FALSE
		TextIndex = Config.Text.LastTextIndex
	ShowElementToClient(Text)

Menu/Dialogue/Input(var/Control)
	if (Control == ControlEnter)
		if (Drawing)
			Delay = NegativeInfinity
		else if (LineNum == 0)
			Drawing = TRUE
			ClearDynamicElements()
		else
			Next()
			if (!Dialogue)
				ExitMenu()
