proc/IsTurf(var/A)
	return istype(A, /turf)

proc/IsAtom(var/A)
	return istype(A, /atom)

proc/IsMovable(var/A)
	return istype(A, /atom/movable)

proc/Subtypes(var/Type)
	return typesof(Type) - Type