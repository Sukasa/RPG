#define TRUE 1
#define FALSE 0

var
	const
		RankPlayer = 0
		RankModerator = 1
		RankProgrammer = 2
		RankAdministrator = 3

		MaxChatboxHeight = 9	//Maximum height (in lines of text) of the chat box
		SpeechLifetime = 70		//How long (in 10ths of a second) lines in chat should remain visible
		ChatboxOffsetX = 12
		ChatboxOffsetY = 12


		ChannelAttackers = 1
		ChannelDefenders = 2
		ChannelSpectators = 4
		ChannelAdmin = 8
		ChannelDebug = 16
		ChannelGame = 32
		ChannelInfo = 64


		ChannelNone = 0
		ChannelAll = 65535

	list

		//NOTE: Don't change the order of these!  The Cardinal* and CardinalAngles* value orders match up with code implemented in Utility/Geometry.dm and Atom.dm
		Cardinal = list(NORTH, EAST, SOUTH, WEST)
		CardinalAngles = list(90, 180, 270, 360)

		Cardinal8 = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
		CardinalAngles8 = list(45, 90, 135, 180, 225, 270, 315, 360)