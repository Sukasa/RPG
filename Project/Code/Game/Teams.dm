//Teams Management

//Three teams: Attackers, Defenders, Spectators.  In 'teamless' modes, Defenders team is not used (Spectators are still allowed).

proc/AutoAssignTeams() // Automatically assign teams and spawn players into the world
	Config.Teams = list(list( ), list( ), list( ), list( ))
	var/AssignablePlayers[0]
	for (var/mob/M in world)
		M.Team = TeamUnknown
		if (M.client)
			if(!M.Spectate)
				AssignablePlayers += M
			else
				M.Team = TeamSpectators
				Config.Teams[TeamSpectators] += M
				M.Respawn()

	while (AssignablePlayers.len)
		var/mob/Player = pick(AssignablePlayers)
		Config.Teams[TeamAttackers] += Player
		AssignablePlayers -= Player
		Player.Team = TeamAttackers
		Player.Respawn()

		if (AssignablePlayers.len)
			Player = pick(AssignablePlayers)
			Config.Teams[TeamDefenders] += Player
			AssignablePlayers -= Player
			Player.Team = TeamDefenders
			Player.Respawn()

proc/LateAssign(var/mob/NewPlayer)

	//Due to how BYOND syntax works, I can't just do Teams[blah].len.  Seriously.
	var/list/A = Config.Teams[TeamAttackers]
	var/list/D = Config.Teams[TeamDefenders]

	if (A.len > D.len)
		Config.Teams[TeamDefenders] += NewPlayer
		return TeamDefenders
	else
		Config.Teams[TeamAttackers] += NewPlayer
		return TeamAttackers