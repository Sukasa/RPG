//TODO we should probably refactor this code into applicable files instead of being here at the top

atom
	var
		CoverValue = 0			// Worthiness of an atom as cover.  100 is full protection, 0 is no protection
		BulletDensity = 0		// Whether you can fire over/through an atom.  Doesn't affect the ability of that atom to give cover.
		CanTarget = TRUE		// Whether you can target an atom directly.  Right-clicking an object with this set to false will just fire in that general direction
		InteractRange = 1.5
		AutojoinValue = 0

		list/MatchTypes = list( )
		atom/Transport			// What this atom is 'attached' to
		list/Riders = list( ) 	// What atoms are 'attached' to this atom

atom/movable/proc/GetFineX()
	return (src.x * world.icon_size) + src.step_x


atom/movable/proc/GetFineY()
	return (src.y * world.icon_size) + src.step_y


atom/movable/proc/GetCover()
	var/list/CoverInfo[9]
	var/Index = 1
	for (var/Direction in Cardinal8)
		var/turf/T = get_step(src, Direction)
		CoverInfo[Index] = T.GetCoverValue()
		Index += 1
	CoverInfo[9] = CoverInfo[1] // This is used to make later calculations in the cover mechanic much simpler
	return CoverInfo


// Returns the angle to the passed atom, where 0° is due north
atom/movable/proc/GetAngleTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetAngleTo(To)


// Returns the Distance to the passed atom
atom/proc/GetDistanceTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetDistanceTo(To)


atom/proc/GetXDistanceTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetXDistanceTo(To)


atom/proc/GetYDistanceTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetYDistanceTo(To)


atom/proc/SlowTick()
	return


atom/proc/FastTick()
	return


atom/proc/SendHearers(var/Text)
	for (var/mob/M in hearers())
		if (M.client)
			M.client.Send(Text)


atom/proc/SendOHearers(var/Text)
	for (var/mob/M in ohearers())
		if (M.client)
			M.client.Send(Text)


atom/proc/UserInRange(var/User = 0, var/Range = 0)
	if (!ismob(User))
		Range = User
		User = usr
	Range = Range || InteractRange
	return GetDistanceTo(User) <= Range


atom/proc/AutoJoin()
	var/B = 0
	for(var/X = 1, X <= 8, X++)
		var/turf/T = get_step(src, Cardinal8[X])
		if (!T || (T.type == type) || (T.type in MatchTypes) || (locate(type) in T))
			B |= 1 << X
		//for (var/Type in MatchTypes)
			//if (istype(T, Type))
				//B |= 1 << X
	AutojoinValue = Config.AutoTile[(B >> 1) + 1]
	icon_state = "[AutojoinValue]"


atom/proc/Closest(var/list/Candidates)
	var/Dist = Infinity
	for(var/atom/Candidate in Candidates)
		if (Dist > GetDistanceTo(Candidate))
			Dist = GetDistanceTo(Candidate)
			. = Candidate

atom/proc/XYNoise(var/UpperBound)
	. = max(round((x - y) * 3 * tan(((x * y) + x) * 38.5)), 0) % UpperBound
	if (. == NaN)
		. = 0


atom/proc/Mount(var/atom/Mount)
	if (Transport)
		Dismount()

	Transport = Mount
	Mount.Riders += src


atom/proc/Dismount()
	Transport.Riders -= src
	Transport = null