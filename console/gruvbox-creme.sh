#!/bin/sh
# Gruvbox-Light-Palette (Creme) fuer die Linux-Textkonsole.
# Setzt die 16 ANSI-Farben via \e]PnRRGGBB — wirkt nur auf einer echten TTY
# (fbcon). In X-Terminals werden die Sequenzen ignoriert, also harmlos.
# Passend zu st (bg #fbf1c7 / fg #3c3836) und dwm-nb30.

# Nur auf echter TTY (tty1..tty12) anwenden, sonst nichts tun.
case "$(tty 2>/dev/null)" in
  /dev/tty[0-9]*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

setp(){ printf '\033]P%s%s' "$1" "$2"; }   # n = 0..F (hex), Farbe = RRGGBB

setp 0 fbf1c7   # schwarz  -> Creme  (Hintergrund)
setp 1 cc241d   # rot
setp 2 98971a   # gruen
setp 3 d79921   # gelb / Ocker (Akzent)
setp 4 458588   # blau
setp 5 b16286   # magenta
setp 6 689d6a   # cyan
setp 7 3c3836   # weiss   -> Dunkel (Vordergrund)
setp 8 928374   # hell-schwarz (gedimmt)
setp 9 9d0006   # hell-rot
setp A 79740e   # hell-gruen
setp B b57614   # hell-gelb
setp C 076678   # hell-blau
setp D 8f3f71   # hell-magenta
setp E 427b58   # hell-cyan
setp F 282828   # hell-weiss -> fast schwarz (fetter Text)

clear   # neu zeichnen, damit der Creme-Grund sofort greift
