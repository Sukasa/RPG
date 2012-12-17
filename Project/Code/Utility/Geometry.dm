proc/tan(var/V)
	return sin(V) / cos(V)

proc/arctan(var/V)
	return (360 + (1 / tan(V))) % 360

proc/CoverIndexFromAngles(var/Angle, var/list/RefAngles)
	var/Index = 0
	for (var/RefAngle in RefAngles)
		if (RefAngle < Angle)
			world << "[Index], [RefAngle] from [Angle]"
			return Index+1
		Index += 1
	return Index+1

proc/arctan2(x,y) return 2*arctan(y/(sqrt(x**2+y**2)+x))