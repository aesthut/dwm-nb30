#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# dwm + st Installer fuer das Samsung NB30 (Arch Linux).
# Baut dwm 6.5 und st 0.9.3 aus gepinnten suckless-Releases, ueberlagert die
# hier versionierten config.h und installiert systemweit nach /usr/local.
#
# Aufruf auf dem NB30 (nach `git clone`):
#     ./install.sh
# oder alles in einem Rutsch:
#     git clone https://github.com/aesthut/dwm-nb30 && cd dwm-nb30 && ./install.sh
# ---------------------------------------------------------------------------
set -euo pipefail

DWM_VER="6.5"
ST_VER="0.9.3"
DWM_SHA="21d79ebfa9f2fb93141836c2666cb81f4784c69d64e7f1b2352f9b970ba09729"
ST_SHA="9ed9feabcded713d4ded38c8cebf36a3b08f0042ef7934a0e2b2409da56e649b"

HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="${TMPDIR:-/tmp}/dwm-nb30-build"
mkdir -p "$WORK"

msg(){ printf '\033[1;36m>>> %s\033[0m\n' "$*"; }

# --- 1. Build-Abhaengigkeiten (Arch) -------------------------------------
msg "Abhaengigkeiten pruefen/installieren (pacman)"
DEPS=(base-devel libx11 libxft libxinerama fontconfig freetype2 xorg-server xorg-xinit)
sudo pacman -S --needed --noconfirm "${DEPS[@]}"

# --- 2. Quellen holen + verifizieren -------------------------------------
fetch(){  # name url sha
  local f="$WORK/$1"
  [ -f "$f" ] || curl -fsSL -o "$f" "$2"
  echo "$3  $f" | sha256sum -c - >/dev/null || { echo "PRUEFSUMME FALSCH: $1"; exit 1; }
}
msg "dwm $DWM_VER und st $ST_VER laden + Pruefsummen verifizieren"
fetch "dwm-$DWM_VER.tar.gz" "https://dl.suckless.org/dwm/dwm-$DWM_VER.tar.gz" "$DWM_SHA"
fetch "st-$ST_VER.tar.gz"   "https://dl.suckless.org/st/st-$ST_VER.tar.gz"    "$ST_SHA"

# --- 3. dwm bauen + installieren -----------------------------------------
msg "dwm bauen"
rm -rf "$WORK/dwm-$DWM_VER"
tar xzf "$WORK/dwm-$DWM_VER.tar.gz" -C "$WORK"
cp "$HERE/config.h" "$WORK/dwm-$DWM_VER/config.h"     # unsere Tweaks
make -C "$WORK/dwm-$DWM_VER" clean install

# --- 4. st bauen + installieren ------------------------------------------
msg "st bauen"
rm -rf "$WORK/st-$ST_VER"
tar xzf "$WORK/st-$ST_VER.tar.gz" -C "$WORK"
cp "$HERE/st-config.h" "$WORK/st-$ST_VER/config.h"    # unsere Tweaks
make -C "$WORK/st-$ST_VER" clean install

# --- 5. Start-Wrapper + Session-Eintrag fuer ly --------------------------
msg "Start-Wrapper -> /usr/local/bin/dwm-run"
sudo install -Dm755 "$HERE/dwm-run" /usr/local/bin/dwm-run

msg "xsession-Eintrag -> /usr/share/xsessions/dwm.desktop (fuer ly)"
sudo install -Dm644 "$HERE/dwm.desktop" /usr/share/xsessions/dwm.desktop

# 6. .xinitrc nur als Fallback fuer `startx` vom TTY -----------------------
if [ ! -f "$HOME/.xinitrc" ]; then
  msg ".xinitrc anlegen (Fallback fuer startx)"
  cp "$HERE/xinitrc" "$HOME/.xinitrc"
else
  msg ".xinitrc existiert bereits -> nicht ueberschrieben (Vorlage: $HERE/xinitrc)"
fi

msg "Fertig. Aus- und wieder einloggen -> in ly 'dwm' waehlen (oder: startx)."
