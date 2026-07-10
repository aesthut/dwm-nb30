# dwm-nb30

dwm + st, zugeschnitten fuer ein **Samsung NB30** (Arch Linux, 2 GB RAM).
Entwickelt/getestet in einem Xephyr-Playground auf NixOS, hier landet nur das
fertige Ergebnis fuer das Zielgeraet.

## Gepinnte Versionen

| Komponente | Version | sha256 |
|------------|---------|--------|
| dwm | 6.5   | `21d79ebf…09729` |
| st  | 0.9.3 | `9ed9feab…649b` |

## Installation auf dem NB30

```sh
git clone https://github.com/aesthut/dwm-nb30
cd dwm-nb30
./install.sh          # pacman-Deps, Build, install nach /usr/local, xsession + .xinitrc
```

Danach **ausloggen** und im Login-Manager **ly** die Session **`dwm`** waehlen.
(Ohne ly, direkt vom TTY: `startx`.)

`install.sh` laedt die suckless-Releases, verifiziert die Pruefsummen,
ueberlagert die hier versionierten `config.h` (dwm) bzw. `st-config.h` (st),
baut und installiert beides. Zusaetzlich:

- `/usr/local/bin/dwm-run` — Start-Wrapper (Tastaturlayout, Statusbar, dann dwm)
- `/usr/share/xsessions/dwm.desktop` — damit **ly** dwm als Session anbietet
- `~/.xinitrc` — Fallback fuer `startx` vom TTY

## Tastenbelegung (Auszug)

Mod = **Super** (Windows-Taste).

| Taste | Aktion |
|-------|--------|
| `Mod+Shift+Enter` | st (Terminal) |
| `Mod+p` | dmenu |
| `Mod+1..9` | Tag wechseln |
| `Mod+Shift+1..9` | Fenster auf Tag |
| `Mod+j/k` | Fokus wechseln |
| `Mod+t / f / m` | Layout tile / float / monocle |
| `Mod+Shift+c` | Fenster schliessen |
| `Mod+Shift+q` | dwm beenden |

`Mod+p` braucht **dmenu** (`sudo pacman -S dmenu`), falls gewuenscht.

## Anpassen

- `config.h`     — dwm (Fonts, Farben, Keybinds, Layouts)
- `st-config.h`  — st (Font, Farben, Scrollback)

Nach Aenderung erneut `./install.sh` laufen lassen.
