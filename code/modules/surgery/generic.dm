//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

datum/surgery_step/generic/
	can_infect = 1

datum/surgery_step/generic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == O_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.is_stump())
		return 0
	if (affected.robotic >= ORGAN_ROBOT)
		return 0
	return 1

///////////////////////////////////////////////////////////////
// Scalpel Surgery
///////////////////////////////////////////////////////////////

datum/surgery_step/generic/cut_open
	allowed_tools = list(
		/obj/item/surgical/scalpel = 100,
		/obj/item/surgical/scalpel_primitive = 80,
		/obj/item/material/knife = 75,
		/obj/item/material/shard = 50,
	)
	req_open = 0

	min_duration = 90
	max_duration = 110

datum/surgery_step/generic/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != O_MOUTH

datum/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the incision on [target]'s [affected.name] with \the [tool].", \
	"You start the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!", 40)
	..()

datum/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] has made an incision on [target]'s [affected.name] with \the [tool].</font>", \
	"<font color=#4F49AF>You have made an incision on [target]'s [affected.name] with \the [tool].</font>",)
	affected.open = 1

	if(istype(target) && target.should_have_organ(O_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.create_wound(CUT, 1)

datum/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</font>")
	affected.create_wound(CUT, 10)

///////////////////////////////////////////////////////////////
// Laser Scalpel Surgery
///////////////////////////////////////////////////////////////

datum/surgery_step/generic/cut_with_laser
	allowed_tools = list(
		/obj/item/surgical/scalpel/laser3 = 95, \
		/obj/item/surgical/scalpel/laser2 = 85, \
		/obj/item/surgical/scalpel/laser1 = 75, \
		/obj/item/melee/energy/sword = 5
	)
	priority = 2
	req_open = 0
	min_duration = 90
	max_duration = 110

datum/surgery_step/generic/cut_with_laser/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != O_MOUTH

datum/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!", 50)
	..()

datum/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool].</font>", \
	"<font color=#4F49AF>You have made a bloodless incision on [target]'s [affected.name] with \the [tool].</font>",)
	//Could be cleaner ...
	affected.open = 1

	affected.create_wound(CUT, 1)
	affected.organ_clamp()
	spread_germs_to_organ(affected, user)

datum/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</font>")
	affected.create_wound(CUT, 7.5)
	affected.create_wound(BURN, 12.5)

///////////////////////////////////////////////////////////////
// Incision Management Surgery
///////////////////////////////////////////////////////////////

datum/surgery_step/generic/incision_manager
	allowed_tools = list(
		/obj/item/surgical/scalpel/manager = 100,
	)

	priority = 2
	req_open = 0
	min_duration = 80
	max_duration = 120

datum/surgery_step/generic/incision_manager/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != O_MOUTH

datum/surgery_step/generic/incision_manager/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
	"You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!", 50)
	..()

datum/surgery_step/generic/incision_manager/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] has constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</font>", \
	"<font color=#4F49AF>You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</font>",)
	affected.open = 1

	if(istype(target) && target.should_have_organ(O_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.create_wound(CUT, 1)
	affected.organ_clamp()
	affected.open = 2

datum/surgery_step/generic/incision_manager/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</font>")
	affected.create_wound(CUT, 20)
	affected.create_wound(BURN, 15)

///////////////////////////////////////////////////////////////
// Hemostat Surgery
///////////////////////////////////////////////////////////////

datum/surgery_step/generic/clamp_bleeders
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/surgical/hemostat_primitive = 50,
		/obj/item/assembly/mousetrap = 20,
	)

	min_duration = 40
	max_duration = 60

datum/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && (affected.status & ORGAN_BLEEDING)

datum/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!", 40)
	..()

datum/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] clamps bleeders in [target]'s [affected.name] with \the [tool].</font>",	\
	"<font color=#4F49AF>You clamp bleeders in [target]'s [affected.name] with \the [tool].</font>")
	affected.organ_clamp()
	spread_germs_to_organ(affected, user)

datum/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</font>",	\
	"<font color='red'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</font>",)
	affected.create_wound(CUT, 10)

///////////////////////////////////////////////////////////////
// Retractor Surgery
///////////////////////////////////////////////////////////////

datum/surgery_step/generic/retract_skin
	allowed_tools = list(
		/obj/item/surgical/retractor = 100,
		/obj/item/surgical/retractor_primitive = 75,
		/obj/item/material/kitchen/utensil/fork = 50,
	)

	allowed_procs = list(IS_CROWBAR = 75)

	min_duration = 30
	max_duration = 40

datum/surgery_step/generic/retract_skin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 1 //&& !(affected.status & ORGAN_BLEEDING)

datum/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to pry open the incision on [target]'s [affected.name] with \the [tool]."
	if (target_zone == BP_TORSO)
		msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
	if (target_zone == BP_GROIN)
		msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!", 40)
	..()

datum/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<font color=#4F49AF>[user] keeps the incision open on [target]'s [affected.name] with \the [tool].</font>"
	var/self_msg = "<font color=#4F49AF>You keep the incision open on [target]'s [affected.name] with \the [tool].</font>"
	if (target_zone == BP_TORSO)
		msg = "<font color=#4F49AF>[user] keeps the ribcage open on [target]'s torso with \the [tool].</font>"
		self_msg = "<font color=#4F49AF>You keep the ribcage open on [target]'s torso with \the [tool].</font>"
	if (target_zone == BP_GROIN)
		msg = "<font color=#4F49AF>[user] keeps the incision open on [target]'s lower abdomen with \the [tool].</font>"
		self_msg = "<font color=#4F49AF>You keep the incision open on [target]'s lower abdomen with \the [tool].</font>"
	user.visible_message(msg, self_msg)
	affected.open = 2

datum/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<font color='red'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</font>"
	var/self_msg = "<font color='red'>Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</font>"
	if (target_zone == BP_TORSO)
		msg = "<font color='red'>[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!</font>"
		self_msg = "<font color='red'>Your hand slips, damaging several organs in [target]'s torso with \the [tool]!</font>"
	if (target_zone == BP_GROIN)
		msg = "<font color='red'>[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</font>"
		self_msg = "<font color='red'>Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</font>"
	user.visible_message(msg, self_msg)
	target.apply_damage(12, BRUTE, affected, sharp=1)

///////////////////////////////////////////////////////////////
// Cauterize Surgery
///////////////////////////////////////////////////////////////

datum/surgery_step/generic/cauterize
	allowed_tools = list(
		/obj/item/surgical/cautery = 100,
		/obj/item/clothing/mask/smokable/cigarette = 75,
		/obj/item/surgical/cautery_primitive = 70,
		/obj/item/flame/lighter = 50,
		/obj/item/weldingtool = 25,
	)

	min_duration = 70
	max_duration = 100

datum/surgery_step/generic/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && target_zone != O_MOUTH

datum/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to cauterize the incision on [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to cauterize the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Your [affected.name] is being burned!", 40)
	..()

datum/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] cauterizes the incision on [target]'s [affected.name] with \the [tool].</font>", \
	"<font color=#4F49AF>You cauterize the incision on [target]'s [affected.name] with \the [tool].</font>")
	affected.open = 0
	affected.germ_level = 0
	affected.status &= ~ORGAN_BLEEDING

datum/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</font>")
	target.apply_damage(3, BURN, affected)

///////////////////////////////////////////////////////////////
// Amputation Surgery
///////////////////////////////////////////////////////////////

datum/surgery_step/generic/amputate
	allowed_tools = list(
		/obj/item/surgical/circular_saw = 100,
		/obj/item/material/knife/machete/hatchet = 75,
		/obj/item/surgical/saw_primitive = 60,
	)
	req_open = 0

	min_duration = 110
	max_duration = 160

datum/surgery_step/generic/amputate/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (target_zone == O_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	return !affected.cannot_amputate

datum/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to amputate [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool].")
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!", 100)
	..()

datum/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool].</font>", \
	"<font color=#4F49AF>You amputate [target]'s [affected.name] with \the [tool].</font>")
	affected.droplimb(1,DROPLIMB_EDGE)

datum/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!</font>")
	affected.create_wound(CUT, 30)
	affected.fracture()
