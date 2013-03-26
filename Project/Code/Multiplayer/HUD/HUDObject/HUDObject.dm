/obj/Runtime/HUD/HUDObject
	icon = 'HUD.dmi'
	var
		obj/Runtime/HUD/HUDController/Master

/obj/Runtime/HUD/HUDObject/proc/SetMaster(var/NewMaster)
	Master = NewMaster