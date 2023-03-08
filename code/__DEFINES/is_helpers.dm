// simple is_type and similar inline helpers

#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

#define isatom(A) (isloc(A))

#define isdatum(D) (istype(D, /datum))

#define isweakref(D) (istype(D, /datum/weakref))

//Datums

#define isTaurTail(A)	istype(A, /datum/sprite_accessory/tail/taur)

//Turfs

#define isfloorturf(A) (istype(A, /turf/simulated/floor))

#define isopenturf(A) istype(A, /turf/simulated/open)

#define isspaceturf(A) istype(A, /turf/space)

#define ismineralturf(A) istype(A, /turf/simulated/mineral)

//Objs
///override the byond proc because it returns true on children of /atom/movable that aren't objs
#define isobj(A) istype(A, /obj)
#define isitem(A) (istype(A, /obj/item))

#define isclothing(A) (istype(A, /obj/item/clothing))

#define isstorage(A)	istype(A, /obj/item/storage)

#define isstructure(A) (istype(A, /obj/structure))

#define ismachinery(A) (istype(A, /obj/machinery))

#define ismecha(A) (istype(A, /obj/mecha))

#define isvehicle(A) (istype(A, /obj/vehicle_old) || istype(A, /obj/vehicle) || istype(A, /obj/mecha))

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isbelly(A) istype(A, /obj/belly)

#define is_reagent_container(O) (istype(O, /obj/item/reagent_containers))

//Areas

//Mobs

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isalien(A) istype(A, /mob/living/complex/alien)

#define isanimal(A) istype(A, /mob/living/simple)

#define isbrain(A) istype(A, /mob/living/complex/brain)

#define iscomplexmob(A) istype(A, /mob/living/complex)

#define iscorgi(A) istype(A, /mob/living/simple/animal/passive/dog/corgi)

#define isDrone(A) istype(A, /mob/living/silicon/robot/drone)

#define isEye(A) istype(A, /mob/observer/eye)

#define ishuman(A) istype(A, /mob/living/complex/human)

#define isliving(A) istype(A, /mob/living)

#define isMatriarchDrone(A) istype(A, /mob/living/silicon/robot/drone/construction/matriarch)

#define ismouse(A) istype(A, /mob/living/simple/animal/passive/mouse/)

#define isnewplayer(A) istype(A, /mob/new_player)

#define isobserver(A) istype(A, /mob/observer/dead)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isvoice(A) istype(A, /mob/living/voice)

#define isslime(A) istype(A, /mob/living/simple/slime)

#define isbot(A) istype(A, /mob/living/bot)

#define isxeno(A) istype(A, /mob/living/simple/xeno)

#define issimple(A) istype(A, /mob/living/simple)

/proc/is_species_type(atom/A, path)
	if(!istype(A, /mob/living/complex/human))
		return FALSE
	var/mob/living/complex/human/H = A
	return istype(H.species, path)

#define fast_is_species_type(H, path)	istype(H.species, path)
