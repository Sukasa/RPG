/obj/Machinery/Trap
	name = "Trap"
	var/Count = 0
	var/image/Knowledge

/obj/Machinery/Trap/proc/ActivateOnce()
	Signal()
	Reveal()

/obj/Machinery/Trap/proc/Activate()
	if (!Count)
		Signal()
		Reveal()
	Count++
	SendValue(Count)

/obj/Machinery/Trap/proc/Reveal(var/Audible = TRUE)
	if (Audible)
		if (UserInRange())
			SendUser("\magenta You hear a click at your feet")
		SendOHearers("\magenta You hear a click from nearby")
	viewers() << Knowledge

/obj/Machinery/Trap/proc/Deactivate()
	Count--
	SendValue(Count)
	if (!Count)
		Reveal(FALSE)
	return !Count