/Comparison/GreaterThan
	Command = "isgt"

	Compare(var/One, var/Two)
		return One > Two

/Comparison/GreaterThanOrEqual
	Command = "isgte"

	Compare(var/One, var/Two)
		return One >= Two

/Comparison/LessThan
	Command = "islt"

	Compare(var/One, var/Two)
		return One < Two

/Comparison/LessThanOrEqual
	Command = "islte"

	Compare(var/One, var/Two)
		return One <= Two