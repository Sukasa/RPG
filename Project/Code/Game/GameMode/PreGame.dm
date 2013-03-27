/datum/GameMode/PreGame
	Name = "Pre-game"
	ModeKey = "PG"
	var/Timeout

/datum/GameMode/PreGame/Tick()
	if (Timeout)
		Timeout--
		switch(Timeout)
			if(0)
				Ticker.ChangeGameMode(/datum/GameMode/TeamDeathmatch)
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
	return

/datum/GameMode/PreGame/GetAssignedTeam(var/mob/Player)
	return TeamPregame;

/datum/GameMode/PreGame/OnPlayerJoin(var/mob/Player)
	SendUser(Player, "\cyan Welcome to the pre-game!  Please wait while players join.  If you would like to vote on the gamemode, use /vote!")
	return

/datum/GameMode/PreGame/OnPlayerSpawn(var/mob/Player)
	GameText("[Player.name] Joined")

/datum/GameMode/PreGame/Command(var/Command, var/Params)
	switch (Command)
		if ("StartRound")
			Timeout = 1;