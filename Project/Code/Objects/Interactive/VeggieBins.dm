/obj/Interactive/Veggies
	name = "Vegetables"
	density = TRUE
	icon = 'Resources.dmi'
	icon_state = "Empty"

	var/Description = "It's empty."

	Init()
		. = ..()
		if (icon_state != "Empty")
			Description = "It's full of [icon_state]"
		var/obj/O = new(get_step(loc, SOUTH))
		O.step_x = step_x
		O.step_y = step_y
		O.density = FALSE
		O.name = name
		O.icon = icon
		O.icon_state = "ContainerFeet"

	InteractWith(var/mob/Player)
		Config.Events.Dialogue(Player, Description)