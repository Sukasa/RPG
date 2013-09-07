/datum/Network
	var/list/Cables = list( )
	var/list/Devices = list( )
	var/list/Values = list( )

	var/LastValue = 0
	var/TickSignal = FALSE
	var/Type = null

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
	var/DoSignal = TickSignal
	var/DoValue = (LastValue != Value)
	LastValue = Value
	TickSignal = FALSE
	if(DoValue)
		for(var/obj/Machinery/Machine in Devices)
			Machine.OnValueChange(Value, src)
	if (DoSignal)
		for(var/obj/Machinery/Machine in Devices)
			Machine.OnSignal(src)