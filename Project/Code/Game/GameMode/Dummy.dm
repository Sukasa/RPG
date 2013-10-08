/datum/GameMode/Dummy
	Name = "Dummy"
	ModeKey = "DM"

/datum/GameMode/Dummy/Start()
	Config.NetController.Init()
	Config.Lang.Init()
	Config.MapLoader.Init()
	Config.Events.Init()
