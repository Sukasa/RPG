/CommandController
	var/list/AllCommands = list( )

/CommandController/New()
	var/Commands = typesof(/ChatCommand) - /ChatCommand
	for (var/Command in Commands)
		new Command(src)

/CommandController/proc/IsValidCommand(var/Command)
	return AllCommands[Command] != null

/CommandController/proc/Execute(var/mob/Executor, var/Command, var/CommandText = "")
	var/ChatCommand/CC = AllCommands[Command]
	if (!CC)
		ErrorText("Command [Command] not found!")
		return
	if (!Executor || (Executor.Rank >= CC.MinPowerLevel) || Debug)
		CC.Execute(Executor, CommandText)
	else
		SendUser("\red You do not have permission to do this")
