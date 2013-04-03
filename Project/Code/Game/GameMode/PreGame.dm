/datum/GameMode/PreGame
	Name = "Pre-game"
	ModeKey = "PG"
	Commands = list("start", "spectate")
	var/Timeout = 0
	var/Ready = FALSE

/datum/GameMode/PreGame/Tick()
	if (Timeout)
		Timeout--
		switch(Timeout)
			if(0)
				Ticker.ChangeGameMode(Config.CurrentMode)
			if(1 to 10)
				InfoText("[Timeout]...")
			if(20, 30, 45, 60)
				InfoText("Game will start in [Timeout] seconds!")
			else
				if (Timeout % 60 == 0)
					InfoText("Game will start in [Timeout / 60] minutes.")
	return

/datum/GameMode/PreGame/Start()
	Timeout = Config.PregamePeriod
	DebugText("Completed PreGame Start.  Time to begin is [Timeout]")
	spawn
		InitWorld()
	return

/datum/GameMode/PreGame/GetAssignedTeam(var/mob/Player)
	return TeamPregame;

/datum/GameMode/PreGame/OnPlayerJoin(var/mob/Player)
	SendUser(Player, "\cyan Welcome to the pre-game!  Please wait while players join.  If you would like to vote on the gamemode, use /vote!")
	return

/datum/GameMode/PreGame/OnPlayerSpawn(var/mob/Player)
	GameText("[Player.name] Joined")

/datum/GameMode/PreGame/proc/InitWorld()
	set background = TRUE
	for (var/turf/T in world)
		T.Init()
		sleep(-1)

	Config.NetController.Init()

	//TODO other world initialization as needed

	AdminText("World initialization complete")
	Ready = TRUE

/datum/GameMode/PreGame/Command(var/mob/Executor, var/Command, var/Params)
	switch (Command)
		if ("start")
			if (Executor.Rank >= RankModerator || Debug)
				if (Ready)
					InfoText("([Executor.name]) Starting the Round")
					Timeout = 1;
				else
					SendUser("\red Cannot start; the world has not finished initializing")
			else
				SendUser("\red You do not have permission to do this")
		if ("spectate")
			Executor.Spectate = !Executor.Spectate
			if (Executor.Spectate)
				SendUser("You will now spectate the next round")
			else
				SendUser("You will now play in the next round")