proc/IsTurf(var/A)
	return istype(A, /turf)

proc/IsAtom(var/A)
	return istype(A, /atom)

proc/IsObj(var/A)
	return istype(A, /obj)

proc/IsMovable(var/A)
	return istype(A, /atom/movable)

proc/Subtypes(var/Type)
	return typesof(Type) - Type