/SoundController
	var/list/Ambiences
	var/sound/BGMTrack
	var/CurrentBGM
	var/Environment = EnvironmentGeneric
	var/GameVolume
	var/MusicVolume

/SoundController/proc/Init()
	// Init vars

/SoundController/proc/SetEnvironment(var/NewEnvironment)

/SoundController/proc/SetBGM(var/NewTrackName, var/Async = FALSE, var/FadeTime = 1)
	if (NewTrackName == CurrentBGM) // Setting the BGM to itself will do nothing.
		return

	if (Async)
		spawn
			SetBGM(NewTrackName, FALSE, FadeTime)
		return





/SoundController/proc/StopBGM()

/SoundController/proc/StartBGM()

/SoundController/proc/CreateSound(var/SoundName)
	// See if the sound has been instantiated and cached

	// If so, return it

	// Get SoundDef from list

	// Instantiate SoundEffect

	// And return

/SoundController/proc/PlaySoundEffect(var/atom/Source, var/SoundEffect/Sound)

/SoundController/proc/StopSoundEffect(var/atom/Source, var/SoundEffect/Sound)
