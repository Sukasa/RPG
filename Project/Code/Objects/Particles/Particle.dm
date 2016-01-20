// Particle system entities.  Spawned by an emitter and run

obj/Runtime/Particle
	var
		Age = 0
		Lifetime = 120
		ParticleBrain/Brain
		Effects = EffectsNone
		ExtraData = null

	density = 0
	opacity = 0
	mouse_opacity = 0
	icon = 'Particles.dmi'

obj/Runtime/Particle/proc/Instantiate(var/ParticleBrain/NewBrain)
	Ticker.HighSpeedDevices += src
	Age = 0

	alpha = AlphaOpaque
	color = ColorWhite
	transform = null
	invisibility = Visible
	luminosity = 0
	layer = StructureLayer
	opacity = 0
	Effects = EffectsNone
	ExtraData = null
	density = 0

	Brain = NewBrain
	Brain.Init(src)
	BaseLayer = layer

obj/Runtime/Particle/proc/Die()
	Ticker.HighSpeedDevices -= src
	loc = null

obj/Runtime/Particle/FastTick()
	..()
	Age++
	if (Age >= Lifetime)
		Die()
	else
		Brain.Think(src)
	if (Destination)
		MoveTo()