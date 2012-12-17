turf/proc/GetCoverValue()
	var/V = src.CoverValue
	for (var/atom/A in src)
		if (A.CoverValue > V)
			V = A.CoverValue
	return V