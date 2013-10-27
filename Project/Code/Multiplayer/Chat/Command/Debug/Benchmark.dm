/ChatCommand/Benchmark
	Command = "benchmark"

/ChatCommand/Benchmark/Execute(var/mob/Player, var/CommandText)

	var/StartTime = world.timeofday
	var/EndTime
	var/B = 0
	var/X = 3
	for (var/Y = 0, Y < 6553500, Y++)
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
		B |= 1 << X
	EndTime = world.timeofday
	DebugText("65535000 bit shifts took [(EndTime - StartTime) / 10] Seconds")

	StartTime = world.timeofday
	B = 0
	for (var/Y = 0, Y < 6553500, Y++)
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
		B |= DirectionAngles[X + 1]
	EndTime = world.timeofday
	DebugText("65535000 array lookups took [(EndTime - StartTime) / 10] Seconds")