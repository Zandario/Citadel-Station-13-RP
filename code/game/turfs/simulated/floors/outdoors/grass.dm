/turf/simulated/floor/outdoors/grass
	name = "grass"
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass0"
	base_icon_state = "grass"
	baseturfs = /turf/simulated/floor/outdoors/dirt
	layer = HIGH_TURF_LAYER

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_EXTERIOR_GRASS)
	can_smooth_with = (SMOOTH_GROUP_EXTERIOR_GRASS + SMOOTH_GROUP_CLOSED_TURFS)

	var/grass_chance = 20

	var/list/grass_types = list(
		/obj/structure/flora/ausbushes/sparsegrass,
		/obj/structure/flora/ausbushes/fullgrass,
	)

	damaged_dmi = 'icons/turf/flooring/grass.dmi'
	var/smooth_icon = 'icons/turf/flooring/grass.dmi'

/turf/simulated/floor/outdoors/grass/Initialize(mapload)
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-9, -9)
		transform = translation
		icon = smooth_icon

	if(grass_chance && prob(grass_chance) && !check_density())
		var/grass_type = pickweight(grass_types)
		new grass_type(src)

/turf/simulated/floor/outdoors/grass/break_tile()
	. = ..()
	icon_state = "damaged"

/datum/category_item/catalogue/flora/sif_grass
	name = "Sivian Flora - Moss"
	desc = "A natural moss that has adapted to the sheer cold climate of Sif. \
	The moss came to rely partially on bioluminescent bacteria provided by the local tree populations. \
	As such, the moss often grows in large clusters in the denser forests of Sif. \
	The moss has evolved into it's distinctive blue hue thanks to it's reliance on bacteria that has a similar color."
	value = CATALOGUER_REWARD_TRIVIAL

/turf/simulated/floor/outdoors/grass/sif
	name = "growth"
	icon_state = "fairygrass0"
	smoothing_flags = NONE
	// initial_flooring = /singleton/flooring/outdoors/grass/sif
	grass_chance = 5
	var/tree_chance = 2

	grass_types = list(
		/obj/structure/flora/sif/eyes = 1,
		/obj/structure/flora/sif/tendrils = 10
		)

	catalogue_data = list(/datum/category_item/catalogue/flora/sif_grass)
	catalogue_delay = 2 SECONDS

/turf/simulated/floor/outdoors/grass/sif/Initialize(mapload)
	. = ..()
	spawniconchange()
	if(tree_chance && prob(tree_chance) && !check_density())
		new /obj/structure/flora/tree/sif(src)

/turf/simulated/floor/outdoors/grass/sif/proc/spawniconchange()
	icon_state = "fairygrass[rand(0,3)]"

/turf/simulated/floor/outdoors/grass/forest
	name = "thick grass"
	desc = "Greener on the other side."

	icon_state = "junglegrass"
	base_icon_state = "junglegrass"
	damaged_dmi = 'icons/turf/flooring/junglegrass.dmi'
	smooth_icon = 'icons/turf/flooring/junglegrass.dmi'

	grass_chance = 80
	//tree_chance = 20

/turf/simulated/floor/outdoors/grass/sif/forest
	name = "thick growth"

	tree_chance = 10
	grass_chance = 0
