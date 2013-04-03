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

	var/CurrentMode =	 /datum/GameMode/TeamDeathmatch

	var/AllowGuests = 	 FALSE	// Allow guest players (i.e. no pager login)

	// Chat Piping
	var/list/RankChannels = list(ChannelDefault, ChannelDefault, ChannelModDefault, ChannelAdminDefault, ChannelAdminDefault) // By Rank
	var/list/RxTeamChannels = list(ChannelAttackers, ChannelDefenders, ChannelAllChat, ChannelSpectators) // By Team
	var/list/TxTeamChannels = list(ChannelAttackers, ChannelDefenders, ChannelSpectators, ChannelSpectators) // By Team

	var/list/Ranks = list("topkasa" = RankProgrammer, "googolplexed" = RankAdministrator)

	//TODO load from config file
	//TODO save to config file?


	// Runtime-generated configuration
	var/list/Teams = list(list( ), list( ), list( ), list( ))

	// Spawns
	var/list/SpawnZones = list(list( ), list( ), list( ), list( ))

	// Commands
	var/datum/CommandController/Commands = new()

	// Cursors
	var/list/DefaultCursors = list(icon('TargetGreen.dmi'), icon('TargetYellow.dmi'), icon('TargetRed.dmi'), icon('TargetInvalid.dmi'), icon('Blank.dmi'))

	proc/RegisterCursor(var/Icon)
		DefaultCursors += GetCursor(Icon)
		return length(DefaultCursors)

	// Networks (Signal, Power, etc)
	var/datum/NetworkController/NetController = new()