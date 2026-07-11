/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrains Mono:style=Medium:size=11" };
static const char dmenufont[]       = "JetBrains Mono:style=Medium:size=11";
/* Nord — Polar Night (dunkel), Akzent Frost-Cyan #88c0d0, passend zum st-Terminal */
static const char col_bg[]          = "#2e3440";   /* nord0  Polar-Night-Grund  */
static const char col_border[]      = "#4c566a";   /* nord3  Rahmen unfokus.     */
static const char col_fg[]          = "#d8dee9";   /* nord4  heller Text        */
static const char col_selfg[]       = "#2e3440";   /* dunkler Text auf Akzent   */
static const char col_accent[]      = "#88c0d0";   /* nord8  Frost-Cyan (aktiv) */
static const char *colors[][3]      = {
	/*               fg         bg         border     */
	[SchemeNorm] = { col_fg,    col_bg,    col_border },
	[SchemeSel]  = { col_selfg, col_accent, col_accent },
};

/* tagging */
static const char *tags[] = { "1", "2" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* Multimedia-/Helligkeitstasten (dwm.c zieht nur keysym.h herein) */
#include <X11/XF86keysym.h>

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]  = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_bg, "-nf", col_fg, "-sb", col_accent, "-sf", col_selfg, NULL };
static const char *termcmd[]   = { "st", NULL };
static const char *browsercmd[]= { "browser", NULL };   /* aus tmux-nb30, waehlt netsurf/surf/luakit */
static const char *lockcmd[]   = { "slock", NULL };
static const char *keyscmd[]   = { "dwm-keys", NULL };  /* Spickzettel, siehe bin/ */
static const char *volupcmd[]  = { "vol", "up", NULL };
static const char *voldowncmd[]= { "vol", "down", NULL };
static const char *volmutecmd[]= { "vol", "mute", NULL };
static const char *brupcmd[]   = { "bright", "up", NULL };
static const char *brdowncmd[] = { "bright", "down", NULL };

/* Screenshots — Ablage wie unter niri: ~/Bilder/Screenshots/ */
#define SHOTDIR "~/Bilder/Screenshots"
#define SHOTNAME "screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"

/* Tastenbelegung an niri (Framework) angeglichen — Mod ist dort wie hier Super.
 * Wo dwm kein Gegenstueck hat (Spalten, Overview), steht die naechstliegende
 * dwm-Aktion auf demselben Griff. Vollstaendige Liste: keys.txt / Super+Shift+7. */
static const Key keys[] = {
	/* modifier                     key            function        argument */
	/* --- Programme ------------------------------------------------------ */
	{ MODKEY,                       XK_Return,     spawn,          {.v = termcmd } },      /* niri: Terminal   */
	{ MODKEY,                       XK_d,          spawn,          {.v = dmenucmd } },     /* niri: fuzzel     */
	{ MODKEY,                       XK_b,          spawn,          {.v = browsercmd } },   /* niri: firefox    */
	{ MODKEY|Mod1Mask,              XK_l,          spawn,          {.v = lockcmd } },      /* niri: swaylock   */
	{ MODKEY|ShiftMask,             XK_slash,      spawn,          {.v = keyscmd } },      /* niri: Hotkey-Overlay */
	{ MODKEY,                       XK_F1,         spawn,          {.v = keyscmd } },      /* Ausweichgriff, falls / klemmt */

	/* --- Fenster -------------------------------------------------------- */
	{ MODKEY,                       XK_q,          killclient,     {0} },                  /* niri: close-window */
	{ MODKEY,                       XK_f,          setlayout,      {.v = &layouts[2]} },   /* niri: maximize (monocle) */
	{ MODKEY|ShiftMask,             XK_space,      togglefloating, {0} },                  /* niri: identisch  */
	{ MODKEY|ShiftMask,             XK_Return,     zoom,           {0} },                  /* dwm: ins Master-Feld */

	/* --- Fokus ---------------------------------------------------------- */
	{ MODKEY,                       XK_j,          focusstack,     {.i = +1 } },           /* niri: identisch  */
	{ MODKEY,                       XK_k,          focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_Down,       focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_Up,         focusstack,     {.i = -1 } },

	/* --- Groesse (niri: Spaltenbreite; dwm kennt nur Master/Stack) ------- */
	{ MODKEY,                       XK_h,          setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,          setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Left,       setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_Right,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_minus,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_plus,       setmfact,       {.f = +0.05} },

	/* --- Layouts & Bar --------------------------------------------------- */
	{ MODKEY,                       XK_t,          setlayout,      {.v = &layouts[0]} },   /* tile     */
	{ MODKEY|ShiftMask,             XK_t,          setlayout,      {.v = &layouts[1]} },   /* floating */
	{ MODKEY,                       XK_space,      setlayout,      {0} },
	{ MODKEY,                       XK_i,          incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_i,          incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_b,          togglebar,      {0} },

	/* --- Tags (niri: Workspaces) ---------------------------------------- */
	TAGKEYS(                        XK_1,                          0)
	TAGKEYS(                        XK_2,                          1)
	{ MODKEY,                       XK_0,          view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,          tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_Tab,        view,           {0} },                  /* letzter Tag */

	/* --- Monitore (am NB30 folgenlos, ein Schirm) ------------------------ */
	{ MODKEY,                       XK_comma,      focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,     focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,      tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,     tagmon,         {.i = +1 } },

	/* --- Screenshots (niri: grim/slurp -> hier maim) --------------------- */
	{ 0,                            XK_Print,      spawn,          SHCMD("mkdir -p " SHOTDIR " && maim " SHOTDIR "/" SHOTNAME) },
	{ ShiftMask,                    XK_Print,      spawn,          SHCMD("mkdir -p " SHOTDIR " && maim -s " SHOTDIR "/" SHOTNAME) },

	/* --- Lautstaerke / Helligkeit --------------------------------------- */
	{ 0,               XF86XK_AudioRaiseVolume,    spawn,          {.v = volupcmd } },
	{ 0,               XF86XK_AudioLowerVolume,    spawn,          {.v = voldowncmd } },
	{ 0,               XF86XK_AudioMute,           spawn,          {.v = volmutecmd } },
	{ 0,               XF86XK_MonBrightnessUp,     spawn,          {.v = brupcmd } },
	{ 0,               XF86XK_MonBrightnessDown,   spawn,          {.v = brdowncmd } },

	/* --- Sitzung -------------------------------------------------------- */
	{ MODKEY|ShiftMask,             XK_e,          quit,           {0} },                  /* niri: quit */
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

