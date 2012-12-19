mob
	var
		MoveSpeed = 7
		datum/Point/Destination
		SubStepX
		SubStepY
		SmoothMove
	sight = SEE_TURFS

/mob/proc/GetCoverPenalty()
	return 0

/mob/proc/Attack(var/datum/Mouse/Mouse)
	return

/mob/proc/SetMoveTarget(var/datum/Mouse/Mouse)
	Destination = Mouse.Pos.Clone()
	//TODO Movement cursor
	return

/mob/proc/MoveTo(var/datum/Point/Target = Destination)
	Destination = Target
	if (!Target)
		return
	var/Angle = GetAngleTo(Destination)

	var/NewStepX = (MoveSpeed * sin(Angle)) + step_x
	var/NewStepY = (MoveSpeed * cos(Angle)) + step_y

	var/OffsetX = 0
	var/OffsetY = 0

	if (NewStepX < 0)
		NewStepX += 32
		OffsetX--
	else if (NewStepX >= 32)
		NewStepX -= 32
		OffsetX++

	if (NewStepY < 0)
		NewStepY += 32
		OffsetY--
	else if (NewStepY >= 32)
		NewStepY -= 32
		OffsetY++

	NewStepY += SubStepY
	NewStepX += SubStepX

	SubStepX = NewStepX % 1
	SubStepY = NewStepY % 1

	//TODO rework this so that if you're trying to hit a wall diagonally, you move in a cardinal4 direction instead
	SmoothMove = 2
	Move(locate(x + OffsetX, y, z), 0, round(NewStepX), step_y)
	Move(locate(x, y + OffsetY, z), 0, step_x, round(NewStepY))

	if (GetDistanceTo(Destination) <= (MoveSpeed / 32))
		Destination = null

/mob/Move()
	..()
	if (!SmoothMove)
		Destination = null
	else
		SmoothMove--

/mob/proc/Tick()
	return