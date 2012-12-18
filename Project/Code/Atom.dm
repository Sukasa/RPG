atom
	var

		CoverValue = 0	//Worthiness of an atom as cover.  100 is full protection, 0 is no protection
		BulletDensity = 0	//Whether you can fire over/through an atom.  Doesn't affect the ability of that atom to give cover

atom/proc/GetFineX()
	return (src.x * 32) + src.pixel_x

atom/proc/GetFineY()
	return (src.y * 32) + src.pixel_y

// Returns the angle to the passed atom, where 0° is due north
atom/proc/GetAngleTo(var/atom/To)
	var/dX = To.GetFineX() - src.GetFineX()
	var/dY = To.GetFineY() - src.GetFineY()
	if(!dY)
		return (dX >= 0) ? 90 : 270
	. = arctan(dX / dY)
	if(dY < 0)
		return . + 180
	if (dX < 0)
		return . + 360