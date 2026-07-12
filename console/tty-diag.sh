#!/bin/sh
# Diagnose der Textkonsole — sagt, warum die Palette nicht greift.
# Aufruf am NB30:   ~/dwm-nb30/console/tty-diag.sh
# Zum Wegschicken:  ~/dwm-nb30/console/tty-diag.sh | ssh vps 'cat > /tmp/nb30.txt'

echo "=== wo laufe ich ==="
echo "tty:   $(tty 2>/dev/null)"
echo "TERM:  ${TERM:-?}"
echo "TMUX:  ${TMUX:-nein}"

echo
echo "=== setvtrgb da? (kommt aus kbd) ==="
if command -v setvtrgb >/dev/null 2>&1; then
	echo "JA -> $(command -v setvtrgb)"
else
	echo "NEIN — das ist die Ursache. Fix: sudo xbps-install -y kbd"
fi

echo
echo "=== Palettendatei ==="
P=/usr/local/share/dwm-nb30/nord.vtrgb
if [ -r "$P" ]; then
	echo "lesbar -> $P"
	echo "--- Inhalt (Zeile 1 = Rot, 2 = Gruen, 3 = Blau; je 16 Werte) ---"
	cat "$P"
	echo "--- Index 0 (der Hintergrund) soll 46 / 52 / 64 sein = #2e3440 ---"
	awk -F, 'NR<=3 {printf "%s ", $1} END {print ""}' "$P"
else
	echo "FEHLT oder nicht lesbar -> $P"
fi

echo
echo "=== tty-palette-Skript ==="
if [ -x /usr/local/bin/tty-palette ]; then
	echo "installiert. Enthaelt es noch die alten OSC-Sequenzen?"
	if grep -q '033]P' /usr/local/bin/tty-palette 2>/dev/null; then
		echo "  JA — ALTE FASSUNG liegt noch da (das ist der Bug)"
	else
		echo "  nein, neue Fassung (setvtrgb)"
	fi
else
	echo "nicht installiert"
fi

echo
echo "=== laedt .bash_profile noch die alte Palette? ==="
grep -n -i 'palette\|gruvbox' "$HOME/.bash_profile" 2>/dev/null || echo "  keine Palette-Zeile mehr (gut)"

echo
echo "=== wird sie beim Boot gesetzt? ==="
grep -n 'tty-palette' /etc/rc.local 2>/dev/null || echo "  kein Eintrag in /etc/rc.local"

echo
echo "=== Font + Keymap ==="
grep -n -E '^(FONT|KEYMAP)=' /etc/rc.conf 2>/dev/null || echo "  weder FONT noch KEYMAP in /etc/rc.conf"

echo
echo "=== Scharfer Test: Palette jetzt setzen, Rueckgabewert zeigen ==="
if command -v setvtrgb >/dev/null 2>&1 && [ -r "$P" ]; then
	sudo setvtrgb "$P"
	echo "setvtrgb Rueckgabewert: $?  (0 = hat funktioniert)"
else
	echo "uebersprungen — setvtrgb oder Datei fehlt (siehe oben)"
fi

echo
echo "=== Fertig. Schau auf den Bildschirm: ist der Grund jetzt dunkelblaugrau? ==="
