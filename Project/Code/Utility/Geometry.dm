proc/tan(var/V)
	return sin(V) / cos(V)

proc/arctan(var/V)
	return 1 / tan(V)
	return arcsin(V / sqrt(1 + (V * V)))

// Angle2Index takes a list of angles and returns the index of the angle that is closest to it while remaining counterclockwise of the supplied angle.
// Generally, you will want to pass this CardinalAngles or CardinalAngles8 as the RefAngles parameter.
proc/Angle2Index(var/Angle, var/list/RefAngles)
	var/Index = 1
	for (var/RefAngle in RefAngles)
		if (RefAngle > Angle)
			world.log << "[Angle]° becomes [RefAngle] (Index [Index])"
			return Index
		Index += 1
	return 1