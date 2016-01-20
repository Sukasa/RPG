//TODO we should probably refactor this code into applicable files instead of being here at the top

/atom
	var
		CoverValue = 0			// Worthiness of an atom as cover.  100 is full protection, 0 is no protection
		BulletDensity = 0		// Whether you can fire over/through an atom.  Doesn't affect the ability of that atom to give cover.
		CanTarget = TRUE		// Whether you can target an atom directly.  Right-clicking an object with this set to false will just fire in that general direction
		InteractRange = 1.5
		AutojoinValue = 0
		BaseLayer = 0
		global
			obj/Runtime/Hitscan/Hitscan = new()

		list/MatchTypes = list( )
		atom/Transport			// What this atom is 'attached' to
		list/Riders = list( ) 	// What atoms are 'attached' to this atom


// Dynamic layering support
/atom/movable/New()
	..()
	ReCalcLayer()

/atom/movable/proc/ReCalcLayer()
	if (BaseLayer == 0)
		BaseLayer = layer
	else if (layer < HUDLayer)
		var/sY = (y * world.icon_size + step_y) / world.icon_size
		var/sX = (y * world.icon_size + step_x) / world.icon_size
		layer = BaseLayer - ((sY / 100) - (sX / 500))
		//world << layer

/atom/movable/Move()
	. = ..()
	ReCalcLayer()

//------------------------------------

/atom/movable/Cross(var/atom/movable/AM)
	if (istype(AM, /obj/Runtime/Particle) || istype(AM, /obj/Runtime/Hitscan))
		EffectInteract(AM)
	AM.CrossOver(src)
	. = ..()

/atom/movable/proc/CrossOver(var/atom/movable/AM)
	return

//------------------------------------

/atom/movable/proc/GetFineX()
	return (src.x * world.icon_size) + src.step_x


/atom/movable/proc/GetFineY()
	return (src.y * world.icon_size) + src.step_y

//------------------------------------

/atom/movable/proc/GetCover()
	var/list/CoverInfo[9]
	var/Index = 1
	for (var/Direction in Cardinal8)
		var/turf/T = get_step(src, Direction)
		CoverInfo[Index] = T.GetCoverValue()
		Index += 1
	CoverInfo[9] = CoverInfo[1] // This is used to make later calculations in the cover mechanic much simpler
	return CoverInfo


// Returns the angle to the passed atom, where 0° is due north
/atom/movable/proc/GetAngleTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetAngleTo(To)


// Returns the Distance to the passed atom
atom/proc/GetDistanceTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetDistanceTo(To)


/atom/proc/GetXDistanceTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetXDistanceTo(To)


/atom/proc/GetYDistanceTo(var/atom/movable/To)
	var/Point/P = new(src)
	return P.GetYDistanceTo(To)

//------------------------------------

/atom/proc/SlowTick()
	return


/atom/proc/FastTick()
	return

//------------------------------------

/atom/proc/SendHearers(var/Text)
	for (var/mob/M in hearers())
		if (M.client)
			M.client.Send(Text)


/atom/proc/SendOHearers(var/Text)
	for (var/mob/M in ohearers())
		if (M.client)
			M.client.Send(Text)


/atom/proc/UserInRange(var/User = 0, var/Range = 0)
	if (!ismob(User))
		Range = User
		User = usr
	Range = Range || InteractRange
	return GetDistanceTo(User) <= Range

//------------------------------------

/atom/proc/AutoJoin()
	var/B = 0
	for(var/X = 1, X <= 8, X++)
		var/turf/T = get_step(src, Cardinal8[X])
		if (!T || (T.type == type) || (T.type in MatchTypes) || (locate(type) in T))
			B |= 1 << X
	AutojoinValue = Config.AutoTile[(B >> 1) + 1]
	icon_state = "[AutojoinValue]"

//------------------------------------

/atom/proc/Closest(var/list/Candidates)
	var/Dist = Infinity
	for(var/atom/Candidate in Candidates)
		if (Dist > GetDistanceTo(Candidate))
			Dist = GetDistanceTo(Candidate)
			. = Candidate

//------------------------------------

/atom/proc/XYNoise(var/UpperBound)
	. = max(round((x - y) * 3 * tan(((x * y) + x) * 38.5)), 0) % UpperBound
	if (. == NaN)
		. = 0

//------------------------------------

/atom/proc/Mount(var/atom/Mount)
	if (Transport)
		Dismount()

	Transport = Mount
	Mount.Riders += src


/atom/proc/Dismount()
	Transport.Riders -= src
	Transport = null


//------------------------------------

/atom/movable
	var
		Point/Destination = null
		SubStepX = 0
		SubStepY = 0
		SmoothMove = 0

/atom/movable/proc/WarpTo(var/Point/Target = Destination)
	if (!istype(Target, /Point))
		Target = new/Point(Target)
	step_y = Target.step_y - (bound_height / 2) - bound_y
	step_x = Target.step_x - (bound_width / 2) - bound_x
	Move(locate(Target.TileX, Target.TileY, z || 1))

/atom/movable/proc/MoveBy(var/StepX, var/StepY)
	var/NewX = (StepX + step_x + SubStepX) + (x * world.icon_size)
	var/NewY = (StepY + step_y + SubStepY) + (y * world.icon_size)

	. = Move(locate(round(NewX / world.icon_size), round(NewY / world.icon_size), z), 0, round(NewX % world.icon_size), round(NewY % world.icon_size))

	if (.)
		SubStepX = NewX - round(NewX)
		SubStepY = NewY - round(NewY)

/atom/movable/proc/MoveTo(var/Target = Destination)
	Destination = Target
	if (!Target)
		return

	if (GetDistanceTo(Destination) <= OnePixel)
		if (IsMovable(Destination))
			SubStepX = Destination:SubStepX
			SubStepY = Destination:SubStepY
			Move(Destination:loc, 0, Destination:step_x, Destination:step_y)

		Destination = null
	else

		var/Angle = GetAngleTo(Destination)
		var/MoveSpeed = min(MoveSpeed(), GetDistanceTo(Destination) * world.icon_size)

		var/NewX = ((MoveSpeed * sin(Angle)) + step_x + SubStepX) + (x * world.icon_size)
		var/NewY = ((MoveSpeed * cos(Angle)) + step_y + SubStepY) + (y * world.icon_size)

		SubStepX = NewX - round(NewX)
		SubStepY = NewY - round(NewY)

		if (GetXDistanceTo(Destination) <= OnePixel && GetXDistanceTo(Destination) != 0)
			if (Debug)
				world.log << "X Jump: Moving from [x]:[step_x + SubStepX] to [Destination:x]:[Destination:step_x] (Distance is [GetXDistanceTo(Destination)])"
			SmoothMove = 1
			Move(locate(Destination:x, y, z), 0, round(Destination:step_x), step_y)
			SubStepX = 0
		else
			SmoothMove = 1
			Move(locate(round(NewX / world.icon_size), y, z), 0, round(NewX % world.icon_size), step_y)

		if (GetYDistanceTo(Destination) <= OnePixel && GetYDistanceTo(Destination) != 0)
			if (Debug)
				world.log << "Y Jump: Moving from [y]:[step_y + SubStepY] to [Destination:y]:[Destination:step_y] (Distance is [GetYDistanceTo(Destination)])"
			SmoothMove = 1
			Move(locate(x, Destination:y, z), 0, step_x, round(Destination:step_y))
			SubStepY = 0
		else
			SmoothMove = 1
			Move(locate(x, round(NewY / world.icon_size), z), 0, step_x, round(NewY % world.icon_size))

/atom/movable/Move()
	..()
	if (SmoothMove)
		SmoothMove--
	else
		Destination = null

/atom/movable/proc/MoveSpeed()
	return world.icon_size

//------------------------------------

/atom/proc/IsOnScreen(var/Expand = 0)
	var/list/Range = range(world.view + Expand, src)
	for(var/client/C)
		if (C.eye in Range)
			return TRUE
	return FALSE

/atom/proc/EffectInteract(var/obj/Runtime/Hitscan/Hit)
	return