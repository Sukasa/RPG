Menu/Dialogue
	var
		EnterEnabled = FALSE
		obj/Text
		obj/Name
		obj/Runtime/TextBox/TB
		obj/Runtime/NameBox/NB
		obj/Runtime/DialogueAdvance/Advance
		list/Params[]
		NextLineTime = 0
		Drawing = FALSE
		Delay = 10
		var/QueuedDialogue/Dialogue

		var/LineNum = 0
		var/TextIndex = 1
		var/Selection = TRUE
		var/MaxLines = 5

		const
			TextScreenLocation = "SOUTH+4,WEST+1"
			NameScreenLocation = "SOUTH+6,WEST+1"

			TextYesLocation = "SOUTH+2,CENTER-4"
			YesScreenLocation = "SOUTH+2,CENTER-5:12"

			TextNoLocation = "SOUTH+2,CENTER+2"
			NoScreenLocation = "SOUTH+2,CENTER+1:12"

Menu/Dialogue/Init()

	// Create title graphic
	NB = new()
	StaticElements += NB

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
		ClearDynamicElements()
		Dialogue = Client.QueuedDialogue.Dequeue()
		Drawing = TRUE
		LineNum = initial(LineNum)
		TextIndex = initial(TextIndex)
		Delay = initial(Delay)
		Advance.screen_loc = initial(Advance.screen_loc)

		NB.invisibility = Dialogue.Name ? Visible : Invisible
		if (Dialogue.Name)
			DrawName()

		if (IsPrompt())
			MaxLines = 3
		else
			MaxLines = 5

Menu/Dialogue/Tick()
	Advance.invisibility = Drawing ? Invisible : Visible
	while (Drawing && Delay <= 0)
		Delay += initial(Delay)
		DrawLine()
	Delay--

Menu/Dialogue/Input(var/Control)
	if (Control == ControlEnter)
		if (Drawing)
			Delay = NegativeInfinity
		else if (LineNum >= MaxLines)
			Drawing = TRUE
			LineNum = 0
			ClearDynamicElements()
			Delay = initial(Delay)
		else
			if (IsPrompt())
				Config.Events.RunScript(Selection ? Dialogue.ScriptYes : Dialogue.ScriptNo, Client.mob)
			Next()
			if (!Dialogue)
				ExitMenu()
	else if (IsPrompt() && (Control == ControlLeft || Control == ControlRight))
		Selection = !Selection
		PositionMenuCursor()


Menu/Dialogue/proc/DrawName()
	Text = Config.Text.Create(Dialogue.Name, Width = 146, StartIndex = TextIndex, LinesOffset = LineNum, PixelX = 4)
	Text.screen_loc = NameScreenLocation
	DynamicElements += Text
	ShowElementToClient(Text)

Menu/Dialogue/proc/DrawLine()
	Text = Config.Text.Create(Dialogue.Text, Width = 532, StartIndex = TextIndex, LinesOffset = LineNum, PixelX = 4)
	Text.screen_loc = TextScreenLocation
	DynamicElements += Text
	ShowElementToClient(Text)

	if (Config.Text.Completed)
		Drawing = FALSE
		LineNum = 0
		Delay = 0
	else
		LineNum++
		if (LineNum >= MaxLines)
			Drawing = FALSE
		TextIndex = Config.Text.LastTextIndex

	if (IsPrompt())
		Selection = initial(Selection)
		DrawYesNo()
		PositionMenuCursor()

Menu/Dialogue/proc/DrawYesNo()
	Text = Config.Text.Create("Prompt.Yes")
	Text.screen_loc = TextYesLocation
	DynamicElements += Text
	ShowElementToClient(Text)

	Text = Config.Text.Create("Prompt.No")
	Text.screen_loc = TextNoLocation
	DynamicElements += Text
	ShowElementToClient(Text)

Menu/Dialogue/proc/PositionMenuCursor()
	Advance.screen_loc = Selection ? YesScreenLocation : NoScreenLocation

Menu/Dialogue/proc/IsPrompt()
	return !(isnull(Dialogue.ScriptYes) && isnull(Dialogue.ScriptNo))