#define TRUE 1
#define FALSE 0

var
	const

		#ifdef DEBUG
		Debug = TRUE
		#else
		Debug = FALSE
		#endif

		KeyStateUp = 0
		KeyStatePressed = 1
		KeyStateDepressed = 2

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

		DamageTypePiercing = 1 	// Causes internal bleeding.  Chance of causing a critical bleed.  Armour can stop this.
		DamageTypeBlunt = 2    	// Impact damage.  Stun, and causes minor internal bleeding for powerful shocks.
		DamageTypeBurn = 4     	// Applies blood loss if burns are bad enough but only stunning otherwise.
		DamageTypeSlash = 8    	// Depth depends on BaseDamage.  Armour stops this.
		DamageTypePoison = 16  	// If the target has existing injuries (Piercing, bloodloss), exacerbate.  Otherwise, ineffective.
		DamageTypeStun = 32	   	// Stuns a target, but does no other damage

		TargetEnemies = 1		// An item can be used on your enemies (default CanTarget() only)
		TargetAllies = 2		// An item can be used on yourself or your allies (default CanTarget() only)
		TargetTerrain = 4		// An item can be used on the environment (default CanTarget() only)
		TargetHUD = 8			// An item can be used on HUD element (e.g. inventory management).  Not yet implemented.

		TargetAll =     TargetEnemies | TargetAllies | TargetTerrain | TargetHUD
		TargetMap = 	TargetEnemies | TargetAllies | TargetTerrain
		TargetPlayers = TargetEnemies | TargetAllies

		CursorGreen = 1			// Default green crosshairs
		CursorYellow = 2		// Default yellow crosshairs
		CursorRed = 3			// Default red crosshairs
		CursorInvalid = 4		// Default 'invalid action' marker
		CursorNone = 5			// Blank / invisible cursor

		ButtonEast = "beast"
		ButtonWest = "bwest"
		ButtonNorth = "bnorth"
		ButtonSouth = "bsouth"
		ButtonUse = "buse"
		ButtonInteract = "bint"
		ButtonMenu = "bmenu"

		DefaultLanguage = "en-US"
		DefaultBGMVolume = 15
		DefaultSFXVolume = 15

		TickerNotStarted = 0
		TickerRunning = 1
		TickerSuspended = 2

		CliffFaceOffset = 0.5

		MobLayer = 10
		ShadowLayer = 19
		OverlayLayer = 20
		HUDLayer = 99
		FlashLayer = 100
		UILayer = 101
		TextLayer = 102
		MapMarkerLayer = 10

		AlignLeft = 1
		AlignCenter = 2
		AlignRight = 3

		ColorWhite = rgb(255, 255, 255)
		ColorGrey = rgb(128, 128, 128)
		ColorRed = rgb(255, 0, 0)
		ColorBlack = rgb(0, 0, 0)
		ColorDarkRed = rgb(128, 0, 0)

		Infinity = 1.#INF
		NegativeInfinity = -1.#INF

		Visible = 0
		Invisible = 101

		AlphaTransparent = 0
		AlphaOpaque = 255
		AlphaHalf = 128

		// ASCII Codes
		LineFeed = 10
		CarriageReturn = 13
		Space = 32
		DoubleQuote = 34
		SingleQuote = 39
		OpenParenthesis = 40
		EndParenthesis = 41
		Comma = 44
		ForwardSlash = 47
		Semicolon = 59
		Equals = 61
		N = 78
		R = 82
		SmallN = 110
		SmallR = 114
		Backslash = 92
		OpenBracket = 123
		EndBracket = 125

		// Menu control codes
		ControlUp = 1
		ControlDown = 2
		ControlLeft = 3
		ControlRight = 4
		ControlEnter = 5
		ControlEscape = 6
		ControlReleased = 16


	list

		//NOTE: Don't change the order of these!  The Cardinal* and CardinalAngles* value orders match up with code implemented in Utility/Geometry.dm and Atom.dm
		Cardinal = 			list(NORTH, EAST, SOUTH, WEST)
		CardinalAngles = 	list(90, 180, 270, 360)

		Cardinal8 = 		list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
		CardinalAngles8 =	list(45, 90, 135, 180, 225, 270, 315, 360)

		DirectionAngles =   list(0, 0, 180, 0, 90, 45, 135, 0, 270, 315, 225, 0, 0, 0, 0, 0)
		AutoJoinBits8	=	list(1, 2, 4, 8, 16, 32, 64, 128)

		// Text Colours
		TextColours 	= list("\red" =     rgb(255, 0, 0),     "\green" = rgb(0, 255, 0),   "\blue" =   rgb(32, 64, 255),
							   "\magenta" = rgb(255, 0, 255),   "\cyan" =  rgb(0, 255, 255), "\yellow" = rgb(255, 255, 0),
							   "\white" =   rgb(255, 255, 255), "\black" = rgb(0, 0, 0) )

		// Rank Titles
		RankTitles 		= list("Banned", "Player", "Moderator", "Programmer", "Administrator")

		CliffFaceStates = list("7", "199", "193", "247", "223")
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