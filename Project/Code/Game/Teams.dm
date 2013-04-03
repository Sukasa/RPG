//Teams Management

//Three teams: Attackers, Defenders, Spectators.  In 'teamless' modes, Defenders team is not used (Spectators are still allowed).
var
	list/Teams = list(list(), list(), list())

proc/AutoAssignTeams() // Automatically assign teams and spawn players into the world
	var/AssignablePlayers[0]
	for (var/mob/M in world)
		if (M.client)
			if(!M.Spectate)
				AssignablePlayers += M
			else
				M.Team = TeamSpectators
				Teams[TeamSpectators] += M
				M.Respawn()

	while (AssignablePlayers.len)
		var/mob/Player = pick(AssignablePlayers)
		Teams[TeamAttackers] += Player
		AssignablePlayers -= Player
		Player.Team = TeamAttackers
		Player.Respawn()

		if (AssignablePlayers.len)
			Player = pick(AssignablePlayers)
			Teams[TeamDefenders] += Player
			AssignablePlayers -= Player
			Player.Team = TeamDefenders
			Player.Respawn()

proc/LateAssign(var/mob/NewPlayer)

	//Due to how BYOND syntax works, I can't just do Teams[blah].len.  Seriously.
	var/list/A = Teams[TeamAttackers]
	var/list/D = Teams[TeamDefenders]

	if (A.len > D.len)
		Teams[TeamDefenders] += NewPlayer
		return TeamDefenders
	else
		Teams[TeamAttackers] += NewPlayer
		return TeamAttackers