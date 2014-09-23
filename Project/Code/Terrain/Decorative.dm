turf/Decorative
	opacity = 0
	density = 0
	var/VarietyCount = 1
	var/BaseState = ""

turf/Decorative/Init()
	icon_state = "[BaseState][XYNoise(VarietyCount)]"
	. = ..()