/datum/Mouse
	var
		LeftDown = 0
		RightDown = 0
		MiddleDown = 0

		Left = 0
		Right = 0
		Middle = 0

		datum/Point/Pos = new()
		atom/Highlighted


/datum/Mouse/proc/Set(var/atom/A, var/list/Params, var/Down = 1)
	Pos.TileX = A.x
	Pos.TileY = A.y
	Pos.PixelX = text2num(Params["icon_x"])
	Pos.PixelY = text2num(Params["icon_y"])
	Pos.FineX = (Pos.TileX * 32) + Pos.PixelX
	Pos.FineY = (Pos.TileY * 32) + Pos.PixelY
	Highlighted = A
	Left = Params["left"]
	Right = Params["right"]
	Middle = Params["middle"]

	if (Down == 1)
		LeftDown |= text2num(Params["left"])
		RightDown |= text2num(Params["right"])
		MiddleDown |= text2num(Params["middle"])
	else if (Down == 0)
		LeftDown &= ~text2num(Params["left"])
		RightDown &= ~text2num(Params["right"])
		MiddleDown &= ~text2num(Params["middle"])

	return


/client
	var
		datum/Mouse/Mouse = new()


/client/MouseDown(var/Object, var/Location, var/Control, var/P)
	..()
	if (!Object)
		Object = Location
	if (!IsAtom(Object) || !IsTurf(Location))
		return
	Mouse.Set(Object, params2list(P))
	if (Mouse.Left)
		mob.SetMoveTarget(Mouse)
	if (Mouse.Right)
		mob.Attack(Mouse)


/client/MouseUp(var/Object, var/Location, var/Control, var/P)
	..()
	if (!Object)
		Object = Location
	if (!IsAtom(Object) || !IsTurf(Location))
		return
	Mouse.Set(Object, params2list(P), 0)


/client/MouseDrag(var/Dragged, var/Over, var/FromLocation, var/ToLocation, var/FromControl, var/ToControl, var/P)
	..()
	if (!Over)
		Over = ToLocation
	if (!IsAtom(Over) || !IsTurf(ToLocation))
		return
	Mouse.Set(Over, params2list(P), 2)
	if (Mouse.LeftDown)
		mob.SetMoveTarget(Mouse)
	if (Mouse.RightDown)
		mob.Attack(Mouse)