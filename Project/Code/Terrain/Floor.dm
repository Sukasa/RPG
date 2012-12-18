
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
	VarietyCount = 3
	BaseState = "Basic"
	icon_state = "Basic0"

turf/Floor/Sand
	icon = 'Sand.dmi'
	VarietyCount = 3
	BaseState = "Sand"
	icon_state = "Sand0"