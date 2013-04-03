obj/Machinery
	name = "Machine"
	var/list/Networks = list( )

/obj/Machinery/proc/OnSignal(var/datum/Network/SourceNetwork) //Called when a logic signal is sent to the machine (e.g. stepping on a pressure plate)
	return

/obj/Machinery/proc/OnValueChange(var/Value, var/datum/Network/SourceNetwork) //Called when a value is sent to the machine (e.g. an electrical switch).
	return

/obj/Machinery/proc/Signal() //TODO, Call to send a logic signal to connected machines
	for(var/datum/Network/Network in Networks)
		if (Network.Type == /obj/MapMarker/Network/Signal)
			Network.Signal()

/obj/Machinery/proc/SendValue(var/Value) //TODO, Call to send a logic value to connected machines
	for(var/datum/Network/Network in Networks)
		if (Network.Type == /obj/MapMarker/Network/Signal)
			if (Value)
				Network.ApplyValue(src, Value)
			else
				Network.RemoveValue(src)

/obj/Machinery/proc/GetValue()
	var/Value = 0
	for(var/datum/Network/Network in Networks)
		if (Network.Type == /obj/MapMarker/Network/Signal)
			Value |= Network.GetValue()
	return Value