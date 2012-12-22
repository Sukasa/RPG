/datum/Configuration
	var/Alltalk	=       TRUE	// When a client says anything, does it go to just people with the same team value, or everyone?
	var/AllowLateJoin = TRUE	// Whether to allow late joins.  Cannot override whether the gamemode allows late joins, however.

	var/Voting =		TRUE	// Allow players to initiate vote for next game mode
	var/RestartVoting = TRUE	// Allow players to initiate vote to end round

	var/VotingPeriod			// Period (in seconds) to allow mode vote
	var/VotingDelay				// Period (in seconds) minimum between mode voting
	var/list/AvailableModes[]	// Available GameModes for voting

