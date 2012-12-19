atom
	var
		CoverValue = 0		// Worthiness of an atom as cover.  100 is full protection, 0 is no protection
		BulletDensity = 0	// Whether you can fire over/through an atom.  Doesn't affect the ability of that atom to give cover.
		CanTarget = TRUE	// Whether you can target an atom directly.  Right-clicking an object with this set to false will just fire in that general direction

atom/movable/proc/GetFineX()
	return (src.x * 32) + src.step_x

atom/movable/proc/GetFineY()
	return (src.y * 32) + src.step_y

/atom/movable/proc/GetCover()
	var/list/CoverInfo[9]
	var/Index = 1
	for (var/Direction in Cardinal8)
		var/turf/T = get_step(src, Direction)
		CoverInfo[Index] = T.GetCoverValue()
		Index += 1
	CoverInfo[9] = CoverInfo[1] // This is used to make later calculations in the cover mechanic much simpler
	return CoverInfo

// Returns the angle to the passed atom, where 0� is due north
atom/movable/proc/GetAngleTo(var/atom/movable/To)
	var/datum/Point/P = new(src)
	return P.GetAngleTo(To)

// Returns the angle to the passed atom, where 0� is due north
atom/movable/proc/GetDistanceTo(var/atom/movable/To)
	var/datum/Point/P = new(src)
	return P.GetDistanceTo(To)