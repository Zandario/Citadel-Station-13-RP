//! ## Security levels.
#define SEC_LEVEL_GREEN   0
#define SEC_LEVEL_BLUE    1
#define SEC_LEVEL_YELLOW  2
#define SEC_LEVEL_VIOLET  3
#define SEC_LEVEL_ORANGE  4
#define SEC_LEVEL_RED     5
#define SEC_LEVEL_DELTA   6


//! ## Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB    (1<<0)  // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB    (1<<1)  // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT (1<<2)  // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME     (1<<3)  // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE  (1<<4)  // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS      (1<<5)  // Shows up on roundstart report.
#define ANTAG_HAS_LEADER      (1<<6)  // Generates a leader antagonist.
#define ANTAG_HAS_NUKE        (1<<7)  // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN       (1<<8)  // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE         (1<<9)  // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE  (1<<10) // Causes antagonists to use an appearance modifier on spawn.


//! ## Mode/antag template macros.
#define MODE_BORER "borer"
#define MODE_XENOMORPH "xeno"
#define MODE_LOYALIST "loyalist"
#define MODE_MUTINEER "mutineer"
#define MODE_COMMANDO "commando"
#define MODE_DEATHSQUAD "deathsquad"
#define MODE_ERT "ert"
#define MODE_TRADE "trader"
#define MODE_MERCENARY "mercenary"
#define MODE_NINJA "ninja"
#define MODE_RAIDER "raider"
#define MODE_WIZARD "wizard"
#define MODE_TECHNOMANCER "technomancer"
#define MODE_CHANGELING "changeling"
#define MODE_CULTIST "cultist"
#define MODE_HIGHLANDER "highlander"
#define MODE_MONKEY "monkey"
#define MODE_RENEGADE "renegade"
#define MODE_REVOLUTIONARY "revolutionary"
#define MODE_MALFUNCTION "malf"
#define MODE_TRAITOR "traitor"
#define MODE_AUTOTRAITOR "autotraitor"
#define MODE_INFILTRATOR "infiltrator"
#define MODE_THUG "thug"
#define MODE_STOWAWAY "stowaway"

#define DEFAULT_TELECRYSTAL_AMOUNT 120


//!##########!//
//!# WIZARD #!//
//!##########!//

//! ## WIZARD SPELL FLAGS
#define GHOSTCAST       (1<<0) // Can a ghost cast it?
#define NEEDSCLOTHES    (1<<1) // Does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN      (1<<2) // Does it require the caster to be human?
#define Z2NOCAST        (1<<3) // If this is added, the spell can't be cast at CentCom
#define STATALLOWED     (1<<4) // If set, the user doesn't have to be conscious to cast. Required for ghost spells
#define IGNOREPREV      (1<<5) // If set, each new target does not overlap with the previous one

//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER     (1<<6) // Does the spell include the caster in its target selection?
#define SELECTABLE      (1<<7) // Can you select each target for the spell?
//AOE spells
#define IGNOREDENSE     (1<<6) // Are dense turfs ignored in selection?
#define IGNORESPACE     (1<<7) // Are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK (1<<8) // Used by construct spells - checks for nullrods
#define NO_BUTTON		(1<<9) // Spell won't show up in the HUD with this


//Invocation
#define SpI_SHOUT   "shout"
#define SpI_WHISPER "whisper"
#define SpI_EMOTE   "emote"
#define SpI_NONE    "none"

//upgrading
#define Sp_SPEED "speed"
#define Sp_POWER "power"
#define Sp_TOTAL "total"

//casting costs
#define Sp_RECHARGE "recharge"
#define Sp_CHARGES  "charges"
#define Sp_HOLDVAR  "holdervar"

#define CHANGELING_STASIS_COST 20
