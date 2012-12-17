atom
	var
		//Worthiness of an atom as cover.  100 is full protection, 0 is no protection
		CoverValue = 0

		//Whether you can fire over/through an atom.  Doesn't affect the ability of that atom to give cover
		BulletDensity = 0


atom/proc/GetAngleTo(var/atom/To)
	return arctan(-(To.x - src.y) / (To.x - src.x))