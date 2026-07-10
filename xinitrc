#!/bin/sh
# ~/.xinitrc -> wird von `startx` (vom TTY) ausgefuehrt.
# Bei Login ueber ly wird stattdessen /usr/share/xsessions/dwm.desktop genutzt.
# Beide Wege rufen denselben Start-Wrapper auf.
exec dwm-run
