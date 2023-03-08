//todo
/datum/artifact_effect/sleepy
	name = "sleepy"

/datum/artifact_effect/sleepy/New()
	..()
	effect_type = pick(EFFECT_PSIONIC, EFFECT_ORGANIC)

/datum/artifact_effect/sleepy/DoEffectTouch(var/mob/toucher)
	if(toucher)
		var/weakness = GetAnomalySusceptibility(toucher)
		if(ishuman(toucher) && prob(weakness * 100))
			var/mob/living/complex/human/H = toucher
			to_chat(H,pick("<font color=#4F49AF>You feel like taking a nap.</font>","<font color=#4F49AF> You feel a yawn coming on.</font>","<font color=#4F49AF> You feel a little tired.</font>"))
			H.drowsyness = min(H.drowsyness + rand(5,25) * weakness, 50 * weakness)
			H.eye_blurry = min(H.eye_blurry + rand(1,3) * weakness, 50 * weakness)
			return 1
		else if(isrobot(toucher))
			to_chat(toucher, "<font color='red'>SYSTEM ALERT: CPU cycles slowing down.</font>")
			return 1

/datum/artifact_effect/sleepy/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/complex/human/H in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(H, pick("<font color=#4F49AF>You feel like taking a nap.</font>","<font color=#4F49AF> You feel a yawn coming on.</font>","<font color=#4F49AF> You feel a little tired.</font>"))
				H.drowsyness = min(H.drowsyness + 1 * weakness, 25 * weakness)
				H.eye_blurry = min(H.eye_blurry + 1 * weakness, 25 * weakness)
		for (var/mob/living/silicon/robot/R in range(src.effectrange,holder))
			to_chat(R, "<font color='red'>SYSTEM ALERT: CPU cycles slowing down.</font>")
		return 1

/datum/artifact_effect/sleepy/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/complex/human/H in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				to_chat(H, pick("<font color=#4F49AF>You feel like taking a nap.</font>","<font color=#4F49AF> You feel a yawn coming on.</font>","<font color=#4F49AF> You feel a little tired.</font>"))
				H.drowsyness = min(H.drowsyness + rand(5,15) * weakness, 50 * weakness)
				H.eye_blurry = min(H.eye_blurry + rand(5,15) * weakness, 50 * weakness)
		for (var/mob/living/silicon/robot/R in range(src.effectrange,holder))
			to_chat(R, "<font color='red'>SYSTEM ALERT: CPU cycles slowing down.</font>")
		return 1
