/datum/Mouse
	var
		LeftDown = 0
		RightDown = 0
		MiddleDown = 0

		Left = 0
		Right = 0
		Middle = 0

		Point/Pos = new()
		atom/Highlighted

/datum/Mouse/proc/Set(var/atom/A, var/list/Params, var/Down = 1)
	Pos.TileX = A.x
	Pos.TileY = A.y
	Pos.PixelX = text2num(Params["icon-x"]) - 1 + A.pixel_x
	Pos.PixelY = text2num(Params["icon-y"]) - 1 + A.pixel_y
	if (IsMovable(A))
		Pos.PixelX += A:step_x
		Pos.PixelY += A:step_y
	Pos.FineX = (Pos.TileX * world.icon_size) + Pos.PixelX
	Pos.FineY = (Pos.TileY * world.icon_size) + Pos.PixelY
	Highlighted = A
	Left = Params["left"]
	Right = Params["right"]
	Middle = Params["middle"]

	if (Down == 1) // Down can be 2 if neither of these is to be triggered
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
	if (!EnableMouse)
		return
	if (!Object)
		Object = Location
	if (!IsAtom(Object))
		return
	Mouse.Set(Object, params2list(P))
	if (Mouse.Left)
		mob.SetMoveTarget(Mouse)
	if (Mouse.Right)
		mob.Interact(Mouse)
	if (Mouse.Middle)
		mob.Interact(Mouse, TRUE)

/client/MouseUp(var/Object, var/Location, var/Control, var/P)
	..()
	if (!EnableMouse)
		return
	if (!Object)
		Object = Location
	if (!IsAtom(Object))
		return
	Mouse.Set(Object, params2list(P), 0)

/client/MouseDrag(var/Dragged, var/Over, var/FromLocation, var/ToLocation, var/FromControl, var/ToControl, var/P)
	..()
	if (!EnableMouse)
		return
	if (!Over)
		Over = ToLocation
	if (!IsAtom(Over))
		return
	Mouse.Set(Over, params2list(P), 2)
	if (Mouse.Left)
		mob.SetMoveTarget(Mouse)
	if (Mouse.Right)
		mob.Interact(Mouse)
	if (Mouse.Middle)
		mob.Interact(Mouse, TRUE)