proc/ScriptCreateCamera(var/Name, var/Location)
	return Config.Cameras.CreateCinematicCamera(Location, Name)

proc/ScriptGetCamera(var/Name)
	return Config.Cameras.CinematicCameras[Name]