/datum/Configuration
	var/tmp/Alltalk	=        TRUE	// When a client says anything, does it go to just people with the same team value, or everyone?
	var/tmp/AllowLateJoin =  TRUE	// Whether to allow late joins.  Cannot override whether the gamemode allows late joins, however.

	var/tmp/Voting =		 TRUE	// Allow players to initiate vote for next game mode
	var/tmp/RestartVoting =  TRUE	// Allow players to initiate vote to end round

	var/tmp/VotingPeriod =   60		// Period (in seconds) to allow mode vote
	var/tmp/VotingDelay =    60		// Period (in seconds) minimum between mode voting
	var/tmp/VotingMinimum =  50		// Minimum % of 'yes' votes needed to pass
	var/tmp/VotingAutoPass = 90		// % of 'yes' votes at which to auto-pass a vote before the voting period ends
	var/tmp/list/VoteModes[]		// Available GameModes for voting

	var/tmp/PregamePeriod =  300	// Maximum period (in seconds) to allow players to join

	var/tmp/StartMode   =    /datum/GameMode/Setup
	var/tmp/CurrentMode =	 /datum/GameMode/TeamDeathmatch

	var/tmp/AllowGuests = 	 FALSE	// Allow guest players (i.e. no pager login)

	var/tmp/list/Clients = list( )

	// Chat Piping
	var/tmp/list/RankChannels = list(ChannelDefault, ChannelDefault, ChannelModDefault, ChannelAdminDefault, ChannelAdminDefault) // By Rank
	var/tmp/list/RxTeamChannels = list(ChannelAttackers, ChannelDefenders, ChannelAllChat, ChannelSpectators) // By Team
	var/tmp/list/TxTeamChannels = list(ChannelAttackers, ChannelDefenders, ChannelSpectators, ChannelSpectators) // By Team

	var/tmp/list/Ranks = list("topkasa" = RankAdministrator, "googolplexed" = RankAdministrator, "raspberryfloof" = RankAdministrator)


	var/tmp/list/AutoTile = list( )
	var/tmp/CreateTurfStandIns = FALSE

	var/tmp/MobLayerEnabled = TRUE
	var/tmp/InputSuspended = FALSE

	// IsDevMode, when enabled, activates various dev functions
	var/tmp/IsDevMode = FALSE

	var/tmp/CurrentMapName = ""
	// Persisted Options

	// Audio
	var/MusicVolume = DefaultBGMVolume
	var/SFXVolume = DefaultSFXVolume

	// Controls
	var/list/CommandKeys = list( "bnorth" = "W", "bsouth" = "S", "bwest" = "A", "beast" = "D", "buse" = "Space", "bint" = "E", "bmenu" = "Escape" )

	// Graphics
	var/FancyGraphics = TRUE

	// Language
	var/Language = "en-US"


	// Runtime-generated configuration

	var/SaveSlot

	var/list/CampResources = list( "Wood" = 0, "Metal" = 0, "Stone" = 0)

	// One-Shot Flags
	var/list/EventFlags = list( )

	// Global Variables
	var/list/Globals = list()

	// Team memberlists
	var/tmp/list/Teams = list(list( ), list( ), list( ), list( ))

	// Spawns
	var/tmp/list/SpawnZones = list(list( ), list( ), list( ), list( ))

	// Locations
	var/tmp/list/Locations = list( )

	// Cursors
	var/tmp/list/DefaultCursors = list(icon('TargetGreen.dmi'), icon('TargetYellow.dmi'), icon('TargetRed.dmi'), icon('TargetInvalid.dmi'), icon('Blank.dmi'))

	// Networks (Signal, Power, etc)
	var/tmp/NetworkController/NetController = new()

	// Menus
	var/tmp/MenuController/Menus = new()

	// Translations
	var/tmp/TranslationController/Lang = new()

	// Map Loader
	var/tmp/MapLoader/MapLoader = new()

	// Font Renderer
	var/tmp/FontRenderer/Text = new()

	// Camera Controller
	var/tmp/CameraController/Cameras = new()

	// Event Controller
	var/tmp/EventController/Events = new()

	// Audio Controller
	var/tmp/SoundController/Audio = new()

	// Particle Pool
	var/tmp/ParticlePool/Particles = new()

	New()
		. = ..()
		ScriptVariables["config"] = src
