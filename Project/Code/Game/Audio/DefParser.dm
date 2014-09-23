/DefParser
	var
		StreamReader/InputFile
		SoundDef/Definition
		DefinitionKey

		list/Constants = list(
								"EnvironmentGeneric" = EnvironmentGeneric, 			"EnvironmentPaddedCell" = EnvironmentPaddedCell,		"EnvironmentRoom" = EnvironmentRoom,
								"EnvironmentBathroom" = EnvironmentBathroom,		"EnvironmentLivingRoom" = EnvironmentLivingRoom,		"EnvironmentStoneRoom" = EnvironmentStoneRoom,
								"EnvironmentAuditorium" = EnvironmentAuditorium,	"EnvironmentConcertHall" = EnvironmentConcertHall,		"EnvironmentCave" = EnvironmentCave,
								"EnvironmentArena" = EnvironmentArena, 				"EnvironmentHangar" = EnvironmentHangar, 				"EnvironmentCarpetedHallway" = EnvironmentCarpetedHallway,
								"EnvironmentHallway" = EnvironmentHallway, 			"EnvironmentStoneCorridor" = EnvironmentStoneCorridor,	"EnvironmentAlley" = EnvironmentAlley,
								"EnvironmentForest" = EnvironmentForest,			"EnvironmentCity" = EnvironmentCity, 					"EnvironmentMountains" = EnvironmentMountains,
								"EnvironmentQuarry" = EnvironmentQuarry,			"EnvironmentPlain" = EnvironmentPlain,					"EnvironmentParkingLot" = EnvironmentParkingLot,
								"EnvironmentSewer" = EnvironmentSewer,				"EnvironmentUnderwater" = EnvironmentUnderwater,		"EnvironmentDrugged" = EnvironmentDrugged,
								"EnvironmentDizzy" = EnvironmentDizzy, 				"EnvironmentPsychotic" = EnvironmentPsychotic,

								"SoundTypeOneOff" = SoundTypeOneOff, 				"SoundTypeAmbience" = SoundTypeAmbience,				"SoundTypeBGM" = SoundTypeBGM,
								"SoundTypeMask" = SoundTypeMask,					"SoundModeExclusive" = SoundModeExclusive, 				"SoundModeNo3D" = SoundModeNo3D
							 )

	proc
		ParseDefinitionFile(var/Filename)
			. = list()
			Definition = null
			InputFile = new/StreamReader(Filename)
			InputFile.StripCarriageReturns()

			while (!InputFile.EOF())
				var/Line = InputFile.TakeLine()

				if (findtext(Line, "\[") == 1)
					if (Definition)
						Config.Audio.UpdateDefinition(DefinitionKey, Definition)
						. += DefinitionKey
					Definition = new/SoundDef()
					DefinitionKey = copytext(Line, 2, -1)
					continue
				else if (!findtext(Line, "=") || findtext(Line, "#") == 1 || !Definition)
					continue

				if (Definition)
					var/VarName = copytext(Line, 1, findtext(Line, "="))
					var/Value = copytext(Line, findtext(Line, "=") + 1)
					if (Value in Constants)
						Value = Constants[Value]

					if (!VarName in Definition.vars)
						Definition = null

					if (Definition)
						if (IsNumeric(Value))
							Value = text2num(Value)
						Definition.vars[VarName] = Value

			if (Definition)
				Config.Audio.UpdateDefinition(DefinitionKey, Definition)
				. += DefinitionKey