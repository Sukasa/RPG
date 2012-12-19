/datum/Point
	var
		TileX = 0
		TileY = 0
		PixelX = 0
		PixelY = 0
		FineX = 0
		FineY = 0

/datum/Point/New(var/atom/Location)
	if (!Location)
		return
	TileX = Location.x
	TileY = Location.y
	if (istype(Location, /atom/movable))
		PixelX = Location:step_x
		PixelY = Location:step_y
	FineX = (TileX * 32) + PixelX
	FineY = (TileY * 32) + PixelY

/datum/Point/proc/GetDistanceTo(var/datum/Point/To)
	if (istype(To, /atom))
		To = new/datum/Point(To)
	var/dX = (To.FineX - src.FineX) / 32
	var/dY = (To.FineY - src.FineY) / 32
	return sqrt((dX * dX) + (dY * dY))

/datum/Point/proc/GetAngleTo(var/datum/Point/To)
	if (istype(To, /atom))
		To = new/datum/Point(To)

	var/dX = To.FineX - src.FineX
	var/dY = To.FineY - src.FineY
	if(!dY)
		return (dX >= 0) ? 90 : 270
	. = arctan(dX / dY)
	if(dY < 0)
		return . + 180
	if (dX < 0)
		return . + 360

datum/Point/proc/Clone()
	var/datum/Point/P = new()
	P.TileX = TileX
	P.TileY = TileY
	P.PixelX = PixelX
	P.PixelY = PixelY
	P.FineX = FineX
	P.FineY = FineY
	return P