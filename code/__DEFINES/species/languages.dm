// Language flags.
#define WHITELISTED  (1 << 0) // Language is available if the speaker is whitelisted.
#define RESTRICTED   (1 << 1) // Language can only be acquired by spawning or an admin.
#define NONVERBAL    (1 << 2) // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG     (1 << 3) // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND     (1 << 4) // Broadcast to all mobs with this language.
#define NONGLOBAL    (1 << 5) // Do not add to general languages list.
#define INNATE       (1 << 6) // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  (1 << 7) // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   (1 << 8) // No stuttering, slurring, or other speech problems
#define ALT_TRANSMIT (1 << 9) // Language is not based on vision or sound (Todo: add this into the say code and use it for the rootspeak languages)




//Human
#define LANGUAGE_GALCOM          "Galactic Common"
#define LANGUAGE_HUMAN_EURO      "Zurich Accord Common"
#define LANGUAGE_HUMAN_CHINESE   "Yangyu"
#define LANGUAGE_HUMAN_ARABIC    "Prototype Standard Arabic"
#define LANGUAGE_HUMAN_INDIAN    "New Dehlavi"
#define LANGUAGE_HUMAN_IBERIAN   "Iberian"
#define LANGUAGE_HUMAN_RUSSIAN   "Pan-Slavic"
#define LANGUAGE_HUMAN_SELENIAN  "Selenian"

//Human misc
#define LANGUAGE_GUTTER         "Gutter"
#define LANGUAGE_SPACER         "Spacer"

//Alien
#define LANGUAGE_EAL               "Encoded Audio Language"
#define LANGUAGE_UNATHI_SINTA      "Sinta'unathi"
#define LANGUAGE_UNATHI_YEOSA      "Yeosa'unathi"
#define LANGUAGE_SKRELLIAN         "Skrellian"
#define LANGUAGE_ROOTLOCAL         "Local Rootspeak"
#define LANGUAGE_ROOTGLOBAL        "Global Rootspeak"
#define LANGUAGE_ADHERENT          "Protocol"
#define LANGUAGE_XENO              "Xenomorph"
#define LANGUAGE_XENO_HIVE         "Hivemind"
#define LANGUAGE_VOX               "Vox-pidgin"
#define LANGUAGE_NABBER            "Serpentid"

//Antag
#define LANGUAGE_CULT              "Cult"
#define LANGUAGE_CULT_GLOBAL       "Occult"
#define LANGUAGE_ALIUM             "Alium"

//Other
#define LANGUAGE_PRIMITIVE         "Primitive"
#define LANGUAGE_CHIMPANZEE        "Chimpanzee"
#define LANGUAGE_SIGN              "Sign Language"
#define LANGUAGE_ROBOT_GLOBAL      "Robot Talk"
#define LANGUAGE_DRONE_GLOBAL      "Drone Talk"
#define LANGUAGE_CHANGELING_GLOBAL "Changeling"
#define LANGUAGE_BORER_GLOBAL      "Cortical Link"



// Language IDs.
#define LANGUAGE_AKHANI "Akhani"
#define LANGUAGE_ALAI "Alai"
#define LANGUAGE_BIRDSONG "Birdsong"
#define LANGUAGE_BONES "Echorus"
#define LANGUAGE_CANILUNZT "Canilunzt"
#define LANGUAGE_DAEMON "Daemon"
#define LANGUAGE_ECUREUILIAN "Ecureuilian"
#define LANGUAGE_ENOCHIAN "Enochian"
#define LANGUAGE_EVENT1 "Occursus"
#define LANGUAGE_FARWA "Farwa"
#define LANGUAGE_GIBBERISH "Babel"
#define LANGUAGE_GUTTER "Gutter"
#define LANGUAGE_LUNAR "Selenian" // TODO - Implement this language - Zandario
#define LANGUAGE_MINBUS "Minbus"
#define LANGUAGE_NEAERA "Neaera"
#define LANGUAGE_OCCULT "Occult"
#define LANGUAGE_ROOTGLOBAL "Global Rootspeak"
#define LANGUAGE_ROOTLOCAL "Local Rootspeak"
#define LANGUAGE_SAGARU "Sagaru"
#define LANGUAGE_SCHECHI "Schechi"
#define LANGUAGE_SHADEKIN "Shadekin Empathy"
#define LANGUAGE_SIGN "Sign Language"
#define LANGUAGE_SIIK "Siik"
#define LANGUAGE_SKRELLIAN "Common Skrellian"
#define LANGUAGE_SKRELLIANFAR "High Skrellian"
#define LANGUAGE_SLAVIC "Pan-Slavic"
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_SQUEAKISH "Squeakish"
#define LANGUAGE_STOK "Stok"
#define LANGUAGE_SWARMBOT "Ancient Audio Encryption"
#define LANGUAGE_TERMINUS "Terminus"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_VERNAL "Vernal"
#define LANGUAGE_VESPINAE "Vespinae"
#define LANGUAGE_ZADDAT "Vedahq"


#define LANGUAGE_BORER_GLOBAL "Cortical Link"
#define LANGUAGE_ROBOT_GLOBAL "Robot Talk"
#define LANGUAGE_DRONE_GLOBAL "Drone Talk"
