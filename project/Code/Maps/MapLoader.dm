/datum/MapLoader
	var
		MapWidth = 0
		MapHeight = 0
		TileCharacterCount = 0
		SeekPosition = 1
		MapFile

		savefile/MapCache

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


/datum/MapLoader/proc/Init()
	MapCache = new/savefile("MDATA")

/datum/MapLoader/proc/LoadMap(var/MapID, var/Loc = locate(1, 1, 1))
	// Load a previously parsed map
	var/datum/CachedMap/Map
	MapCache[MapID] >> Map

	Templates = Map.Templates
	TemplateMap = Map.TemplateMap

	MapHeight = Map.Height
	MapWidth = Map.Width

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
	MapCache[MapID + "-raw"] << MapFile
	MapFile = null

// Save a parsed map to cache
/datum/MapLoader/proc/SaveMap(var/MapID)
	var/datum/CachedMap/Map = new()
	Map.Id = MapID
	Map.Templates = Templates
	Map.TemplateMap = TemplateMap
	Map.Height = MapHeight
	Map.Width = MapWidth
	MapCache[MapID] << Map
	Templates = list( )
	TemplateMap = list( )

// Delete a raw map file
/datum/MapLoader/proc/DeleteRawMap(var/MapID)
	MapCache[MapID + "-raw"] << null

// Load an imported map for parsing
/datum/MapLoader/proc/LoadImportedMap(var/MapID)
	MapCache[MapID + "-raw"] >> MapFile

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

	//world.log << "Parse"

	while (Char() != DoubleQuote)
		TemplateCode = addtext(TemplateCode, Take(1))

	//world.log << "Template Code is [TemplateCode]"

	var/datum/TileTemplate/Template = new()
	Templates[TemplateCode] = Template

	SeekTo(ForwardSlash)

	while (Char() != EndParenthesis)
		var/datum/ObjectTemplate/Object = new()

		while (Isnt(OpenBracket, Comma, EndParenthesis))
			Object.TypePath = addtext(Object.TypePath, Take(1))

		if (Is(OpenBracket))
			SeekPosition++
			while (Isnt(EndBracket, EndParenthesis))
				// Get Param

				//world.log << "Get Param"

				if (Is(OpenBracket, Semicolon, Space))
					SeekAfter(OpenBracket, Semicolon, Space)

				var/Param = ""

				while(Isnt(Space, Equals))
					Param = addtext(Param, Take(1))

				//world.log << "Got ParamName [Param]"

				// Get Value
				SeekAfter(Space, Equals)

				Object.Params[Param] = GetValue()

				//world.log << "Got ParamValue [Object.Params[Param]]"

		SeekTo(Comma, EndParenthesis)

		//world.log << "Adding object {[Object.TypePath]} ([Object.Params.len] Params) to template [TemplateCode]"

		// Add object to template
		if (findtext(Object.TypePath, "/area") == 1)
			Template.Area = Object
		else if (findtext(Object.TypePath, "/turf") == 1)
			Template.Turfs += Object
		else
			Template.Objects += Object


		if (Is(Comma))
			SeekPosition++
			continue
		else if (Is(EndParenthesis))
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
					SeekPosition++
				if (SmallN)
					Value = addtext(Value, ascii2text(LineFeed))
					SeekPosition++
				if (R)
					Value = addtext(Value, ascii2text(CarriageReturn))
					SeekPosition++
				if (SmallR)
					Value = addtext(Value, ascii2text(CarriageReturn))
					SeekPosition++
				else
					Value = addtext(Value, Take(1))
			Escaped = FALSE
		else
			switch(Char())
				if(DoubleQuote)
					SeekPosition++
					if (InString)
						return Value
					InString = !InString
				if(SingleQuote)
					if (InString)
						Value = addtext(Value, Take(1))
					else
						InReference = !InReference
						if (!InReference)
							return fcopy_rsc(Value) // This is Wrong
					SeekPosition++

				if(Backslash)
					Escaped = TRUE
					SeekPosition++

				if(Semicolon, Space, EndBracket)
					if (InString)
						Value = addtext(Value, Take(1))
					else
						break
				else
					Value = addtext(Value, Take(1))

	return text2num(Value)

/datum/MapLoader/proc/ParseZLevel()
	//world.log << "Parse Map"
	SeekAfter(LineFeed)
	while (Isnt(DoubleQuote))
		MapHeight++
		var/list/Line = list( )
		while(Char() != LineFeed)
			var/A = Take(TileCharacterCount)
			Line += Templates[A]
		InsertList(1, TemplateMap, Line)
		//world.log << "Row, [Line.len]"
		MapWidth = max(MapWidth, Line.len)
		SeekAfter(LineFeed)
	//world.log << "Done Parse.  [TemplateMap.len] Rows ([JoinList(TemplateMap)])"




/datum/MapLoader/proc/CreateMap(var/turf/Loc = locate(1, 1, 1))
	ASSERT(Templates)
	ASSERT(TemplateMap)

	world.maxx = MapWidth
	world.maxy = MapHeight

	var/BaseX = Loc.x
	var/BaseY = Loc.y
	var/Z = Loc.z

	var/Y = 0
	var/X = 0

	for (var/list/Line in TemplateMap)
		X = 0
		for (var/datum/TileTemplate/Tile in Line)
			var/turf/NewTurf = locate(BaseX + X, BaseY + Y, Z)

			for (var/datum/ObjectTemplate/Turf in Tile.Turfs)
				NewTurf = new Turf.TypePath(NewTurf)
				for (var/Param in Turf.Params)
					NewTurf.vars[Param] = Turf.Params[Param]

			new Tile.Area.TypePath(NewTurf)
			for(var/atom/A in NewTurf)
				if (ismob(A) && A:client)
					continue
				if (A.loc == NewTurf)
					del A
			for(var/datum/ObjectTemplate/Object in Tile.Objects)
				var/atom/Atom = new Object.TypePath(locate(BaseX + X, BaseY + Y, Z))
				for (var/Param in Object.Params)
					Atom.vars[Param] = Object.Params[Param]
			X++
		Y++

	for(var/InitX = BaseX, InitX < BaseX + X, InitX++)
		for(var/InitY = BaseY, InitY < BaseY + Y, InitY++)
			var/turf/T = locate(InitX, InitY, Z)
			T.Init()

	for(var/mob/M in world)
		if (M.client)
			M.Respawn()

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
		ASSERT(SeekPosition < lentext(MapFile))

// Simple Seek-Forwards proc, but stops after a contiguous set of matches
/datum/MapLoader/proc/SeekAfter()
	SeekThrough(args)
	SeekPosition++

// Simple Seek-Forwards proc, but stops at the end of a contiguous set of matches
/datum/MapLoader/proc/SeekThrough()

	while (Isnt(Denest(args)))
		SeekPosition++
		ASSERT(SeekPosition < lentext(MapFile))

	do
		SeekPosition++
	while (Is(Denest(args)))

	SeekPosition--

// Exclusion list clause
/datum/MapLoader/proc/Isnt()
	return !Is(Denest(args))

// Inclusion list clause
/datum/MapLoader/proc/Is()
	return Char() in Denest(args)

/datum/MapLoader/proc/Denest(var/list/A)
	return IsList(A[1]) ? A[1] : A

// Gets the character currently seeked to
/datum/MapLoader/proc/Char()
	return text2ascii(MapFile, SeekPosition)

// Gets it as text
/datum/MapLoader/proc/TChar()
	return ascii2text(Char())

// Grabs the next three characters from the string as text and advances the seek pointer
/datum/MapLoader/proc/Take(var/Chars)
	ASSERT(SeekPosition <= lentext(MapFile))
	. = copytext(MapFile, SeekPosition, SeekPosition + Chars)
	SeekPosition += Chars