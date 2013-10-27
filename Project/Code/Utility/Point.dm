Point
	var
		TileX = 0
		TileY = 0
		PixelX = 0
		PixelY = 0
		FineX = 0
		FineY = 0

		step_y
		step_x

Point/New(var/atom/Location)
	if (!Location)
		return
	TileX = Location.x
	TileY = Location.y

	if (IsMovable(Location))
		PixelX = Location:step_x
		PixelY = Location:step_y
		step_x = PixelX
		step_y = PixelY

	if (IsTurf(Location))
		step_x = 16
		step_y = 16

	FineX = (TileX * world.icon_size) + PixelX
	FineY = (TileY * world.icon_size) + PixelY

	if (ismob(Location))
		FineX += Location:SubStepY
		FineY += Location:SubStepX

Point/proc/Polar(var/Angle, var/DistPixels)
	PixelX += fix(sin(Angle) * DistPixels)
	PixelY += fix(cos(Angle) * DistPixels)

	while (PixelX < 0)
		PixelX += world.icon_size
		TileX--

	while (PixelX > world.icon_size)
		PixelX -= world.icon_size
		TileX++

	while (PixelY < 0)
		PixelY += world.icon_size
		TileY--

	while (PixelY > world.icon_size)
		PixelY -= world.icon_size
		TileY++

Point/proc/Intersects(var/atom/A)
	var/Width = world.icon_size
	var/Height = world.icon_size

	var/Point/Offset = new(A)
	if (IsMovable(A))
		Width = A:bound_width
		Height = A:bound_height

	.= (FineX in Offset.FineX to Offset.FineX + Width) && (FineY in Offset.FineY to Offset.FineY + Height)

Point/proc/Center(var/atom/movable/X)
	PixelX = X.step_x
	PixelY = X.step_y
	PixelX += X.bound_x
	PixelY += X.bound_y
	PixelX += X.bound_width / 2
	PixelY += X.bound_height / 2
	FineX = (TileX * world.icon_size) + PixelX
	FineY = (TileY * world.icon_size) + PixelY

Point/proc/SetXOffset(var/X)
	PixelX = X
	FineX = (TileX * world.icon_size) + PixelX

Point/proc/SetYOffset(var/Y)
	PixelY = Y
	FineY = (TileY * world.icon_size) + PixelY

Point/proc/CopyXOffset(var/atom/movable/AM)
	PixelX = AM.step_x
	FineX = (TileX * world.icon_size) + PixelX

Point/proc/CopyYOffset(var/atom/movable/AM)
	PixelY = AM.step_y
	FineY = (TileY * world.icon_size) + PixelY

Point/proc/GetDistanceTo(var/Point/To)
	if (IsAtom(To))
		To = new/Point(To)
	var/dX = (To.FineX - src.FineX) / world.icon_size
	var/dY = (To.FineY - src.FineY) / world.icon_size
	return sqrt((dX * dX) + (dY * dY))

Point/proc/GetAngleTo(var/Point/To)
	if (IsAtom(To))
		To = new/Point(To)
	var/dX = To.FineX - src.FineX
	var/dY = To.FineY - src.FineY
	if(!dY)
		return (dX >= 0) ? 90 : 270
	. = arctan(dX / dY)
	if(dY < 0)
		return . + 180
	if (dX < 0)
		return . + 360

Point/proc/Clone()
	var/Point/P = new()
	P.TileX = TileX
	P.TileY = TileY
	P.PixelX = PixelX
	P.PixelY = PixelY
	P.FineX = FineX
	P.FineY = FineY
	return P