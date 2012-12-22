//Teams Management

//Three teams: Attackers, Defenders, Spectators.  In 'teamless' modes, Defenders team is not used (Spectators are still allowed).
var
	list/list/mob/Teams = list(list(), list(), list())

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

proc/LateAssign(var/mob/NewPlayer)

	//Due to how BYOND syntax works, I can't just do Teams[blah].len.  Seriously.
	var/list/A = Teams[TeamAttackers]
	var/list/D = Teams[TeamAttackers]

	if (A.len > D.len)
		Teams[TeamDefenders] += NewPlayer
	else
		Teams[TeamAttackers] += NewPlayer