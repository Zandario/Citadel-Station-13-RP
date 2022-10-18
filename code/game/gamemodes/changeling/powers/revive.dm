//Revive from revival stasis
/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	var/datum/changeling/changeling = changeling_power(0,0,100,DEAD)
	if(!changeling)
		return 0

	if(changeling.max_geneticpoints < 0) //Absorbed by another ling
		to_chat(src, "<span class='danger'>You have no genomes, not even your own, and cannot revive.</span>")
		return 0

	if(src.stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src
	var/mob/living/carbon/C = src

	C.tod = null
	C.setToxLoss(0)
	C.setOxyLoss(0)
	C.setCloneLoss(0)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.radiation = 0
	C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
	C.reagents.clear_reagents()
	if(ishuman(C))
		var/mob/living/carbon/human/H = src
		H.species.create_organs(H)
		H.restore_all_organs(ignore_prosthetic_prefs=1) //Covers things like fractures and other things not covered by the above.
		H.restore_blood()
		H.mutations.Remove(MUTATION_HUSK)
		H.status_flags &= ~DISFIGURED
		H.update_icons_body()
		for(var/limb in H.organs_by_name)
			var/obj/item/organ/external/current_limb = H.organs_by_name[limb]
			if(current_limb)
				current_limb.relocate()
				current_limb.open = 0

		H.update_hud_med_all()

		H.handcuffed?.forceMove(drop_location())
		H.legcuffed?.forceMove(drop_location())
		if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
			H.wear_suit.forceMove(drop_location())

	C.halloss = 0
	C.shock_stage = 0 //Pain
	to_chat(C, "<span class='notice'>We have regenerated.</span>")
	C.update_canmove()
	C.mind.changeling.purchased_powers -= C
	feedback_add_details("changeling_powers","CR")
	C.set_stat(CONSCIOUS)
	C.forbid_seeing_deadchat = FALSE
	C.timeofdeath = null
	src.verbs -= /mob/proc/changeling_revive
	// re-add our changeling powers
	C.make_changeling()



	return 1
