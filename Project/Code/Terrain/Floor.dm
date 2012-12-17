
turf
	Floor
		opacity = 0
		density = 0

		var
			NumVariations = 0
			BaseState = ""

		New()
			. = ..()
			var/Rnd = roll(1, NumVariations) - 1
			icon_state = "[BaseState][Rnd]"

		Generic
			icon = 'GenericInteriorFloors.dmi'


			Basic
				BaseState = "Basic"
				icon_state = "Basic0"