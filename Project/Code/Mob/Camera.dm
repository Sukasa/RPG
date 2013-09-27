/mob/Camera
	// Basic camera entity.
	density = 0
	bound_height = 2
	bound_width = 2
	bound_x = 15
	bound_y = 15
	var/PanSpeed = 1

	MoveSpeed()
		return PanSpeed

	Attached
		PanSpeed = 32