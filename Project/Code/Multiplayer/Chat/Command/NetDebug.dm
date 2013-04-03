/datum/ChatCommand/NetDebug
	Command = "nets"
	MinPowerLevel = RankProgrammer

/datum/ChatCommand/NetDebug/Execute(var/mob/Player, var/CommandText)
	SendUser("[Config.NetController.Networks.len] Networks")
	for(var/Index = 1; Index <= Config.NetController.Networks.len; Index++)
		var/list/Network = Config.NetController.Networks[Index]
		if (Network)
			var/datum/Part = Network[1]
			SendUser("\white Network [Index]: [Network.len] Components of type [Part.type]")
		else
			SendUser("\white Network [Index]:\red Removed")
	return