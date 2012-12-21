//Teams Management

//Three teams: Attackers, Defenders, Spectators.  In 'teamless' modes, Defenders team is not used (Spectators are still allowed).
var
	list/Teams = list(list(), list(), list())

proc/AutoAssignTeams()
	var/AssignablePlayers[0]
	for (var/mob/M in world)
		if (M.client && TRUE) // TODO Replace TRUE with whether the player has signed up for the round (vs. just being a spectator)
			AssignablePlayers += M

	while (AssignablePlayers.len)
		var/mob/Player = pick(AssignablePlayers)
		Teams[TeamAttackers] += Player
		AssignablePlayers -= Player

		if (AssignablePlayers.len)
			Player = pick(AssignablePlayers)
			Teams[TeamDefenders] += Player
			AssignablePlayers -= Player

proc/LateJoin(var/mob/LatePlayer)
	if (Ticker.AllowJoin())
		return TRUE
	else
		return FALSE