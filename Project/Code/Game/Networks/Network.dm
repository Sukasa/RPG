/datum/Network
	var/list/Cables = list( )
	var/list/Devices = list( )
	var/list/Values = list( )
	var/LastValue = 0
	var/TickSignal = FALSE
	var/Type

/datum/Network/proc/GetValue()
	var/Value = 0
	for (var/V in Values)
		if (Values[V])
			Value |= Values[V]
	return Value

/datum/Network/proc/Signal(var/Ref)
	TickSignal = TRUE

/datum/Network/proc/ApplyValue(var/Ref, var/Value)
	Values[Ref] = Value

/datum/Network/proc/RemoveValue(var/Ref)
	Values[Ref] = null

/datum/Network/proc/Tick()
	var/Value = GetValue()

	if (TickSignal)
		for(var/obj/Machinery/Machine in Devices)
			Machine.OnSignal(src)

	if(Value != LastValue)
		for(var/obj/Machinery/Machine in Devices)
			Machine.OnValueChange(Value, src)

	LastValue = Value
	TickSignal = FALSE