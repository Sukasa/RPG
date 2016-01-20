ParticlePool
	var
		list/AllParticles = list()
		list/Brains = list()
		ListPtr = 1
		PoolSize = 256

ParticlePool/proc/Init()
	// Create Particles
	world << "INIT"
	for(var/X = 0; X <= PoolSize; X++)
		AllParticles += new /obj/Runtime/Particle()

	// Create brains
	for(var/Brain in (typesof(/ParticleBrain) - /ParticleBrain))
		Brains[Brain] = new Brain()

// Get the oldest [NumParticles] Particles from the pool
ParticlePool/proc/GetParticles(var/NumParticles)
	// Return all available particles if the request is too great
	if (NumParticles > AllParticles.len)
		return AllParticles

	if(NumParticles <= 0)
		return list()

	// Otherwise return the number of particles requested
	if (NumParticles + ListPtr > AllParticles.len)
		. = AllParticles.Copy(ListPtr, 0) + AllParticles.Copy(1, NumParticles - (AllParticles.len - ListPtr))
	else
		. = AllParticles.Copy(ListPtr, ListPtr + NumParticles)

	ListPtr += NumParticles
	if (ListPtr > AllParticles.len)
		ListPtr -= AllParticles.len

// Returns the oldest particle in the pool for use
ParticlePool/proc/GetParticle()
	. = AllParticles[ListPtr]
	ListPtr++
	if (ListPtr > AllParticles.len)
		ListPtr = 1