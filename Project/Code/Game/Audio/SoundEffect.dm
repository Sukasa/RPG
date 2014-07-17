/SoundEffect
	var
		mob/Owner
		Volume = 100
		SoundDef/Definition
		sound/Sound
		Paused
		Stopped
		ExclusiveMode
		list/AmbienceEmitters = list( )

		FadeStart
		FadeTime
		FadeTo
		FadeFrom
		FadeDone
		X
		Y
		Z


/SoundEffect/New(var/SoundDef/Def, var/mob/Attach, var/atom/PositionRef)
	Definition = Def
	Paused = FALSE
	Owner = Attach

	Sound = sound(Definition.SoundFile)
	Sound.environment = Definition.Environment || Config.Audio.Environment
	Sound.falloff = Definition.Falloff
	Sound.repeat = Definition.Repeat
	Sound.frequency = Definition.Frequency

	X = PositionRef.x
	Y = PositionRef.y

	if (Owner && !(Definition.SoundType & SoundModeNo3D))
		Sound.z = 1
		Sound.x = X - Owner.x
		Sound.y = Y - Owner.y


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
		Sound.volume = lerp(FadeFrom, FadeTo, (world.time - FadeStart) / FadeTime) * (Config.Audio.GameVolume / 15) * Volume * Definition.VolumeMultiplier
		world << Sound

		FadeDone = (world.time - FadeStart) >= FadeTime


/SoundEffect/proc/Tick()
	// Tick the sound effect to handle pan/falloff/etc

	if ((Definition.SoundType & SoundModeNo3D))
		return

	Sound.x = X - Owner.x
	Sound.y = Y - Owner.y

	Sound.status = Paused ? SOUND_UPDATE | SOUND_PAUSED : SOUND_UPDATE
	world << Sound


/SoundEffect/proc/Pause(var/Emitter)
	if (!ExclusiveMode)
		return
	Sound.status |= SOUND_UPDATE
	Sound.status ^= SOUND_PAUSED
	world << Sound
	Paused = !Paused


/SoundEffect/proc/Stop()
	if (!ExclusiveMode)
		return
	Sound.status |= SOUND_UPDATE | SOUND_PAUSED
	world << Sound
	Stopped = TRUE


/SoundEffect/proc/Play(var/Emitter)
	if (!ExclusiveMode || Stopped)
		Sound.status = 0
		Sound.volume = Config.Audio.GameVolume * Volume * Definition.VolumeMultiplier
		world << Sound
	else if (Emitter && (Definition.SoundType & SoundTypeAmbience))
		AmbienceEmitters += Emitter
	Paused = FALSE