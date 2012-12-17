// Replace get_step with something that supports ANY atom with x/y/z
proc/_getstep(var/atom/O, var/Direction)
	var/x = O.x
	var/y = O.y
	var/z = O.z
	if (Direction & NORTH)
		y += 1
	if (Direction & SOUTH)
		y -= 1
	if (Direction & EAST)
		x += 1
	if (Direction & WEST)
		x -= 1
	return locate(x, y, z)

#define get_step _getstep