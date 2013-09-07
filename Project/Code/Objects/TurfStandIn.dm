//Literally nothing.  This is a dummy object used by the Floorplan and Mouse Control code
/obj/Runtime/TurfStandIn
	name = ""
	layer = TURF_LAYER
	CanTarget = FALSE
	InteractRange = 9

#ifdef DEBUG
/obj/Runtime/TurfStandIn/Interact(var/mob/User)
	DebugText("[loc:GetCoverValue()]")
	return TRUE
#endif