/datum/MapLoader
	var
		MapWidth = 0
		MapHeight = 0
		TileCharacterCount = 0
		SeekPosition = 1
		MapFile

		list
			Templates = list( )
			TemplateMap = list( )

		const // ASCII Constants
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


/datum/MapLoader/proc/LoadMap(var/MapID, var/Loc = locate(1, 1, 1))
	// Load a previously parsed map
	var/datum/CachedMap/Map
	Config.MapCache[MapID] >> Map

	Templates = Map.Templates
	TemplateMap = Map.TemplateMap

	CreateMap(Loc)

// Load a raw .dmm file, parse it, and create it.  Does not save the map to cache.
/datum/MapLoader/proc/LoadRawMap(var/Filename)
	ASSERT(fexists(Filename))
	MapFile = file2text(file(Filename))
	StripCarriageReturns()
	ParseMap()
	CreateMap()

// Import a map file into the cache
/datum/MapLoader/proc/ImportMap(var/Filename, var/MapID)
	ASSERT(fexists(Filename))
	MapFile = file2text(file(Filename))
	StripCarriageReturns()
	Config.MapCache[MapID + "-raw"] << MapFile
	MapFile = null

// Save a parsed map to cache
/datum/MapLoader/proc/SaveMap(var/MapID)
	var/datum/CachedMap/Map = new()
	Map.Id = MapID
	Map.Templates = Templates
	Map.TemplateMap = TemplateMap
	Config.MapCache[MapID] << Map
	Templates = list( )
	TemplateMap = list( )

// Delete a raw map file
/datum/MapLoader/proc/DeleteRawMap(var/MapID)
	Config.MapCache[MapID + "-raw"] << null

// Load an imported map for parsing
/datum/MapLoader/proc/LoadImportedMap(var/MapID)
	Config.MapCache[MapID + "-raw"] >> MapFile

// Parses a loaded map
/datum/MapLoader/proc/ParseMap()
	ASSERT(istext(MapFile))
	// Variable Init
	MapWidth = 0
	MapHeight = 0
	SeekPosition = 1
	Templates = list( )
	TemplateMap = list( )

	// Parse for tile character count
	TileCharacterCount = findtext(MapFile, "\"") + 1
	TileCharacterCount = findtext(MapFile, "\"", TileCharacterCount) - TileCharacterCount

	// Parse template lines
	while (Char() == DoubleQuote)
		ParseTemplateLine()
		SeekTo(DoubleQuote, OpenParenthesis)

	// Parse Z Level
	ParseZLevel()

	// Done
	MapFile = null
	return



// Parses a template line
/datum/MapLoader/proc/ParseTemplateLine()
	// Parses the following data format into a template object
	// "aa" = (/obj/MapMarker/MapInfo/MapName{name = "Splatterhouse"; tag = "t"},/turf/Floor/Sand,/area)
	var/TemplateCode = ""

	SeekAfter(DoubleQuote)

	while (Char() != DoubleQuote)
		TemplateCode = addtext(TemplateCode, TChar())

	var/datum/TileTemplate/Template = new()
	Templates[TemplateCode] = Template

	SeekTo(ForwardSlash)

	while (Char() != EndParenthesis)
		var/datum/ObjectTemplate/Object = new()

		while (Isnt(OpenBracket, Comma, EndParenthesis))
			Object.TypePath = addtext(Object.TypePath, TChar())

		if (Char() == OpenBracket)
			while (Char() != EndBracket)

				// Get Param
				SeekAfter(OpenBracket, Semicolon, Space)
				var/Param = ""
				while(Isnt(Space, Equals))
					Param = addtext(Param, TChar())

				// Get Value
				SeekAfter(Space, Equals)

				Object.Params[Param] = GetValue()


		SeekTo(Comma, EndParenthesis)

		// Add object to template
		if (findtext(Object.TypePath, "/area") == 1)
			Template.Area = Object
		else if (findtext(Object.TypePath, "/turf") == 1)
			Template.Turf = Object
		else
			Template.Objects += Object


		if (Char() == Comma)
			continue
		else if (Char() == EndParenthesis)
			return


/datum/MapLoader/proc/GetValue()
	var/Value = ""
	var/InString = FALSE
	var/InReference = TRUE
	var/Escaped = FALSE

	while (InString || Isnt(Semicolon, EndParenthesis, Space))

		if (Escaped)
			switch(Char())
				if (N)
					Value = addtext(Value, ascii2text(LineFeed))
				if (SmallN)
					Value = addtext(Value, ascii2text(LineFeed))
				if (R)
					Value = addtext(Value, ascii2text(CarriageReturn))
				if (SmallR)
					Value = addtext(Value, ascii2text(CarriageReturn))
				else
					Value = addtext(Value, TChar())
			Escaped = FALSE
		else
			switch(Char())
				if(DoubleQuote)
					InString = !InString
					if (!InString)
						return Value
				if(SingleQuote)
					if (InString)
						Value = addtext(Value, TChar())
					else
						InReference = !InReference
						if (!InReference)
							return fcopy_rsc(Value) // This is Wrong
				if(Backslash)
					Escaped = TRUE
				else
					Value = addtext(Value, TChar())

	return text2num(Value)

/datum/MapLoader/proc/ParseZLevel()
	SeekAfter(LineFeed)
	while (Char() != DoubleQuote)
		MapHeight++
		var/list/Line = list( )
		while(Char() != LineFeed)
			Line += Templates[Take(3)]
		TemplateMap.Insert(1, Line)
		MapWidth = max(MapWidth, Line.len)
		SeekAfter(LineFeed)


/datum/MapLoader/proc/CreateMap(var/turf/Loc = locate(1, 1, 1))
	ASSERT(Templates)
	ASSERT(TemplateMap)

	var/BaseX = Loc.x
	var/BaseY = Loc.y
	var/Z = Loc.z

	var/Y = 0
	var/X = 0

	for (var/Line in TemplateMap)
		X = 0
		for (var/datum/TileTemplate/Tile in Line)
			var/turf/NewTurf = new Tile.Turf.TypePath(locate(BaseX + X, BaseY + Y, Z))
			new Tile.Area.TypePath(NewTurf)
			for(var/A in NewTurf)
				if (!ismob(A) || !A:client)
					del A
			for(var/datum/ObjectTemplate/Object in Tile.Objects)
				var/atom/Atom = new Object.TypePath
				for (var/Param in Object.Params)
					Atom.vars[Param] = Object.Params[Param]
			X++
		Y++

	// Initialize data structures

	// Networks
	Config.NetController.Init()

	// Done



//
//   UTILITY FUNCTIONS
//

// Carraige-Return stripper.  Removes all instances of \r from the code.  Used during initial import, not load-from-imported.
/datum/MapLoader/proc/StripCarriageReturns()
	var/Pos = 1
	do
		Pos = findtext(MapFile, ascii2text(CarriageReturn), Pos)
		MapFile = copytext(MapFile, 1, Pos) + copytext(MapFile, Pos + 1)
	while (Pos)

// Simple Seek-Forwards proc.  Stops at the first match.
/datum/MapLoader/proc/SeekTo()
	while (Isnt(args))
		SeekPosition++

// Simple Seek-Forwards proc, but stops after a contiguous set of matches
/datum/MapLoader/proc/SeekAfter(var/Chars)
	SeekThrough(Chars)
	SeekPosition++

// Simple Seek-Forwards proc, but stops at the end of a contiguous set of matches
/datum/MapLoader/proc/SeekThrough()
	while (Isnt(args))
		SeekPosition++
	while (Is(args))
		SeekPosition++

// Exclusion list clause
/datum/MapLoader/proc/Isnt()
	return !Is(args)

// Inclusion list clause
/datum/MapLoader/proc/Is()
	return (Char() in args)

// Gets the character currently seeked to
/datum/MapLoader/proc/Char()
	return text2ascii(MapFile, SeekPosition)

// Gets it as text
/datum/MapLoader/proc/TChar()
	return ascii2text(Char())

// Grabs the next three characters from the string as text and advances the seek pointer
/datum/MapLoader/proc/Take(var/Chars)
	. = copytext(MapFile, SeekPosition, SeekPosition + Chars)
	SeekPosition += Chars