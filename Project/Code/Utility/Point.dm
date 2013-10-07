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
		PixelX += Location:bound_x
		PixelY += Location:bound_y
		//PixelX += Location:bound_width / 2
		//PixelY += Location:bound_height / 2

	if (IsTurf(Location))
		//PixelX += 16
		//PixelY += 16
		step_x = 16
		step_y = 16
	FineX = (TileX * 32) + PixelX
	FineY = (TileY * 32) + PixelY

	if (ismob(Location))
		FineX += Location:SubStepY
		FineY += Location:SubStepX

Point/proc/SetXOffset(var/X)
	PixelX = X
	FineX = (TileX * 32) + PixelX

Point/proc/SetYOffset(var/Y)
	PixelY = Y
	FineY = (TileY * 32) + PixelY

Point/proc/CopyXOffset(var/atom/movable/AM)
	PixelX = AM.step_x
	//PixelX += AM:bound_x
	//PixelX += AM.bound_width / 2
	FineX = (TileX * 32) + PixelX

Point/proc/CopyYOffset(var/atom/movable/AM)
	PixelY = AM.step_y
	//PixelY += AM:bound_y
	//PixelY += AM.bound_height / 2
	FineY = (TileY * 32) + PixelY

Point/proc/GetDistanceTo(var/Point/To)
	if (IsAtom(To))
		To = new/Point(To)
	var/dX = (To.FineX - src.FineX) / 32
	var/dY = (To.FineY - src.FineY) / 32
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