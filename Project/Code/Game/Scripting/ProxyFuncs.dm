proc/ProxyMin()
	return min(args)

proc/ProxyMax()
	return max(args)

proc/ProxySin(var/A)
	return sin(A)

proc/ProxyCos(var/A)
	return cos(A)

proc/ProxyLocate(var/A, var/B, var/C)
	return locate(A, B, C)

proc/ProxyAbs(var/A)
	return abs(A)

proc/ProxyList()
	return args

proc/ProxyFloor(var/A)
	return round(A)

proc/ProxySleep(var/A)
	sleep(A)