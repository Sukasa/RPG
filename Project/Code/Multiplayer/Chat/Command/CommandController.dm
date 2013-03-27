/datum/CommandController
	var/list/AllCommands = list( )

/datum/CommandController/New()
	var/Commands = typesof(/datum/ChatCommand) - /datum/ChatCommand
	for (var/Command in Commands)
		new Command(src)

/datum/CommandController/proc/IsValidCommand(var/Command)
	return AllCommands[Command] != null

/datum/CommandController/proc/Execute(var/mob/Executor, var/Command, var/CommandText)
	var/datum/ChatCommand/CC = AllCommands[Command]
	if (CC)
		if (Executor.Rank >= CC.MinPowerLevel || Debug)
			CC.Execute(Executor, CommandText)
		else
			SendUser("\red You do not have permission to do this")