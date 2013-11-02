/MapLoader
	var
		MapWidth = 0
		MapHeight = 0
		TileCharacterCount = 0
		SeekPosition = 1
		StreamReader/Reader
		CurrentMap

		savefile/MapCache

		list
			Templates = list( )
			TemplateMap = list( )

/MapLoader/proc/Init()
	MapCache = new/savefile("MDATA")

/MapLoader/proc/LoadMap(var/MapID, var/Loc = locate(1, 1, 1))
	// Load a previously parsed map
	var/StartTime = world.timeofday
	var/datum/CachedMap/Map
	MapCache[MapID] >> Map

	Config.CurrentMapName = MapID

	Templates = Map.Templates
	TemplateMap = Map.TemplateMap

	MapHeight = Map.Height
	MapWidth = Map.Width

	CurrentMap = MapID

	CreateMap(Loc)
	return world.timeofday - StartTime

// Load a raw .dmm file, parse it, and create it.  Does not save the map to cache.
/MapLoader/proc/LoadRawMap(var/Filename)
	var/StartTime = world.timeofday
	ASSERT(fexists(Filename))
	Reader = new(Filename)
	Reader.StripCarriageReturns()
	ParseMap()
	CreateMap()

	Config.CurrentMapName = Filename
	return world.timeofday - StartTime

// Import a map file into the cache
/MapLoader/proc/ImportMap(var/Filename, var/MapID)
	ASSERT(fexists(Filename))
	Reader = new(Filename)
	Reader.StripCarriageReturns()
	MapCache[MapID + "-raw"] << Reader.TextFile
	del Reader

// Save a parsed map to cache
/MapLoader/proc/SaveMap(var/MapID)
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
/MapLoader/proc/DeleteRawMap(var/MapID)
	MapCache[MapID + "-raw"] << null

// Load an imported map for parsing
/MapLoader/proc/LoadImportedMap(var/MapID)
	var/T
	MapCache[MapID + "-raw"] >> T
	Reader = new(T)

// Parses a loaded map
/MapLoader/proc/ParseMap()
	set background = TRUE
	ASSERT(Reader)
	// Variable Init
	MapWidth = 0
	MapHeight = 0
	Templates = list( )
	TemplateMap = list( )

	// Parse for tile character count
	TileCharacterCount = Reader.Find("\"") + 1
	TileCharacterCount = Reader.Find("\"", TileCharacterCount) - TileCharacterCount

	// Parse template lines
	while (Reader.Char() == DoubleQuote)
		ParseTemplateLine()
		Reader.SeekTo(DoubleQuote, OpenParenthesis)

	// Parse Z Level
	ParseZLevel()

	// Done
	del Reader
	return



// Parses a template line
/MapLoader/proc/ParseTemplateLine()
	set background = TRUE
	// Parses the following data format into a template object
	// "aa" = (/obj/MapMarker/MapInfo/MapName{name = "Splatterhouse"; tag = "t"},/turf/Floor/Sand,/area)

	Reader.SeekAfter(DoubleQuote)

	var/datum/TileTemplate/Template = new()
	Templates[Reader.TakeUntil(DoubleQuote)] = Template

	Reader.SeekTo(ForwardSlash)

	while (Reader.Char() != EndParenthesis)
		var/datum/ObjectTemplate/Object = new()

		Object.TypePath = Reader.TakeUntil(OpenBracket, Comma, EndParenthesis)

		if (Reader.Is(OpenBracket))
			Reader.Advance()
			while (Reader.Isnt(EndBracket, EndParenthesis))
				// Get Param

				if (Reader.Is(OpenBracket, Semicolon, Space))
					Reader.SeekAfter(OpenBracket, Semicolon, Space)

				var/Param = Reader.TakeUntil(Space, Equals)

				// Get Value
				Reader.SeekAfter(Space, Equals)
				Object.Params[Param] = GetValue()

		Reader.SeekTo(Comma, EndParenthesis)

		// Add object to template
		if (findtext(Object.TypePath, "/area") == 1)
			Template.Area = Object
		else if (findtext(Object.TypePath, "/turf") == 1)
			Template.Turfs += Object
		else
			Template.Objects += Object

		if (Reader.Is(Comma))
			Reader.Advance()
			continue
		else if (Reader.Is(EndParenthesis))
			return


/MapLoader/proc/GetValue()
	set background = TRUE
	var/Value = ""
	var/InString = FALSE
	var/InReference = TRUE
	var/Escaped = FALSE

	while (InString || Reader.Isnt(Semicolon, EndParenthesis, Space))

		if (Escaped)
			switch(Reader.Char())
				if (N)
					Value = addtext(Value, ascii2text(LineFeed))
					Reader.Advance()
				if (SmallN)
					Value = addtext(Value, ascii2text(LineFeed))
					Reader.Advance()
				if (R)
					Value = addtext(Value, ascii2text(CarriageReturn))
					Reader.Advance()
				if (SmallR)
					Value = addtext(Value, ascii2text(CarriageReturn))
					Reader.Advance()
				else
					Value = addtext(Value, Reader.Take())
			Escaped = FALSE
		else
			switch(Reader.Char())
				if(DoubleQuote)
					Reader.Advance()
					if (InString)
						return Value
					InString = !InString
				if(SingleQuote)
					if (InString)
						Value = addtext(Value, Reader.Take())
					else
						InReference = !InReference
						if (!InReference)
							return fcopy_rsc(Value) // This is Wrong
					Reader.Advance()

				if(Backslash)
					Escaped = TRUE
					Reader.Advance()

				if(Semicolon, Space, EndBracket)
					if (InString)
						Value = addtext(Value, Reader.Take())
					else
						break
				else
					Value = addtext(Value, Reader.Take())

	return text2num(Value)

/MapLoader/proc/ParseZLevel()
	set background = TRUE
	Reader.SeekAfter(LineFeed)
	while (Reader.Isnt(DoubleQuote))
		MapHeight++
		var/list/Line = list( )
		while(Reader.Char() != LineFeed)
			var/A = Reader.Take(TileCharacterCount)
			Line += Templates[A]
		InsertList(1, TemplateMap, Line)
		MapWidth = max(MapWidth, Line.len)
		Reader.SeekAfter(LineFeed)

/MapLoader/proc/CreateMap(var/turf/Loc = locate(1, 1, 1))
	set background = TRUE
	ASSERT(Templates)
	ASSERT(TemplateMap)

	Config.SpawnZones = list(list( ), list( ), list( ), list( ))

	for(var/mob/M in world)
		if (M.client)
			M.loc = locate(1, 1, 1)

	world.maxx = MapWidth
	world.maxy = MapHeight

	var/BaseX = Loc.x
	var/BaseY = Loc.y
	var/Z = Loc.z

	var/Y = 0
	var/X = 0

	var/list/ProcessList = list( )

	for (var/list/Line in TemplateMap)
		X = 0
		for (var/datum/TileTemplate/Tile in Line)
			var/turf/NewTurf = locate(BaseX + X, BaseY + Y, Z)

			for (var/datum/ObjectTemplate/Turf in Tile.Turfs)
				var/OldTurf = NewTurf
				NewTurf = new Turf.TypePath(NewTurf)
				NewTurf.underlays += OldTurf

				for (var/Param in Turf.Params)
					NewTurf.vars[Param] = Turf.Params[Param]

			var/area/NewArea = new Tile.Area.TypePath(NewTurf)
			for (var/Param in Tile.Area.Params)
				NewArea.vars[Param] = Tile.Area.Params[Param]

			for(var/atom/movable/A in NewTurf)
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


	for(var/InitX = BaseX, InitX < (BaseX + X), InitX++)
		for(var/InitY = BaseY, InitY < (BaseY + Y), InitY++)
			var/turf/T = locate(InitX, InitY, Z)
			ProcessList += T.Init()

	// Process map data
	for (X = 1, X <= ProcessList.len, X++)
		var/atom/A = ProcessList[X]
		if (isturf(A))
			ProcessList += A:Propagate()
		else if (isobj(A))
			A:PostProcess()


	// Initialize data structures

	// Cameras
	Config.Cameras.Init()

	// Networks
	Config.NetController.Init()

	// Done
	for(var/mob/M in world)
		if (M.client)
			M.Respawn()

	// Events Data
	var/area/Event/A
	A.Triggered = list( ) // Triggered is a global (read: static / shared) var
	A = A // Suppress a compile warning.

	sleep(-1)