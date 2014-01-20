/Comparison/Equal
	Command = "iseq"

	Compare(var/One, var/Two)
		return One == Two

/Comparison/Inequal
	Command = "isneq"

	Compare(var/One, var/Two)
		return One != Two