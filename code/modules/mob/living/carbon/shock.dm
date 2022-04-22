/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

///Proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if(!can_feel_pain())
		src.traumatic_shock = 0
		return 0

	src.traumatic_shock =			\
	1	* src.getOxyLoss() +		\
	0.7	* src.getToxLoss() +		\
	1.2	* src.getShockFireLoss() +	\
	1.2	* src.getShockBruteLoss() +	\
	1.7	* src.getCloneLoss() +		\
	2	* src.getHalLoss() +		\
	-1	* src.chem_effects[CE_PAINKILLER]

	if(src.slurring)
		src.traumatic_shock -= 20
	traumatic_shock = max(0, traumatic_shock)

	// broken or ripped off organs will add quite a bit of pain
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = src
		for(var/obj/item/organ/external/organ in M.organs)
			if(organ.is_broken() || organ.open)
				src.traumatic_shock += 30
			else if(organ.is_dislocated())
				src.traumatic_shock += 15

	if(src.traumatic_shock < 0)
		src.traumatic_shock = 0

	return src.traumatic_shock


/mob/living/carbon/human/updateshock()
	if(!can_feel_pain())
		traumatic_shock = 0
		return 0

	traumatic_shock = getOxyLoss()
	traumatic_shock += (0.7 * getToxLoss())

	for(var/obj/item/organ/external/E in organs)

		traumatic_shock += (1.5 * E.get_burn_damage())
		traumatic_shock += (1.2 * E.get_brute_damage())
		traumatic_shock += (1.7 * E.get_genetic_damage())
		traumatic_shock += (  2 * E.get_pain())

		if(E.is_broken())
			traumatic_shock += 20
		else if(E.is_dislocated())
			traumatic_shock += 10

	traumatic_shock += (-1*src.chem_effects[CE_PAINKILLER])

	if(slurring)
		traumatic_shock -= 20

	traumatic_shock = max(0,traumatic_shock)
	return traumatic_shock

/mob/living/carbon/proc/handle_shock()
	updateshock()
