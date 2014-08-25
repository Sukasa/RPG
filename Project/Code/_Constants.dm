#define TRUE 1
#define FALSE 0

/*
 *		Constants File.  This file contains all of the compile-time constants (but done up as const vars), plus a few "constants" that are
 *	produced at run-time such as tile autojoin and all of the /list constants.
 */

var
	const

		Pi = 3.1415926535			// Pi.  This should be accurate enough for most uses.

		#ifdef DEBUG
		Debug = TRUE				// Debug variable marks current compile mode (Debug or Release)
		#else
		Debug = FALSE				// Debug variable marks current compile mode (Debug or Release)
		#endif

		DefaultWorldView = 9		// Default world view radius

		KeyStateUp = 0				// Key is unpressed
		KeyStatePressed = 1			// Key was just pressed
		KeyStateDepressed = 2		// Key has been held down for more than 1 frame

		RankUnranked = 0			// Unranked player.  Technically a bug if your Rank is 0 after respawn
		RankBanned = 1				// Banned player.  Allowed to watch but not interact.
		RankPlayer = 2				// Regular player
		RankModerator = 3			// Game moderator.  Bans, rule enforcement, etc
		RankProgrammer = 4			// Game programmer.  Primarily used for debugging purposes
		RankAdministrator = 5		// Administrator rank, used for game administration
		RankScriptsOnly = 6			// Nobody can run this command; only event scripts

		ChatboxMaxHeight = 14		// Maximum height (in lines of text) of the chat box
		ChatboxLifetime = 110		// How long (in 10ths of a second) lines in chat should remain visible
		ChatboxOffsetX = 12			// X offset in pixels of the chat box from the lower-left corner of the screen
		ChatboxOffsetY = 12			// Y offset in pixels of the chat box from the lower-left corner of the screen
		ChatBoxTextOffsetY = 1		// X offset in pixels of the text from the lower-left corner of the chat box
		ChatBoxTextOffsetX = 3		// Y offset in pixels of the text from the lower-left corner of the chat box

		TeamUnknown = 0				// 'Unassigned' team marker, or a bot
		TeamAttackers = 1			// Attacking Team
		TeamDefenders = 2			// Defending Team
		TeamSpectators = 3			// Spectating Team
		TeamPregame = 4				// Pregame team

		ChannelAttackers = 1		// Attacker chat
		ChannelDefenders = 2		// Defender chat
		ChannelSpectators = 4		// Spectator chat
		ChannelAdmin = 8			// Admin chat
		ChannelDebug = 16			// Debug info
		ChannelGame = 32			// Game text.  Consists of game information such as kill announcement, flag captures, etc
		ChannelInfo = 64			// Info text.  Consists of game meta-information, such as admins starting the round, rule changes, etc

		ChannelAllChat = ChannelAttackers | ChannelDefenders | ChannelSpectators

		ChannelDefault = ChannelGame | ChannelInfo
		ChannelModDefault = ChannelDefault | ChannelAdmin
		ChannelAdminDefault = ChannelModDefault | ChannelDebug

		ChannelNone = 0
		ChannelAll = 65535

		// Basic object sizes.  Object size is a scale from 0 to 10, but the meaning of that scale has yet to be determined.
		SizeTiny = 0
		SizeSmall = 2
		SizeMedium = 4
		SizeLarge = 7
		SizeHuge = 10

		DamageTypePiercing = 1 		// Causes internal bleeding.  Chance of causing a critical bleed.  Armour can stop this.
		DamageTypeBlunt = 2   	 	// Impact damage.  Stun, and causes minor internal bleeding for powerful shocks.
		DamageTypeBurn = 4    	 	// Applies blood loss if burns are bad enough but only stunning otherwise.
		DamageTypeSlash = 8   	 	// Depth depends on BaseDamage.  Armour stops this.
		DamageTypePoison = 16 	 	// If the target has existing injuries (Piercing, bloodloss), exacerbate.  Otherwise, ineffective.
		DamageTypeStun = 32	  	 	// Stuns a target, but does no other damage

		TargetEnemies = 1			// An item can be used on your enemies (default CanTarget() only)
		TargetAllies = 2			// An item can be used on yourself or your allies (default CanTarget() only)
		TargetTerrain = 4			// An item can be used on the environment (default CanTarget() only)
		TargetHUD = 8				// An item can be used on HUD element (e.g. inventory management).  Not yet implemented.

		TargetAll =     TargetEnemies | TargetAllies | TargetTerrain | TargetHUD
		TargetMap = 	TargetEnemies | TargetAllies | TargetTerrain
		TargetPlayers = TargetEnemies | TargetAllies

		CursorGreen = 1				// Default green crosshairs
		CursorYellow = 2			// Default yellow crosshairs
		CursorRed = 3				// Default red crosshairs
		CursorInvalid = 4			// Default 'invalid action' marker
		CursorNone = 5				// Blank / invisible cursor

		ButtonEast = "beast"		// Move-East button name
		ButtonWest = "bwest"		// Move-West button name
		ButtonNorth = "bnorth"		// Move-North button name
		ButtonSouth = "bsouth"		// Move-South button name
		ButtonUse = "buse"			// Use-Item button name
		ButtonInteract = "bint"		// Interact-With button name
		ButtonMenu = "bmenu"		// Pause Menu button name

		// Sound environment variables, for EAX.  A safe assumption that your sound card doesn't actually support this.
		EnvironmentGeneric = 0
		EnvironmentPaddedCell = 1
		EnvironmentRoom = 2
		EnvironmentBathroom = 3
		EnvironmentLivingRoom = 4
		EnvironmentStoneRoom = 5
		EnvironmentAuditorium = 6
		EnvironmentConcertHall = 7
		EnvironmentCave = 8
		EnvironmentArena = 9
		EnvironmentHangar = 10
		EnvironmentCarpetedHallway = 11
		EnvironmentHallway = 12
		EnvironmentStoneCorridor = 13
		EnvironmentAlley = 15
		EnvironmentForest = 16
		EnvironmentCity = 16
		EnvironmentMountains = 17
		EnvironmentQuarry = 18
		EnvironmentPlain = 19
		EnvironmentParkingLot = 20
		EnvironmentSewer = 21
		EnvironmentUnderwater = 22
		EnvironmentDrugged = 23
		EnvironmentDizzy = 24
		EnvironmentPsychotic = 25

		SoundTypeOneOff = 0			// This sound plays once and does not loop
		SoundTypeAmbience = 1		// This is an ambient sound, which may have multiple emission points
		SoundTypeBGM = 2			// This sound is BGM, and is unaffected by environmental factors.
		SoundTypeMask = 3			// Masks sound data to determine Ambience/BGM/One-Off type
		SoundModeExclusive = 32		// This is an 'exclusive' one-off, and the /sound object should not be pooled globally
		SoundModeNo3D = 64			// Disable 3D effects on the sound.  Not applicable to BGMs

		MaxVoices = 512				// Maximum number of dynamic sound emitters at any one time
		DynamicChannelOffset = 16	// What channel number to start assigning from for dynamic emitters
		SoundChannelBGM = 1			// What channel number to use for BGM

		DialogueResultPending = 0	// Result code from a dialogue for "The user hasn't selected yet"
		DialogueResultViewed = 1	// Result code from a dialogue for "The user hasn't selected yet, but the dialogue is onscreen"
		DialogueResultYes = 2		// Result code from a dialogue for "The user selected yes"
		DialogueResultNo = 3		// Result code from a dialogue for "The user selected no"

		DefaultLanguage = "en-US"	// Default game language

		MaxVolume = 16				// Maximum volume, according to game UI, from 0..MaxVolume
		DefaultBGMVolume = MaxVolume// Default BGM volume for new games
		DefaultSFXVolume = MaxVolume// Default SFX volume for new games

		TickerNotStarted = 0		// Game ticker has not started, or stopped
		TickerRunning = 1			// Game ticker is running
		TickerSuspended = 2			// Game ticker operation temporarily suspended

		CliffFaceOffset = 0.5		// Amount to reduce the cliff face's layer by, to ensure correct ordering against north ledges

		AutojoinTerrainLayer = 9	// Layer to draw autojoined objects at that are part of the terrain
		MobLayer = 10				// Mob draw layer
		MapMarkerLayer = 10			// MapMarker draw layer, when made viewable via debug call
		ShadowLayer = 19			// Layer to draw object shadows
		StructureLayer = 20			// Tree structure layer
		OverlayLayer = 21			// Layer for overlay graphics, e.g. tree leaves
		HUDLayer = 99				// HUD object layer.  Not used for player UI
		FlashLayer = 100			// Flash layer, also use for fadein/fadeouts
		UILayer = 101				// UI Layer, for things like the HUD and menus
		TextLayer = 102				// Layer to draw all rendered text on (unless overridden)

		AlignLeft = 1				// Align rendered text to the left of the supplied text box
		AlignCenter = 2				// Center rendered text within the supplied text box
		AlignRight = 3				// Align rendered text to the right of the supplied text box

		Infinity = 1.#INF
		NegativeInfinity = -1.#INF

		Visible = 0					// "Visble Always" setting for atom.visibility var
		Invisible = 101				// "Never Visible" setting for atom.visibility var

		AlphaTransparent = 0		// Fully transparent alpha.  Same effect as using Invisible visibility
		AlphaOpaque = 255			// Fully opaque alpha.  Same effect as using Visible visibility
		AlphaHalf = 128				// Semitransparent alpha, half-visible.

		// ASCII Codes
		Tab = 9						// ASCII code for a tab 					(	)
		LineFeed = 10				// ASCII code for a line feed 				(\n)
		CarriageReturn = 13			// ASCII code for a carriage return 		(\r)
		Space = 32					// ASCII code for a space 					( )
		DoubleQuote = 34			// ASCII code for a double quote 			(")
		SingleQuote = 39			// ASCII code for a single quote			(')
		OpenParenthesis = 40		// ASCII code for an open parenthesis 		(()
		EndParenthesis = 41			// ASCII code for an end parenthesis 		())
		Comma = 44					// ASCII code for a comma					(,)
		ForwardSlash = 47			// ASCII code for a forward slash 			(/)
		Semicolon = 59				// ASCII code for a semicolon				(;)
		Equals = 61					// ASCII code for an equals sign character	(=)
		N = 78						// ASCII code for N 						(N)
		R = 82						// ASCII code for R 						(R)
		SmallN = 110				// ASCII code for n 						(n)
		SmallR = 114				// ASCII code for r 						(r)
		Backslash = 92				// ASCII code for a backslash 				(\)
		OpenBracket = 123			// ASCII code for a square opening bracket	([)
		EndBracket = 125			// ASCII code for a square end bracket 		(])

		// Standardized menu control codes
		ControlUp = 1				// Move cursor up
		ControlDown = 2				// Move cursor down
		ControlLeft = 3				// Move cursor left
		ControlRight = 4			// Move cursor right
		ControlEnter = 5			// Accept / Enter
		ControlEscape = 6			// Cancel / Exit
		ControlReleased = 32		// Control was released

		// Various colour values
		ColorWhite = rgb(255, 255, 255)
		ColorGrey = rgb(128, 128, 128)
		ColorRed = rgb(255, 0, 0)
		ColorBlack = rgb(0, 0, 0)
		ColorDarkRed = rgb(128, 0, 0)
		ColorBlue = rgb(0, 0, 255)
		ColorDarkBlue = rgb(0, 0, 128)
		ColorYellow = rgb(255, 255, 0)

	list

		//NOTE: Don't change the order of these!  The Cardinal* and CardinalAngles* value orders match up with code implemented in Utility/Geometry.dm and Atom.dm
		Cardinal = 			list(NORTH, EAST, SOUTH, WEST)
		CardinalAngles = 	list(90, 180, 270, 360)

		Cardinal8 = 		list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
		CardinalAngles8 =	list(45, 90, 135, 180, 225, 270, 315, 360)

		// Conversion array to take BYOND dir value and convert to an angle.  Used in polar coordinate math
		DirectionAngles =   list(0, 0, 180, 0, 90, 45, 135, 0, 270, 315, 225, 0, 0, 0, 0, 0)

		// Rank Titles (old MP code)
		RankTitles 		= list("Banned", "Player", "Moderator", "Programmer", "Administrator")

		// Text Colours
		TextColours 	= list(
								"\red"			= rgb(255, 0, 0),     			"\green"		= rgb(0, 255, 0),  			"\blue"				= rgb(32, 64, 255),
								"\magenta"		= rgb(255, 0, 255),   			"\cyan"			= rgb(0, 255, 255),			"\yellow"			= rgb(255, 255, 0),
								"\white"		= rgb(255, 255, 255), 			"\black"		= rgb(0, 0, 0)
							  )


		// Constants defined for use in scripts
		ScriptConstants = list(
								"true"			= TRUE,							"false"			= FALSE,					"oneFrame"			= world.tick_lag,
								"isDebug"		= Debug, 						"tileSize"		= world.icon_size,			"black"				= ColorBlack,
								"white"			= ColorWhite,					"grey"			= ColorGrey,				"red"				= ColorRed,
								"darkRed"		= ColorDarkRed,					"blue"			= ColorBlue,				"darkBlue"			= ColorDarkBlue,
								"alphaOpaque"	= AlphaOpaque,					"alphaHalf"		= AlphaHalf,				"alphaTransparent"	= AlphaTransparent,
								"resultPending"	= DialogueResultPending,		"resultViewed"	= DialogueResultViewed,		"fps"				= world.fps
							  )

		// Function calls available to scripts.  Note that variables may have their own function calls available as well
		ScriptFunctions = list(
								"min" 			= /proc/ProxyMin,				"sign" 			= /proc/sign, 				"max" 				= /proc/ProxyMax,
								"sin" 			= /proc/ProxySin,				"cos" 			= /proc/ProxyCos,			"tan" 				= /proc/tan,
								"atan" 			= /proc/arctan,					"abs" 			= /proc/ProxyAbs,			"fix" 				= /proc/fix,
								"floor" 		= /proc/ProxyFloor, 			"ceil" 			= /proc/ceil,				"array" 			= /proc/ProxyList,
								"locate" 		= /proc/ProxyLocate,			"isAtom" 		= /proc/IsAtom,				"isObj" 			= /proc/IsObj,
								"subTypes" 		= /proc/Subtypes,				"isList" 		= /proc/IsList,				"sleep" 			= /proc/ProxySleep,
								"debug" 		= /proc/DebugText,				"error" 		= /proc/ErrorText,			"newDialogue" 		= /proc/CreateDialogue,
								"queueDialogue" = /proc/ScriptQueueDialogue,	"makeCamera"	= /proc/ScriptCreateCamera,	"camera" 			= /proc/ScriptGetCamera,
								"fadeOut"		= /proc/ScriptFadeOut,			"fadeIn" 		= /proc/ScriptFadeIn,		"saveGame"			= /proc/ScriptSaveGame,
								"loadMap"		= /proc/ScriptLoadMap,			"loadChunk" 	= /proc/ScriptLoadChunk,	"menu"				= /proc/ScriptShowMenu,
								"run"			= /proc/ScriptRun,				"spawn"			= /proc/ScriptSpawn,		"kill"				= /proc/ScriptKill,
								"isType"		= /proc/ScriptIsType,			"setFade"		= /proc/ScriptSetFade
							  )

		// Config/Player variables are set later
		ScriptVariables = list(
							    "world"			= world,						"config"		= null,						"player" = null
							  )

		ReedRootStates  = list(
								"7", "199", "193"
							  )

		// Cliff stuff
		CliffFaceStates = list(
							    "7", "199", "193", "247", "223"
							  )


		// Collision bounds for cliffs
		CliffBounds 	= list(
            					"31"  = list("bound_x" = 15, "bound_width" = 10),
            					"241" = list("bound_x" = 8, "bound_width" = 6),
            					"124" = list("bound_y" = 11, "bound_height" = 4),
            					"199" = list("bound_y" = 23, "bound_height" = 2),
				            	"7"   = list("bound_x" = 15, "bound_width" = 10),
				            	"28"  = list("bound_x" = 15, "bound_width" = 10, "bound_y" = 11, "bound_height" = 4),
				            	"112" = list("bound_x" = 8, "bound_width" = 6, "bound_y" = 11, "bound_height" = 4),
				            	"193" = list("bound_x" = 8, "bound_width" = 6),
				            	"223" = list("bound_width" = 19, "bound_height" = 19),
				            	"127" = list("bound_width" = 19, "bound_y" = 15, "bound_height" = 13),
				            	"247" = list("bound_x" = 13, "bound_width" = 16, "bound_y" = 7, "bound_height" = 11),
				            	"253" = list("bound_x" = 13, "bound_width" = 16, "bound_y" = 15, "bound_height" = 14),
            				  )

		BoundsOverrides = list(
            					"31" = list("bound_width" = 15),
            					"241" = list("bound_x" = 10, "bound_width" = 22),
            					"124" = list("bound_y" = 12)
            				  )

		TopCliffs       = list(
        						"127", "253"
        					  )