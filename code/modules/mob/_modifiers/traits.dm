/datum/modifier/trait
	flags = MODIFIER_GENETIC	// We want traits to persist if the person gets cloned.


/datum/modifier/trait/flimsy
	name = "flimsy"
	desc = "You're more fragile than most, and have less of an ability to endure harm."

	on_created_text = "<span class='warning'>You feel rather weak.</span>"
	on_expired_text = "<span class='notice'>You feel your strength returning to you.</span>"

	max_health_percent = 0.8

/datum/modifier/trait/frail
	name = "frail"
	desc = "Your body is very fragile, and has even less of an ability to endure harm."

	on_created_text = "<span class='warning'>You feel really weak.</span>"
	on_expired_text = "<span class='notice'>You feel your strength returning to you.</span>"

	max_health_percent = 0.6

/datum/modifier/trait/weak
	name = "weak"
	desc = "A lack of physical strength causes a diminshed capability in close quarters combat"

	outgoing_melee_damage_percent = 0.8

/datum/modifier/trait/wimpy
	name = "wimpy"
	desc = "An extreme lack of physical strength causes greatly diminished capability in close quarters combat."

	outgoing_melee_damage_percent = 0.6

/datum/modifier/trait/haemophilia
	name = "haemophilia"
	desc = "You bleed much faster than average."

	bleeding_rate_percent = 3.0

/datum/modifier/trait/inaccurate
	name = "Inaccurate"
	desc = "You're rather inexperienced with guns, you've never used one in your life, or you're just really rusty.  \
	Regardless, you find it quite difficult to land shots where you wanted them to go."

	accuracy = -15
	accuracy_dispersion = 1

/datum/modifier/trait/high_metabolism
	name = "High Metabolsim"
	desc = "Your body's metabolism is faster than average."

	metabolism_percent = 2.0
	incoming_healing_percent = 1.4

/datum/modifier/trait/low_metabolism
	name = "Low Metabolism"
	desc = "Your body's metabolism is slower than average."

	metabolism_percent = 0.5
	incoming_healing_percent = 0.6

/datum/modifier/trait/taller
	name = "Taller"
	desc = "Your body is taller than average."
	icon_scale_x_percent = 1
	icon_scale_y_percent = 1.09

/datum/modifier/trait/tall
	name = "Tall"
	desc = "Your body is a bit taller than average."
	icon_scale_x_percent = 1
	icon_scale_y_percent = 1.05

/datum/modifier/trait/short
	name = "Short"
	desc = "Your body is a bit shorter than average."
	icon_scale_x_percent = 1
	icon_scale_y_percent = 0.95


/datum/modifier/trait/shorter
	name = "Shorter"
	desc = "You are shorter than average."
	icon_scale_x_percent = 1
	icon_scale_y_percent = 0.915

/datum/modifier/trait/fat
	name = "Overweight"
	desc = "You are heavier than average."

	metabolism_percent = 1.2
	icon_scale_x_percent = 1.054
	icon_scale_y_percent = 1
	slowdown = 1.1
	max_health_percent = 1.05

/datum/modifier/trait/obese
	name = "Obese"
	desc = "You are much heavier than average."
	metabolism_percent = 1.4
	icon_scale_x_percent = 1.095
	icon_scale_y_percent = 1
	slowdown = 1.2
	max_health_percent = 1.10

/datum/modifier/trait/thin
	name = "Thin"
	desc = "You are skinnier than average."
	metabolism_percent = 0.8
	icon_scale_x_percent = 0.945
	icon_scale_y_percent = 1
	max_health_percent = 0.95
	outgoing_melee_damage_percent = 0.95

/datum/modifier/trait/thinner
	name = "Very Thin"
	desc = "You are much skinnier than average."
	metabolism_percent = 0.6
	icon_scale_x_percent = 0.905
	icon_scale_y_percent = 1
	max_health_percent = 0.90
	outgoing_melee_damage_percent = 0.9

/datum/modifier/trait/colorblind_protanopia
	name = "Protanopia"
	desc = "You have a form of red-green colorblindness. You cannot see reds, and have trouble distinguishing them from yellows and greens."

	wire_colors_replace = PROTANOPIA_COLOR_REPLACE
	client_color = list(
		0.57, 0.43, 0,
		0.56, 0.44, 0,
		0,    0.24, 0.76
	)

/datum/modifier/trait/colorblind_deuteranopia
	name = "Deuteranopia"
	desc = "You have a form of red-green colorblindness. You cannot see greens, and have trouble distinguishing them from yellows and reds."

	wire_colors_replace = DEUTERANOPIA_COLOR_REPLACE
	client_color = list(
		0.63, 0.38, 0,
		0.70, 0.30, 0,
		0,    0.30, 0.70
	)

/datum/modifier/trait/colorblind_tritanopia
	name = "Tritanopia"
	desc = "You have a form of blue-yellow colorblindness. You have trouble distinguishing between blues, greens, and yellows, and see blues and violets as dim."

	wire_colors_replace = TRITANOPIA_COLOR_REPLACE
	client_color = list(
		0.95, 0.05, 0,
		0,    0.43, 0.57,
		0,    0.48, 0.53
	)

/datum/modifier/trait/colorblind_taj
	name = "Colorblind - Blue-red"
	desc = "You are colorblind. You have a minor issue with blue colors and have difficulty recognizing them from red colors."

	wire_colors_replace = TRITANOPIA_COLOR_REPLACE
	client_color = list(
		0.40, 0.20, 0.40,
		0.40, 0.60, 0,
		0.20, 0.20, 0.60
	)

/datum/modifier/trait/colorblind_vulp
	name = "Colorblind - Red-green"
	desc = "You are colorblind. You have a severe issue with green colors and have difficulty recognizing them from red colors."

	wire_colors_replace = PROTANOPIA_COLOR_REPLACE
	client_color = list(
		0.50, 0.40, 0.10,
		0.50, 0.40, 0.10,
		0,    0.20, 0.80
	)

/datum/modifier/trait/colorblind_monochrome
	name = "Monochromacy"
	desc = "You are fully colorblind. Your condition is rare, but you can see no colors at all."

	wire_colors_replace = GREYSCALE_COLOR_REPLACE
	client_color = list(
		0.33, 0.33, 0.33,
		0.59, 0.59, 0.59,
		0.11, 0.11, 0.11
	)
