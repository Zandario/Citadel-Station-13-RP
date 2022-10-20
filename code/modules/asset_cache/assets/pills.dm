/datum/asset/simple/namespaced/chem_master
	keep_local_name = TRUE

/datum/asset/simple/namespaced/chem_master/register()
	for(var/i = 1 to 24)
		assets["pill[i].png"] = icon('icons/obj/chemical.dmi', "pill[i]")

	for(var/i = 1 to 4)
		assets["bottle-[i].png"] = icon('icons/obj/chemical.dmi', "bottle-[i]")

	return ..()

/*
/datum/asset/spritesheet/simple/pills
	name = "pills"
	assets = list(
		"pill1" = 'icons/assets/pills/pill1.png',
		"pill2" = 'icons/assets/pills/pill2.png',
		"pill3" = 'icons/assets/pills/pill3.png',
		"pill4" = 'icons/assets/pills/pill4.png',
		"pill5" = 'icons/assets/pills/pill5.png',
		"pill6" = 'icons/assets/pills/pill6.png',
		"pill7" = 'icons/assets/pills/pill7.png',
		"pill8" = 'icons/assets/pills/pill8.png',
		"pill9" = 'icons/assets/pills/pill9.png',
		"pill10" = 'icons/assets/pills/pill10.png',
		"pill11" = 'icons/assets/pills/pill11.png',
		"pill12" = 'icons/assets/pills/pill12.png',
		"pill13" = 'icons/assets/pills/pill13.png',
		"pill14" = 'icons/assets/pills/pill14.png',
		"pill15" = 'icons/assets/pills/pill15.png',
		"pill16" = 'icons/assets/pills/pill16.png',
		"pill17" = 'icons/assets/pills/pill17.png',
		"pill18" = 'icons/assets/pills/pill18.png',
		"pill19" = 'icons/assets/pills/pill19.png',
		"pill20" = 'icons/assets/pills/pill20.png',
		"pill21" = 'icons/assets/pills/pill21.png',
		"pill22" = 'icons/assets/pills/pill22.png',
	)
*/
