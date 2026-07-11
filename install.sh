#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# dwm + st Installer fuer das Samsung NB30 — Arch Linux ODER Void Linux.
# Baut dwm 6.5 und st 0.9.3 aus gepinnten suckless-Releases, ueberlagert die
# hier versionierten config.h und installiert systemweit nach /usr/local.
# Zusaetzlich: Nord-Textkonsole (Terminus-Font + TTY-Palette).
#
# Aufruf auf dem NB30 (nach `git clone`):
#     ./install.sh
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

# --- 0. Distro erkennen ---------------------------------------------------
if command -v pacman >/dev/null 2>&1; then
    DISTRO=arch
elif command -v xbps-install >/dev/null 2>&1; then
    DISTRO=void
else
    echo "Weder pacman noch xbps gefunden — nur Arch und Void werden unterstuetzt." >&2
    exit 1
fi
msg "Distro erkannt: $DISTRO"

# --- 1. Build- UND Laufzeit-Abhaengigkeiten ------------------------------
# Build: -devel/Header fuer dwm+st. Laufzeit: der X-Server allein reicht
# NICHT — es braucht Videotreiber, Input-Treiber und mindestens einen
# skalierbaren monospace-Font, sonst startet dwm nicht. Auf echtem Void
# (2026) verifiziert, jede Zeile war ein realer Abbruch:
#   xauth               -> startx bricht sonst sofort ab (xauth: not found)
#   xf86-video-intel    -> GMA 3150; ohne DDX findet Xorg keinen Screen
#   mesa-dri            -> swrast/GLX-Fallback (echtes HW-GL gibt's auf
#                          GMA3150 mit aktuellem Mesa ohnehin nicht mehr)
#   xf86-input-libinput -> sonst laeuft X ohne Tastatur/Maus
#   dejavu/liberation   -> sonst stirbt dwm mit "no fonts could be loaded"
#                          (terminus ist Bitmap, loest 'monospace' nicht auf)
#   dmenu               -> Mod+p Programmstarter
#   setxkbmap           -> sonst greift 'setxkbmap de' in dwm-run nicht,
#                          Layout bleibt US-QWERTY (xkeyboard-config allein reicht nicht)
msg "Abhaengigkeiten installieren"
case "$DISTRO" in
  arch)
    sudo pacman -S --needed --noconfirm \
        base-devel libx11 libxft libxinerama fontconfig freetype2 \
        xorg-server xorg-xinit xorg-xauth xorg-setxkbmap \
        xf86-video-intel mesa xf86-input-libinput \
        ttf-dejavu ttf-liberation terminus-font dmenu curl
    ;;
  void)
    # Void braucht die -devel-Pakete fuer die Header.
    sudo xbps-install -Sy \
        base-devel libX11-devel libXft-devel libXinerama-devel \
        fontconfig-devel freetype-devel \
        xorg-server xinit xauth setxkbmap \
        xf86-video-intel mesa-dri xf86-input-libinput \
        dejavu-fonts-ttf liberation-fonts-ttf terminus-font dmenu curl
    ;;
esac

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
make -C "$WORK/dwm-$DWM_VER" clean          # als User bauen
make -C "$WORK/dwm-$DWM_VER"
sudo make -C "$WORK/dwm-$DWM_VER" install   # nach /usr/local -> root

# --- 4. st bauen + installieren ------------------------------------------
msg "st bauen"
rm -rf "$WORK/st-$ST_VER"
tar xzf "$WORK/st-$ST_VER.tar.gz" -C "$WORK"
cp "$HERE/st-config.h" "$WORK/st-$ST_VER/config.h"    # unsere Tweaks
make -C "$WORK/st-$ST_VER" clean            # als User bauen
make -C "$WORK/st-$ST_VER"
sudo make -C "$WORK/st-$ST_VER" install     # nach /usr/local -> root

# --- 5. Start-Wrapper + Session-Eintrag ----------------------------------
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

# --- 7. Nord-TTY-Konsole (Terminus-Font + Nord-Palette) -------------------
# Font wird beim Boot vom jeweiligen Init gesetzt; Distros unterscheiden sich.
msg "Konsolen-Font Terminus setzen ($DISTRO)"
case "$DISTRO" in
  arch)  # systemd liest /etc/vconsole.conf
    if grep -q '^FONT=' /etc/vconsole.conf 2>/dev/null; then
      sudo sed -i 's/^FONT=.*/FONT=ter-116n/' /etc/vconsole.conf
    else
      echo 'FONT=ter-116n' | sudo tee -a /etc/vconsole.conf >/dev/null
    fi ;;
  void)  # runit liest FONT aus /etc/rc.conf
    if grep -q '^FONT=' /etc/rc.conf 2>/dev/null; then
      sudo sed -i 's/^FONT=.*/FONT="ter-116n"/' /etc/rc.conf
    else
      echo 'FONT="ter-116n"' | sudo tee -a /etc/rc.conf >/dev/null
    fi ;;
esac
# sofort anwenden (nur auf echter TTY sinnvoll; in X harmlos)
sudo setfont ter-116n 2>/dev/null || true

msg "Nord-TTY-Palette -> /usr/local/bin/tty-palette"
sudo install -Dm755 "$HERE/console/tty-palette.sh" /usr/local/bin/tty-palette
sudo rm -f /usr/local/bin/gruvbox-creme   # frueheren Creme-Stand aufraeumen

# beim TTY-Login laden (idempotent in ~/.bash_profile eintragen)
PROFILE="$HOME/.bash_profile"
LINE='[ -x /usr/local/bin/tty-palette ] && . /usr/local/bin/tty-palette'
# alte Creme-Zeile(n) entfernen, falls von einem frueheren Lauf vorhanden
sed -i '/gruvbox-creme/d; /Creme-Konsole/d' "$PROFILE" 2>/dev/null || true
if ! grep -qF "$LINE" "$PROFILE" 2>/dev/null; then
  msg "Palette in ~/.bash_profile einhaengen (nur TTY-Login)"
  { echo ''; echo '# TTY-Palette (nur TTY) — dwm-nb30'; echo "$LINE"; } >> "$PROFILE"
fi

msg "Fertig. Aus- und wieder einloggen -> in ly 'dwm' waehlen (oder: startx)."
msg "Die cremige TTY-Palette greift beim naechsten TTY-Login."
