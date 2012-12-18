proc/tan(var/V)
	return sin(V) / cos(V)

proc/arctan(var/V)
	return arcsin(V / sqrt(1 + (V * V)))
	//return 1 / tan(V)

proc/CoverIndexFromAngles(var/Angle, var/list/RefAngles)
	var/Index = 1
	for (var/RefAngle in RefAngles)
		if (RefAngle > Angle)
			world.log << "[Angle]° becomes [RefAngle] (Index [Index])"
			return Index
		Index += 1
	return 1