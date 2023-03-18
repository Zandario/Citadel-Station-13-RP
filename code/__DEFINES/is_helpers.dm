/**
 * Simple is_type and similar inline helpers.
 */

/**
 *# Misc
 */

#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

#define isclient(CLIENT) (istype(CLIENT, /client))

#define isicon(ICON)   (istype(ICON, /icon))

#define isimage(IMG)  (istype(IMG, /image))


/**
 *# Datums
 */

#define isdatum(THING)    (istype(THING, /datum))

#define isTaurTail(DATUM) (istype(DATUM, /datum/sprite_accessory/tail/taur))

#define isweakref(DATUM)  (istype(DATUM, /datum/weakref))


/**
 *# Atoms
 */

#define isatom(ATOM) (isloc(ATOM))


/**
 *# Areas
 */


/**
 *# Turfs
 */

#define issimulatedturf(TURF) (istype(TURF, /turf/simulated))
#define isfloorturf(TURF)     (istype(TURF, /turf/simulated/floor))
#define ismineralturf(TURF)   (istype(TURF, /turf/simulated/mineral))
#define isopenturf(TURF)      (istype(TURF, /turf/simulated/open))

#define isspaceturf(TURF)     (istype(TURF, /turf/space))


/**
 *# Objs
 */

/// Override the byond proc because it returns true on children of /atom/movable that aren't objs.
#define isobj(OBJ)       (istype(OBJ, /obj))

#define isbelly(OBJ)     (istype(OBJ, /obj/belly))

#define isitem(OBJ)      (istype(OBJ, /obj/item))
#define isclothing(OBJ)  (istype(OBJ, /obj/item/clothing))
#define isstorage(OBJ)   (istype(OBJ, /obj/item/storage))

#define is_reagent_container(OBJ) (istype(OBJ, /obj/item/reagent_containers))

#define isorgan(OBJ)         (istype(OBJ, /obj/item/organ))
#define isexternalorgan(OBJ) (istype(OBJ, /obj/item/organ/external))

#define ismachinery(OBJ) (istype(OBJ, /obj/machinery))
#define isdoor(OBJ)      (istype(OBJ, /obj/machinery/door))
#define isairlock(OBJ)   (istype(OBJ, /obj/machinery/door/airlock))

#define ismecha(OBJ)     (istype(OBJ, /obj/mecha))

#define isstructure(OBJ) (istype(OBJ, /obj/structure))

GLOBAL_LIST_INIT(vechicle_typepaths, typecacheof(list(
	/obj/vehicle_old,
	/obj/vehicle,
	/obj/mecha,
)))

#define isvehicle(OBJ) (is_type_in_typecache(OBJ, GLOB.vechicle_typepaths))



/**
 *# Mobs
 */

#define isliving(MOB) (istype(MOB, /mob/living))

#define isbot(MOB)    (istype(MOB, /mob/living/bot))

#define iscarbon(MOB) (istype(MOB, /mob/living/carbon))
#define isalien(MOB)  (istype(MOB, /mob/living/carbon/alien))
#define isbrain(MOB)  (istype(MOB, /mob/living/carbon/brain))
#define ishuman(MOB)  (istype(MOB, /mob/living/carbon/human))

#define issilicon(MOB) (istype(MOB, /mob/living/silicon))
#define isAI(MOB)      (istype(MOB, /mob/living/silicon/ai))
#define ispAI(MOB)     (istype(MOB, /mob/living/silicon/pai))
#define isrobot(MOB)   (istype(MOB, /mob/living/silicon/robot))
#define isDrone(MOB)   (istype(MOB, /mob/living/silicon/robot/drone))
#define isMatriarchDrone(MOB) (istype(MOB, /mob/living/silicon/robot/drone/construction/matriarch))

#define isanimal(MOB) (istype(MOB, /mob/living/simple_animal))

#define issimple(MOB) (istype(MOB, /mob/living/simple_mob))
#define isxeno(MOB)   (istype(MOB, /mob/living/simple_mob/xeno))
#define isslime(MOB)  (istype(MOB, /mob/living/simple_mob/slime))
#define ismouse(MOB)  (istype(MOB, /mob/living/simple_mob/animal/passive/mouse))
#define iscorgi(MOB)  (istype(MOB, /mob/living/simple_mob/animal/passive/dog/corgi))

#define isnewplayer(MOB) (istype(MOB, /mob/new_player))

#define isobserver(MOB) (istype(MOB, /mob/observer/dead))
#define isEye(MOB)      (istype(MOB, /mob/observer/eye))

#define isvoice(MOB) (istype(MOB, /mob/living/voice))

/proc/is_species_type(atom/A, path)
	if(!ishuman(A))
		return FALSE
	var/mob/living/carbon/human/H = A
	return istype(H.species, path)

#define fast_is_species_type(H, path) (istype(H.species, path))
