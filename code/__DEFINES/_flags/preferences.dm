// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.

//! ## Legacy preference toggles.
// /datum/preferences/var/event_preferences
/// High chaos antagonist roles involving violence and action, heists, hostages, etc.
#define EVENT_PREF_BE_ANTAGONIST_CHAOTIC		(1<<0)
/// Milder antagonist roles involving things like espionage, breaking and entry, theft, etc.
#define EVENT_PREF_BE_ANTAGONIST_MILD			(1<<1)
/// Being a hostage
#define EVENT_PREF_BE_HOSTAGE					(1<<2)
/// Being killed
#define EVENT_PREF_BE_KILLED					(1<<3)
/// Be kidnapped
#define EVENT_PREF_BE_KIDNAPPED					(1<<4)
/// Volunteer for calmer events, e.g. traders
#define EVENT_PREF_CALM_EVENT_CHARACTERS		(1<<5)

GLOBAL_LIST_INIT(event_role_list, list(
	"Be Chaotic Antagonist" = EVENT_PREF_BE_ANTAGONIST_CHAOTIC,
	"Be Mild Antagonist" = EVENT_PREF_BE_ANTAGONIST_MILD,
	"Be Hostage" = EVENT_PREF_BE_HOSTAGE,
	"Be Killed" = EVENT_PREF_BE_KILLED,
	"Be Calm/Misc Event Characters" = EVENT_PREF_CALM_EVENT_CHARACTERS
))

GLOBAL_LIST_INIT(event_role_descs, list(
	"[EVENT_PREF_BE_ANTAGONIST_CHAOTIC]" = SPAN_NOTICE("<b>Chaotic Antagonists:</b> Volunteer to partake in more chaotic and high-action/violent antagonism, like murder, hostage taking, destruction, high-risk sabotage, heists, etc."),
	"[EVENT_PREF_BE_ANTAGONIST_MILD]" = SPAN_NOTICE("<b>Mild Antagonists:</b> Volunteer to partake in more mild-mannered antagonism, like theft, infiltration, espionage, causing general ruckuses, etc. This doesn't mean you will never be \
	involved in violence, but these roles are far lower octane than full-on chaotic."),
	"[EVENT_PREF_BE_HOSTAGE]" = SPAN_NOTICE("<b>Hostage:</b> Volunteer to be hostage by some more dangerous threats."),
	"[EVENT_PREF_BE_KILLED]" = SPAN_NOTICE("<b>Killed in Action:</b> Volunteer to be the target of assassins, killers, etc. This may or may not result in you being revivable."),
	"[EVENT_PREF_CALM_EVENT_CHARACTERS]" = SPAN_NOTICE("<b>Misc Event Characters:</b> Volunteer to be some more mild and random event characters: Traders, lost robots, all kinds of things that don't fit into anything else.")
))


//! ## Values for /datum/preference/savefile_identifier
/// This preference is character specific.
#define PREFERENCE_CHARACTER "character"
/// This preference is account specific.
#define PREFERENCE_PLAYER "player"

// Values for /datum/preferences/current_tab
/// Open the character preference window
#define PREFERENCE_TAB_CHARACTER_PREFERENCES 0

/// Open the game preferences window
#define PREFERENCE_TAB_GAME_PREFERENCES 1

/// Open the keybindings window
#define PREFERENCE_TAB_KEYBINDINGS 2

/// These will be shown in the character sidebar, but at the bottom.
#define PREFERENCE_CATEGORY_FEATURES "features"

/// Any preferences that will show to the sides of the character in the setup menu.
#define PREFERENCE_CATEGORY_CLOTHING "clothing"

/// Preferences that will be put into the 3rd list, and are not contextual.
#define PREFERENCE_CATEGORY_NON_CONTEXTUAL "non_contextual"

/// Will be put under the game preferences window.
#define PREFERENCE_CATEGORY_GAME_PREFERENCES "game_preferences"

/// These will show in the list to the right of the character preview.
#define PREFERENCE_CATEGORY_SECONDARY_FEATURES "secondary_features"

/// These are preferences that are supplementary for main features,
/// such as hair color being affixed to hair.
#define PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES "supplemental_features"
