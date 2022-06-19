/proc/gibs(atom/location, datum/dna/MobDNA, gibber_type = /obj/effect/gibspawner/generic, fleshcolor, bloodcolor)
	new gibber_type(location,MobDNA,fleshcolor,bloodcolor)

/obj/effect/gibspawner
	var/sparks = FALSE //whether sparks spread on Gib()
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.

/obj/effect/gibspawner/Initialize(mapload, location, datum/dna/MobDNA, fleshcolor, bloodcolor)
	. = ..()

	if(fleshcolor)
		src.fleshcolor = fleshcolor
	if(bloodcolor)
		src.bloodcolor = bloodcolor
	Gib(loc,MobDNA)

/obj/effect/gibspawner/proc/Gib(atom/location, datum/dna/MobDNA = null)
	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		to_chat(world, SPAN_WARNING("Gib list length mismatch!"))
		return

	var/obj/effect/decal/cleanable/blood/gibs/gib = null

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
		s.set_up(2, 1, get_turf(location)) // Not sure if it's safe to pass an arbitrary object to set_up, todo
		s.start()

	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(location)

				// Apply human species colouration to masks.
				if(fleshcolor)
					gib.fleshcolor = fleshcolor
				if(bloodcolor)
					gib.basecolor = bloodcolor

				gib.update_icon()

				gib.blood_DNA = list()
				if(MobDNA)
					gib.blood_DNA[MobDNA.unique_enzymes] = MobDNA.b_type
				else if(istype(src, /obj/effect/gibspawner/human)) // Probably a monkey
					gib.blood_DNA["Non-human DNA"] = "A+"
				if(istype(location,/turf/))
					var/list/directions = gibdirections[i]
					if(directions.len)
						gib.streak(directions)

	qdel(src)
