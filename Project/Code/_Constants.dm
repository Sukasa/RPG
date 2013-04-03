#define TRUE 1
#define FALSE 0

var
	const

		#ifdef DEBUG
		Debug = TRUE
		#else
		Debug = FALSE
		#endif

		RankBanned = 1
		RankPlayer = 2
		RankModerator = 3
		RankProgrammer = 4
		RankAdministrator = 5

		ChatboxMaxHeight = 14	//Maximum height (in lines of text) of the chat box
		ChatboxLifetime = 80		//How long (in 10ths of a second) lines in chat should remain visible
		ChatboxOffsetX = 12
		ChatboxOffsetY = 12
		ChatBoxTextOffsetY = 1
		ChatBoxTextOffsetX = 3

		TeamUnknown = 0
		TeamAttackers = 1
		TeamDefenders = 2
		TeamSpectators = 3
		TeamPregame = 4

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

		SizeTiny = 0
		SizeSmall = 2
		SizeMedium = 4
		SizeLarge = 7
		SizeHuge = 10

		DamageTypePiercing = 1 // Causes internal bleeding.  Chance of causing a critical bleed.  Armour can stop this.
		DamageTypeBlunt = 2    // Impact damage.  Stun, and causes minor internal bleeding for powerful shocks.
		DamageTypeBurn = 4     // Applies blood loss if burns are bad enough but only stunning otherwise.
		DamageTypeSlash = 8    // Depth depends on BaseDamage.  Armour stops this.
		DamageTypePoison = 16  // If the target has existing injuries (Piercing, bloodloss), exacerbate.  Otherwise, ineffective.
		DamageTypeStun = 32	   // Stuns a target, but does no other damage

		TargetEnemies = 1
		TargetAllies = 2
		TargetTerrain = 4

		TargetAll =     TargetEnemies | TargetAllies | TargetTerrain
		TargetPlayers = TargetEnemies | TargetAllies

		CursorGreen = 1
		CursorYellow = 2
		CursorRed = 3
		CursorInvalid = 4
		CursorNone = 5

	list

		//NOTE: Don't change the order of these!  The Cardinal* and CardinalAngles* value orders match up with code implemented in Utility/Geometry.dm and Atom.dm
		Cardinal = list(NORTH, EAST, SOUTH, WEST)
		CardinalAngles = list(90, 180, 270, 360)

		Cardinal8 = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
		CardinalAngles8 = list(45, 90, 135, 180, 225, 270, 315, 360)

		// Text Colours.
		TextColours = list ( "\red" =     rgb(255, 0, 0), 	"\green" = rgb(0, 255, 0),   "\blue" =   rgb(32, 64, 255),
						 	 "\magenta" = rgb(255, 0, 255), "\cyan" =  rgb(0, 255, 255), "\yellow" = rgb(255, 255, 0),
						     "\white" =   rgb(255, 255, 255) )

