/obj/Runtime/DialogueAdvance
	icon = 'DialogueAdvance.dmi'
	screen_loc = "SOUTH+1, EAST-1"
	invisibility = Invisible
	layer = TextLayer

	proc
		Show()
			invisibility = Visible

		Hide()
			invisibility = Invisible