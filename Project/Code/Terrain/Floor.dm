
turf/Floor
	opacity = 0
	density = 0
	name = "Floor"
	FloorplanIconState = "Floor"

	var
		NoVariety = FALSE
		VarietyCount = 1
		BaseState = ""

turf/Floor/Init()
	if (!NoVariety)
		var/Rnd = roll(1, VarietyCount) - 1
		icon_state = "[BaseState][Rnd]"
	return ..()

turf/Floor/Generic/Lab
	icon = 'LabFloor.dmi'
	BaseState = "Basic"
	icon_state = "Basic0"

turf/Floor/Generic
	icon = 'GenericInteriorFloors.dmi'

turf/Floor/Generic/Basic
	VarietyCount = 3
	BaseState = "Basic"
	icon_state = "Basic0"

turf/Floor/Sand
	name = "Sand"
	icon = 'Sand.dmi'
	VarietyCount = 3
	BaseState = "Sand"
	icon_state = "Sand0"

turf/Floor/DirtRoad
	name = "Dirt"
	icon = 'Sand.dmi'
	VarietyCount = 0
	BaseState = "DirtRoad"
	icon_state = "DirtRoad0"

/turf/Floor/Exterior
	NoVariety = TRUE
	name = "Grass"
	icon = 'Test01.dmi'

/turf/Floor/Exterior/Sand
	name = "Sand"
	icon = 'OutdoorSand.dmi'