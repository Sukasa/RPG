// Basic hitscan object
/obj/Runtime/Hitscan
	var
		Effects = EffectsNone
	density = 0

/obj/Runtime/Hitscan/New()
	. = ..()
	loc = null

/obj/Runtime/Hitscan/proc/Scan(var/atom/Location, var/StepX, var/StepY, var/Width, var/Height)
	bound_width = Width
	bound_height = Height
	Move(Location, 0, StepX, StepY)
	Move(null) // does this work, I wonder...