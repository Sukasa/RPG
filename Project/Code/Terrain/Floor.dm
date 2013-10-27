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