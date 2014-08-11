/DefParser
	var
		StreamReader/InputFile
		SoundDef/Definition
		DefinitionKey

		list/Constants = list(
			"EnvironmentGeneric" = EnvironmentGeneric, 			"EnvironmentPaddedCell" = EnvironmentPaddedCell,		"EnvironmentRoom" = EnvironmentRoom,				"EnvironmentBathroom" = EnvironmentBathroom,
			"EnvironmentLivingRoom" = EnvironmentLivingRoom,	"EnvironmentStoneRoom" = EnvironmentStoneRoom,			"EnvironmentAuditorium" = EnvironmentAuditorium,	"EnvironmentConcertHall" = EnvironmentConcertHall,
			"EnvironmentCave" = EnvironmentCave, 				"EnvironmentArena" = EnvironmentArena, 					"EnvironmentHangar" = EnvironmentHangar, 			"EnvironmentCarpetedHallway" = EnvironmentCarpetedHallway,
			"EnvironmentHallway" = EnvironmentHallway, 			"EnvironmentStoneCorridor" = EnvironmentStoneCorridor,	"EnvironmentAlley" = EnvironmentAlley,				"EnvironmentForest" = EnvironmentForest,
			"EnvironmentCity" = EnvironmentCity, 				"EnvironmentMountains" = EnvironmentMountains,			"EnvironmentQuarry" = EnvironmentQuarry,			"EnvironmentPlain" = EnvironmentPlain,
			"EnvironmentParkingLot" = EnvironmentParkingLot, 	"EnvironmentSewer" = EnvironmentSewer,				"EnvironmentUnderwater" = EnvironmentUnderwater,		"EnvironmentDrugged" = EnvironmentDrugged,
			"EnvironmentDizzy" = EnvironmentDizzy, 				"EnvironmentPsychotic" = EnvironmentPsychotic,

			"SoundTypeOneOff" = SoundTypeOneOff, 	"SoundTypeAmbience" = SoundTypeAmbience,	"SoundTypeBGM" = SoundTypeBGM,
			"SoundTypeMask" = SoundTypeMask,		"SoundModeExclusive" = SoundModeExclusive, 	"SoundModeNo3D" = SoundModeNo3D
							 )

	proc
		ParseDefinitionFile(var/Filename)
			Definition = null
			InputFile = new/StreamReader(Filename)
			InputFile.StripCarriageReturns()

			while (!InputFile.EOF())
				var/Line = InputFile.TakeLine()

				if (findtext(Line, "\[") == 1)
					if (Definition)
						Config.Audio.Definitions[DefinitionKey] = Definition
						Config.Audio.DefinitionIndex -= DefinitionKey
						Config.Audio.DefinitionIndex += DefinitionKey
					Definition = new/SoundDef()
					DefinitionKey = copytext(Line, 1, -1)
				else if (!findtext(Line, "=") || !Definition)
					return

				var/VarName = copytext(Line, 1, findtext(Line, "="))
				var/Value = copytext(Line, findtext(Line, "=") + 1)
				if (Value in Constants)
					Value = Constants[Value]

				Definition.vars[VarName] = Value

