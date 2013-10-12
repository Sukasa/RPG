proc/tan(var/V)
	. = sin(V) / cos(V)

proc/arctan(var/V)
	. = arcsin(V / sqrt(1 + (V * V)))

proc/sign(x)
	. = x ? x / abs(x) : 0

proc/fix(x)
	. = x ? round(abs(x)) * sign(x) : 0