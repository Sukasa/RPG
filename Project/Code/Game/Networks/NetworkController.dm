/NetworkController/
	var/list/Networks = list( )

/NetworkController/proc/Init()
	Networks = list( )
	for (var/obj/MapMarker/Network/Piece in world)
		Piece.Network = null
	var/Piece = GetNextEmptyNetworkPiece()
	while(Piece)
		CreateNetwork(Piece)
		Piece = GetNextEmptyNetworkPiece()

/NetworkController/proc/DeleteNetwork(var/datum/Network/Network)
	for (var/obj/MapMarker/Network/Part in Network.Cables)
		Part.Network = null
	for (var/obj/Machinery/Machine in Network.Devices)
		Machine.Networks -= Network
	Networks.Remove(Network)

/NetworkController/proc/RegisterDevices(var/datum/Network/Network)
	for (var/obj/Machinery/Machine in Network.Devices)
		Machine.Networks += Network

/NetworkController/proc/CreateNetwork(var/obj/MapMarker/Network/StartElement)
	var/datum/Network/NewNetwork = new()
	NewNetwork.Cables = list(StartElement)
	NewNetwork.Type = StartElement.type
	for (var/Index = 1, Index <= NewNetwork.Cables.len, Index++)
		var/obj/MapMarker/Network/Element = NewNetwork.Cables[Index]
		NewNetwork.Cables |= GetConnectedCables(Element)
		NewNetwork.Devices |= GetConnectedMachines(Element)
		Element.Network = NewNetwork
	Networks.Add(NewNetwork)
	RegisterDevices(NewNetwork)

/NetworkController/proc/Split(var/obj/MapMarker/Network/RemoveElement)
	DeleteNetwork(RemoveElement.Network)
	var/list/Parts = GetConnectedCables(RemoveElement)
	RemoveElement.Dirs = 0
	for (var/obj/MapMarker/Network/Part in Parts)
		if (!Part.Network)
			CreateNetwork(Part)

/NetworkController/proc/Join(var/obj/MapMarker/Network/AddElement)
	var/list/Parts = GetConnectedCables(AddElement)
	var/datum/Network/NewNetwork = new()
	for(var/obj/MapMarker/Network/Part in Parts)
		if (!Part.Network)
			continue
		NewNetwork.Cables |= Part.Network.Cables
		DeleteNetwork(Part.Network)
	for(var/obj/MapMarker/Network/Part in NewNetwork.Cables)
		Part.Network = NewNetwork
		NewNetwork.Devices |= GetConnectedMachines(Part)
	Networks.Add(NewNetwork)
	RegisterDevices(NewNetwork)

/NetworkController/proc/GetConnectedCables(var/obj/MapMarker/Network/SourceElement)
	var/list/Elements = list( )
	for(var/Dir in Cardinal)
		if (text2num(SourceElement.icon_state) & Dir)
			var/turf/Container = get_step(SourceElement, Dir)
			for (var/obj/MapMarker/Network/Element in Container)
				if (Element.type == SourceElement.type && (text2num(Element.icon_state) & Reverse(Dir)))
					Elements += Element
	return Elements

/NetworkController/proc/GetConnectedMachines(var/obj/MapMarker/Network/SourceElement)
	var/list/Machines = list( )
	for(var/Dir in Cardinal)
		if (text2num(SourceElement.icon_state) & Dir)
			var/turf/Container = get_step(SourceElement, Dir)
			for (var/obj/Machinery/Machine in Container)
				Machines += Machine
	return Machines

/NetworkController/proc/GetNextEmptyNetworkPiece()
	for (var/obj/MapMarker/Network/Piece in world)
		if (!Piece.Network)
			return Piece

/NetworkController/proc/Tick()
	for(var/datum/Network/Network in Networks)
		Network.Tick()