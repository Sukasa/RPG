/obj/Machinery/Trap
	name = "Trap"
	var/Count = 0
	var/image/Knowledge

/obj/Machinery/Trap/proc/TriggerOnce()
	Signal()
	Reveal()

/obj/Machinery/Trap/proc/Trigger()
	if (!Count)
		Signal()
		Reveal()
	Count++
	SendValue(Count)

/obj/Machinery/Trap/proc/Reveal()
	if (UserInRange())
		SendUser("\magenta You hear a click at your feet")
		SendOHearers("\magenta You hear a click from nearby")
	else
		SendHearers("\magenta You hear a click from nearby")
	viewers() << Knowledge

/obj/Machinery/Trap/proc/Untrigger()
	Count--
	SendValue(Count)
	return !Count