/ChatCommand/TestDLL
	Command = "testdll"
	MinPowerLevel = RankProgrammer

/ChatCommand/TestDLL/Execute(var/mob/Player, var/CommandText)
	var/list/L = call("libBYONDDevTools.dll", "fileinfo")("Test_Script_2.txt")
	L = params2list(L)
	for(var/Key in L)
		world.log << "[Key] => [L[Key]]"