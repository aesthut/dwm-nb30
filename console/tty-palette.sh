#!/bin/sh
# Nord-Palette (Polar Night) fuer die Linux-Textkonsole — via setvtrgb (kbd).
#
# Vorher standen hier 16 OSC-Sequenzen (\e]PnRRGGBB). Die griffen daneben:
# Index 0 (der Hintergrund) landete auf dem Nord-Lila #b48ead statt auf #2e3440
# — TTY *und* tmux waren lila unterlegt. Ausserdem haengt ein \e]P ohne
# Terminator in st und tmux, weil die auf einen String-Terminator warten, der
# nie kommt.
#
# setvtrgb setzt die 16 Konsolenfarben direkt ueber die Kernel-Palette. Kein
# Escape-Parsing, kein Haenger, deterministisch.
#
# WICHTIG — das Skript schweigt nicht, wenn etwas fehlt. Die Kernel-Palette
# ueberlebt bis zum Reboot: griffe das Skript still ins Leere, bliebe die alte
# (lila) Palette stehen und es saehe aus, als haette der Fix nichts getan.
# Also laut sein. Genau diese stille Sorte Fehler hat das Repo schon achtmal
# gekostet.
#
# Laeuft beim Boot als root (Void: /etc/rc.local, Arch: tty-palette.service)
# und gilt dann fuer alle TTYs. Von Hand: sudo tty-palette

PALETTE="${TTY_PALETTE:-/usr/local/share/dwm-nb30/nord.vtrgb}"

if ! command -v setvtrgb >/dev/null 2>&1; then
	echo "tty-palette: setvtrgb fehlt — Paket 'kbd' installieren." >&2
	echo "             Void: sudo xbps-install -y kbd" >&2
	exit 1
fi

if [ ! -r "$PALETTE" ]; then
	echo "tty-palette: Palettendatei nicht lesbar: $PALETTE" >&2
	echo "             Fehlt sie, hat install.sh sie nicht abgelegt." >&2
	exit 1
fi

if ! setvtrgb "$PALETTE"; then
	echo "tty-palette: setvtrgb hat die Palette nicht gesetzt ($PALETTE)." >&2
	exit 1
fi
