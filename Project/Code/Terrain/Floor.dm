
turf/Floor
	opacity = 0
	density = 0

	var
		VarietyCount = 1
		BaseState = ""

turf/Floor/New()
	. = ..()
	var/Rnd = roll(1, VarietyCount) - 1
	icon_state = "[BaseState][Rnd]"

turf/Floor/Generic
	icon = 'GenericInteriorFloors.dmi'

turf/Floor/Generic/Basic
	BaseState = "Basic"
	icon_state = "Basic0"