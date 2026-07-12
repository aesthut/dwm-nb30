#!/bin/sh
# Nord-Palette (Polar Night) fuer die Linux-Textkonsole — via setvtrgb (kbd).
#
# Vorher standen hier 16 OSC-Sequenzen (\e]PnRRGGBB). Die sind fragil und haben
# real danebengegriffen: Index 0 (der Hintergrund) landete auf dem Nord-Lila
# #b48ead statt auf #2e3440 — TTY und tmux waren lila unterlegt. Ausserdem haengt
# ein \e]P ohne Terminator in st und tmux, weil die auf einen String-Terminator
# warten, der nie kommt.
#
# setvtrgb setzt die 16 Konsolenfarben direkt ueber die Kernel-Palette. Kein
# Escape-Parsing, kein Haenger, deterministisch.
#
# Laeuft beim Boot als root (Void: /etc/rc.local) und gilt dann fuer alle TTYs.
# Von Hand aufrufbar: sudo tty-palette

PALETTE="${TTY_PALETTE:-/usr/local/share/dwm-nb30/nord.vtrgb}"

[ -r "$PALETTE" ] || exit 0
command -v setvtrgb >/dev/null 2>&1 || exit 0   # kbd nicht da -> still nichts tun

setvtrgb "$PALETTE" 2>/dev/null || exit 0
