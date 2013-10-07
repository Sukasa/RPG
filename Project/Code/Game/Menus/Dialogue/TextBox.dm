/obj/Runtime/TextBox
	icon = 'TextBox.dmi'
	screen_loc = "SOUTHWEST"

/obj/Runtime/NameBox
	icon = 'NameBox.dmi'
	screen_loc = "SOUTH+6, WEST"
	invisibility = Invisible

	proc
		Show()
			invisibility = Visible
		Hide()
			invisibility = Invisible