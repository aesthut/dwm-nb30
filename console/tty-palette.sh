#!/bin/sh
# Nord-Palette (Polar Night) fuer die Linux-Textkonsole.
# Setzt die 16 ANSI-Farben via \e]PnRRGGBB — wirkt nur auf einer echten TTY
# (fbcon). In X-Terminals werden die Sequenzen ignoriert, also harmlos.
# Passend zu st (bg #2e3440 / fg #d8dee9) und dwm-nb30.

# Nur auf echter TTY (tty1..tty12) anwenden, sonst nichts tun.
case "$(tty 2>/dev/null)" in
  /dev/tty[0-9]*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

setp(){ printf '\033]P%s%s' "$1" "$2"; }   # n = 0..F (hex), Farbe = RRGGBB

setp 0 2e3440   # schwarz -> Polar-Night-Grund (Hintergrund)
setp 1 bf616a   # rot
setp 2 a3be8c   # gruen
setp 3 ebcb8b   # gelb
setp 4 81a1c1   # blau
setp 5 b48ead   # magenta
setp 6 88c0d0   # cyan
setp 7 d8dee9   # weiss   -> heller Text (Vordergrund)
setp 8 4c566a   # hell-schwarz (gedimmt, nord3)
setp 9 bf616a   # hell-rot
setp A a3be8c   # hell-gruen
setp B ebcb8b   # hell-gelb
setp C 81a1c1   # hell-blau
setp D b48ead   # hell-magenta
setp E 8fbcbb   # hell-cyan (nord7)
setp F eceff4   # hell-weiss -> hellster Text (nord6)

clear   # neu zeichnen, damit der Grund sofort greift
