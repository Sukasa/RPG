turf/Decorative
	opacity = 0
	density = 0
	var/VarietyCount = 1
	var/BaseState = ""

turf/Decorative/Init()
	icon_state = "[BaseState][LocRoll(VarietyCount)]"
	. = ..()

turf/Decorative/proc/LocRoll(var/NumSides)
	. = max(round((x - y) * 3 * tan(((x * y) + x) * 38.5)), 0) % NumSides