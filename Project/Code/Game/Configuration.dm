/datum/Configuration
	var/Alltalk	=        TRUE	// When a client says anything, does it go to just people with the same team value, or everyone?
	var/AllowLateJoin =  TRUE	// Whether to allow late joins.  Cannot override whether the gamemode allows late joins, however.

	var/Voting =		 TRUE	// Allow players to initiate vote for next game mode
	var/RestartVoting =  TRUE	// Allow players to initiate vote to end round

	var/VotingPeriod =   60		// Period (in seconds) to allow mode vote
	var/VotingDelay =    60		// Period (in seconds) minimum between mode voting
	var/VotingMinimum =  50		// Minimum % of 'yes' votes needed to pass
	var/VotingAutoPass = 90		// % of 'yes' votes at which to auto-pass a vote before the voting period ends
	var/list/VoteModes[]		// Available GameModes for voting

	var/PregamePeriod =  300	// Maximum period (in seconds) to allow players to join

	// Chat Piping
	var/list/DefaultChannels = list( ChannelDefault, ChannelDefault, ChannelModDefault, ChannelAdminDefault, ChannelAdminDefault ) // By Rank
	var/list/TeamChannels = list( ChannelAttackers, ChannelDefenders, ChannelSpectators, ChannelAllChat) // By Team



	// Runtime-generated configuration


	// Spawns
	var/list/SpawnZones = list( list( ), list( ), list( ), list( ) )

	// Commands
	var/datum/CommandController/Commands = new()
