
//these aren't defines so they can stay in this file
#define RESIZE_HUGE 2
#define RESIZE_BIG 1.5
#define RESIZE_NORMAL 1
/// god forgive me for i have sinned by using a const
#define RESIZE_PREF_LIMIT 0.75
#define RESIZE_SMALL 0.5
#define RESIZE_TINY 0.25

//average
#define RESIZE_A_HUGEBIG (RESIZE_HUGE + RESIZE_BIG) / 2
#define RESIZE_A_BIGNORMAL (RESIZE_BIG + RESIZE_NORMAL) / 2
#define RESIZE_A_NORMALSMALL (RESIZE_NORMAL + RESIZE_SMALL) / 2
#define RESIZE_A_SMALLTINY (RESIZE_SMALL + RESIZE_TINY) / 2
