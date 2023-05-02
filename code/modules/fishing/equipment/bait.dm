obj/item/reagent_containers/food/snacks/bait
	abstract_type = /obj/item/reagent_containers/food/snacks/bait
	name = "this is bait"
	desc = "you got baited."
	icon = 'icons/modules/fishing/bait.dmi'
	bitesize = 1
	/// Quality trait of this bait
	var/bait_quality = BASIC_QUALITY_BAIT_TRAIT
	/// Icon state added to main fishing rod icon when this bait is equipped
	var/rod_overlay_icon_state

obj/item/reagent_containers/food/snacks/bait/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, GOOD_QUALITY_BAIT_TRAIT, INNATE_TRAIT)
	ADD_TRAIT(src, FISHING_BAIT_TRAIT, INNATE_TRAIT)
	reagents.add_reagent("protein", 1)

obj/item/reagent_containers/food/snacks/bait/worm
	name = "worm"
	desc = "It's a wriggling worm from a can of fishing bait. You're not going to eat it are you ?"
	icon_state = "worm"
	// food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	// tastes = list("meat" = 1, "worms" = 1)
	// foodtypes = GROSS | MEAT | BUGS
	w_class = WEIGHT_CLASS_TINY
	bait_quality = BASIC_QUALITY_BAIT_TRAIT
	rod_overlay_icon_state = "worm_overlay"

obj/item/reagent_containers/food/snacks/bait/worm/premium
	name = "extra slimy worm"
	desc = "This worm looks very sophisticated."
	bait_quality = GOOD_QUALITY_BAIT_TRAIT

obj/item/reagent_containers/food/snacks/bait/doughball
	name = "doughball"
	desc = "Small piece of dough. Simple but effective fishing bait."
	icon_state = "doughball"
	// food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	// tastes = list("dough" = 1)
	// foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY
	bait_quality = BASIC_QUALITY_BAIT_TRAIT
	rod_overlay_icon_state = "dough_overlay"

/// These are generated by tech fishing rod
obj/item/reagent_containers/food/snacks/bait/doughball/synthetic
	name = "synthetic doughball"
	icon_state = "doughball"
	// preserved_food = TRUE
