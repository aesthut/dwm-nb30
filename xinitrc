#!/bin/sh
# ~/.xinitrc  -> wird von `startx` ausgefuehrt. Startet dwm.
# Autostart passiert hier (vanilla-Weg, kein Source-Patch noetig).

# Tastaturlayout (oesterreichisch/deutsch). Bei Bedarf anpassen/entfernen.
setxkbmap de 2>/dev/null

# Schlichte Statusbar: Datum/Uhrzeit + Akku, alle 30s in den WM-Namen.
# Laeuft im Hintergrund, beendet sich mit der X-Session.
while :; do
    bat=""
    [ -r /sys/class/power_supply/BAT0/capacity ] && \
        bat=" | Bat $(cat /sys/class/power_supply/BAT0/capacity)%"
    xsetroot -name "$(date '+%a %d.%m. %H:%M')$bat"
    sleep 30
done &

# --- dwm starten (ersetzt den Shell-Prozess) ---
exec dwm
