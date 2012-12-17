proc/tan(var/V)
	return sin(V) / cos(V)

proc/arctan(var/V)
	return (360 + (1 / tan(V))) % 360

proc/CoverIndexFromAngles(var/Angle, var/list/RefAngles)
	var/Index = 0
	for (var/RefAngle in RefAngles)
		if (RefAngle < Angle)
			return Index
		Index += 1
	return Index
