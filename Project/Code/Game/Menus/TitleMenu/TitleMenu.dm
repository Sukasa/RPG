/datum/Menu/TitleScreen
	var
		EnterState = 0
		EnterEnabled = FALSE
		obj/Runtime/TitleGraphic/TG
		obj/Text

/datum/Menu/TitleScreen/Init()

	// Create title graphic
	TG = new()
	StaticElements += TG

	// Create 'press start' text
	Text = Config.Text.Create("Press Enter to Begin", FontFace = /datum/Font/LaconicShadow48, Width = 608, Align = AlignCenter)
	Text.screen_loc = "1,CENTER-3"
	Text.alpha = 0
	StaticElements += Text

	spawn
		animate(TG, alpha = 255, time = 30)
		sleep(30)
		animate(Text, alpha=255, time=20)
		sleep(15)
		EnterEnabled = TRUE
		sleep(25)
		animate(Text, alpha = 128, time = 40, loop = -1)
		animate(alpha = 192, time = 40)
	..()

/datum/Menu/TitleScreen/Input(var/Control)
	if (EnterEnabled && Control == ControlEnter)
		EnterState = 1
		EnterEnabled = FALSE
		animate(TG, alpha = 0, pixel_y = (TG.pixel_y + 90), time = 10)
		animate(Text, alpha = 0, time = 10)
		spawn(12)
			Config.Events.FadeOut()

/datum/Menu/TitleScreen/Tick()
	if (EnterState)
		EnterState++
	if (EnterState >= 45)
		return //TODO: Change to second menu