/datum/element/clothing

/datum/element/clothing/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	if(!isclothing(target))
		return ELEMENT_INCOMPATIBLE
