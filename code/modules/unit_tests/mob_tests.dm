/datum/unit_test/space_suffocation
	var/startOxyloss
	var/endOxyloss
	var/mob/living/complex/human/H

/datum/unit_test/space_suffocation/Run()
	var/turf/space/T = locate()

	H = allocate(/mob/living/complex/human, T)
	startOxyloss = H.getOxyLoss()
	sleep(10 SECONDS)
	endOxyloss = H.getOxyLoss()

	if(startOxyloss >= endOxyloss)
		Fail("Human mob is not taking oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")
