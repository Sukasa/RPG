
turf/Floor
	opacity = 0
	density = 0
	name = "Floor"
	FloorplanIconState = "Floor"

	var
		NoInit = FALSE
		VarietyCount = 1
		BaseState = ""

turf/Floor/Init()
	if (NoInit)
		return
	var/Rnd = roll(1, VarietyCount) - 1
	icon_state = "[BaseState][Rnd]"
	..()

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
	NoInit = TRUE
	name = "Grass"
	icon = 'Test01.dmi'

/turf/Floor/Exterior/Sand
	icon = 'OutdoorSand.dmi'