obj/Machinery
	name = "Machine"
	var/list/Networks = list( )

/obj/Machinery/proc/OnSignal(var/datum/Network/SourceNetwork) // Called when a logic signal is sent to the machine (e.g. stepping on a pressure plate)
	return

/obj/Machinery/proc/OnValueChange(var/Value, var/datum/Network/SourceNetwork) // Called when a value is sent to the machine (e.g. an electrical switch).
	return

/obj/Machinery/proc/Signal(var/NetType = /obj/MapMarker/Network/Signal, var/Direction = 0) // Call to send a logic signal to connected machines
	if (isnum(NetType))
		Direction = NetType
		NetType = /obj/MapMarker/Network/Signal

	if (!Direction)
		for(var/datum/Network/Network in Networks)
			if (Network.Type == NetType)
				Network.Signal()
	else
		for(var/obj/MapMarker/Network/NetPiece in get_step(loc, Direction))
			if (NetPiece.Network.Type == NetType)
				NetPiece.Network.Signal()

/obj/Machinery/proc/SendValue(var/Value, var/NetType = /obj/MapMarker/Network/Signal, var/Direction = 0) // Call to send a logic value to connected machines
	if (isnum(NetType))
		Direction = NetType
		NetType = /obj/MapMarker/Network/Signal

	if (!Direction)
		for(var/datum/Network/Network in Networks)
			if (Network.Type == NetType)
				if (Value)
					Network.ApplyValue(src, Value)
				else
					Network.RemoveValue(src)
	else
		for(var/obj/MapMarker/Network/NetPiece in get_step(loc, Direction))
			if (NetPiece.Network.Type == NetType)
				if (Value)
					NetPiece.Network.ApplyValue(src, Value)
				else
					NetPiece.Network.RemoveValue(src)


/obj/Machinery/proc/GetValue(var/NetType = /obj/MapMarker/Network/Signal)
	var/Value = 0
	for(var/datum/Network/Network in Networks)
		if (Network.Type == NetType)
			Value |= Network.GetValue()
	return Value