/obj/Machinery/DebugLight
	name = "Debug Light"
	icon = 'Light.dmi'
	icon_state = "0"

/obj/Machinery/DebugLight/OnValueChange(var/Value, var/datum/Network/SourceNetwork)
	icon_state = GetValue() ? "1" : "0"

/obj/Machinery/DebugLight/OnSignal()
	flick("Signal", src)