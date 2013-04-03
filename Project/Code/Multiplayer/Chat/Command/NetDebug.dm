/datum/ChatCommand/NetDebug
	Command = "nets"
	MinPowerLevel = RankProgrammer

/datum/ChatCommand/NetDebug/Execute(var/mob/Player, var/CommandText)
	SendUser("[Config.NetController.Networks.len] Networks")
	for(var/Index = 1; Index <= Config.NetController.Networks.len; Index++)
		var/datum/Network/Network = Config.NetController.Networks[Index]
		if (Network)
			SendUser("\white Network [Index]: [Network.Cables.len] Cables of type [Network.Type] with [Network.Devices.len] devices attached")
		else
			SendUser("\white Network [Index]:\red Removed")
	return

/datum/ChatCommand/ShowNets
	Command = "shownets"
	MinPowerLevel = RankProgrammer

/datum/ChatCommand/ShowNets/Execute(var/mob/Player, var/CommandText)
	for(var/obj/MapMarker/Network/N in world)
		N.invisibility = 0