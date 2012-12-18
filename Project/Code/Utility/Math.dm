proc/tan(var/V)
	return sin(V) / cos(V)

proc/arctan(var/V)
	return arcsin(V / sqrt(1 + (V * V)))

proc/sign(x)
	return x ? x / abs(x) : 0