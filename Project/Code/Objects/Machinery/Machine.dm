obj/Machinery
	name = "Machine"

/obj/Machinery/proc/OnSignal() //Called when a logic signal is sent to the machine (e.g. stepping on a pressure plate)
	return

/obj/Machinery/proc/OnValue(var/Value) //Called when a value is sent to the machine (e.g. an electrical switch).
	return

/obj/Machinery/proc/Signal() //TODO, Call to send a logic signal to connected machines
	return

/obj/Machinery/proc/SendValue(var/Value) //TODO, Call to send a logic value to connected machines
	return