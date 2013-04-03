/datum/NetworkController/
	var/list/Networks = list( )
	var/LastNetNum = 0

/datum/NetworkController/proc/Init()
	Networks = list( )
	LastNetNum = 0
	for (var/obj/MapMarker/Network/Piece in world)
		Piece.NetNum = 0
	var/Piece = GetNextEmptyNetworkPiece()
	while(Piece)
		FloodFillNetwork(Piece)
		Piece = GetNextEmptyNetworkPiece()

/datum/NetworkController/proc/FloodFillNetwork(var/obj/MapMarker/Network/StartElement)
	LastNetNum++
	var/list/Components = list(StartElement)
	for (var/Index = 1, Index <= Components.len, Index++)
		var/obj/MapMarker/Network/Element = Components[Index]
		Components |= GetConnectedElements(Element)
		Element.NetNum = LastNetNum
	Networks.Add(list(Components))

/datum/NetworkController/proc/Split(var/obj/MapMarker/Network/RemoveElement)
	var/list/Parts = GetConnectedElements(RemoveElement)
	Networks[RemoveElement.NetNum] = null
	RemoveElement.Dirs = 0
	for (var/obj/MapMarker/Network/Part in Parts)
		if (!Part.NetNum)
			FloodFillNetwork(Part)

/datum/NetworkController/proc/Join(var/obj/MapMarker/Network/AddElement)
	var/list/Parts = GetConnectedElements(AddElement)
	var/list/NewNetwork = list()
	for(var/obj/MapMarker/Network/Part in Parts)
		if (!Networks[Part.NetNum])
			continue
		NewNetwork |= Networks[Part.NetNum]
		Networks[Part.NetNum] = null
	LastNetNum++
	for(var/obj/MapMarker/Network/Part in NewNetwork)
		Part.NetNum = LastNetNum
	Networks.Add(list(NewNetwork))

/datum/NetworkController/proc/GetConnectedElements(var/obj/MapMarker/Network/SourceElement)
	var/list/Elements = list()
	for(var/Dir in Cardinal)
		if (SourceElement.Dirs & Dir)
			var/turf/Container = get_step(SourceElement, Dir)
			for (var/obj/MapMarker/Network/Element in Container)
				if (Element.type == SourceElement.type && (Element.Dirs & Reverse(Dir)))
					Elements += Element
	return Elements

/datum/NetworkController/proc/GetNextEmptyNetworkPiece()
	for (var/obj/MapMarker/Network/Piece in world)
		if (!Piece.NetNum)
			return Piece