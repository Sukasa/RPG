/obj/Machinery/Trap/PressurePlate
	name = "Pressure Plate"
	mouse_opacity = 0
	icon = 'PressurePlate.dmi'
	icon_state = "PadVisible"

	Stealthed
		icon_state="PadInvisible"

/obj/Machinery/Trap/PressurePlate/New()
	. = ..()
	Knowledge = image('PressurePlate.dmi', src, "PadKnowledge", OBJ_LAYER)

/obj/Machinery/Trap/PressurePlate/Crossed()
	. = ..()
	Activate()
	icon_state = "PadDown"

/obj/Machinery/Trap/PressurePlate/Uncrossed()
	. = ..()
	spawn(10)
		if (Deactivate())
			icon_state = initial(icon_state)

