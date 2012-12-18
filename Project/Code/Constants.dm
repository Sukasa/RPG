#define TRUE 1
#define FALSE 0

var
	const
		RankPlayer = 0
		RankModerator = 1
		RankProgrammer = 2
		RankAdministrator = 3

	list

		//NOTE: Don't change the order of these!  The Cardinal* and CardinalAngles* value orders match up with code implemented in Utility/Geometry.dm and Atom.dm
		Cardinal = list(NORTH, EAST, SOUTH, WEST)
		CardinalAngles = list(90, 180, 270, 360)

		Cardinal8 = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
		CardinalAngles8 = list(45, 90, 135, 180, 225, 270, 315, 360)

