/SoundEffect
	var
		SoundDef/Definition
		list/AmbienceEmitters = list( )
		atom/PositionRef

		Volume = 100
		LastStatus = -1
		sound/Sound
		Paused
		Stopped
		Rewind
		ExclusiveMode

		FadeStart
		FadeTime
		FadeTo
		FadeFrom
		FadeDone

		X
		Y


/SoundEffect/New(var/SoundDef/Def, var/atom/PositionRef)
	Definition = Def
	Paused = FALSE

	Sound = sound(Definition.SoundFile)
	Sound.environment = Definition.Environment || Config.Audio.Environment
	Sound.falloff = Definition.Falloff
	Sound.repeat = Definition.Repeat
	Sound.frequency = Definition.Frequency


/SoundEffect/Del()
	Sound.status = SOUND_UPDATE | SOUND_PAUSED
	world << Sound
	..()


/SoundEffect/proc/SetFade(var/Time, NewVolume)
	FadeTime = Time
	FadeTo = NewVolume
	FadeFrom = Volume

/SoundEffect/proc/TickFade()
	if (!Sound)
		ErrorText("Fade on unintialized sound effect")
		FadeDone = TRUE
		return
	if (!FadeDone)
		Sound.status = Paused ? SOUND_UPDATE | SOUND_PAUSED : SOUND_UPDATE
		Sound.volume = lerp(FadeFrom, FadeTo, (world.time - FadeStart) / FadeTime) * (Config.SFXVolume / MaxVolume) * Volume * Definition.VolumeMultiplier
		world << Sound

		FadeDone = (world.time - FadeStart) >= FadeTime


/SoundEffect/proc/Tick()
	// Tick the sound effect to handle pan/falloff/etc

	Sound.volume = (Config.SFXVolume / MaxVolume) * Volume * Definition.VolumeMultiplier

	if (Stopped)
		if (Paused)
			Sound.status = SOUND_UPDATE | SOUND_PAUSED
		else
			Sound.status = 0
			Stopped = FALSE
	else
		if (Paused)
			Sound.status = SOUND_UPDATE | SOUND_PAUSED
		else
			Sound.status = SOUND_UPDATE

	if ((Definition.SoundType & SoundModeNo3D))
		if (Sound.status != LastStatus)
			world << Sound
			LastStatus = Sound.status
	else
		X = PositionRef.x
		Y = PositionRef.y
		for(var/client/Client in Config.Clients)
			var/mob/Microphone = Client.eye
			if (Definition.SoundType & SoundTypeAmbience)
				var/atom/Emitter = Microphone.Closest(AmbienceEmitters)
				X = Emitter.x
				Y = Emitter.y

			Sound.x = X - Microphone.x
			Sound.y = Y - Microphone.y

			Client << Sound


/SoundEffect/proc/Pause(var/Emitter)
	if (!ExclusiveMode)
		return

	Paused = !Paused


/SoundEffect/proc/Stop()
	if (!ExclusiveMode)
		return

	Stopped = TRUE
	Paused = TRUE


/SoundEffect/proc/Play(var/Emitter)
	if (Config.Audio.IsChannelAllocated(Sound.channel) && !(Definition.SoundType & SoundTypeAmbience))
		Config.Audio.PreserveChannelAllocation(src)
	else if (!Config.Audio.IsChannelAllocated(Sound.channel))
		Sound.channel = Config.Audio.AllocateChannel(src)

	if (Emitter && (Definition.SoundType & SoundTypeAmbience))
		AmbienceEmitters |= Emitter
	else if (Emitter && ExclusiveMode)
		PositionRef = Emitter

	Paused = FALSE