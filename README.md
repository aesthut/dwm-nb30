# dwm-nb30

dwm + st, zugeschnitten fuer ein **Samsung NB30** (2 GB RAM).
Laeuft auf **Arch Linux** oder **Void Linux** — `install.sh` erkennt die Distro
selbst (pacman/xbps). Entwickelt/getestet in einem Xephyr-Playground auf NixOS,
hier landet nur das fertige Ergebnis fuer das Zielgeraet.

Farbschema: **Nord (Polar Night, dunkel)** — bg `#2e3440`, fg `#d8dee9`, Akzent
Frost-Cyan `#88c0d0`. dwm-Bar, st und die TTY-Konsole ziehen dasselbe Nord wie
[`tmux-nb30`](https://github.com/aesthut/tmux-nb30).

## Gepinnte Versionen

| Komponente | Version | sha256 |
|------------|---------|--------|
| dwm | 6.5   | `21d79ebf…09729` |
| st  | 0.9.3 | `9ed9feab…649b` |

## Installation auf dem NB30

```sh
git clone https://github.com/aesthut/dwm-nb30
cd dwm-nb30
./install.sh          # Distro erkennen, Deps, Build, install, xsession, Nord-Konsole
```

Danach **ausloggen** und im Login-Manager **ly** die Session **`dwm`** waehlen.
(Ohne ly, direkt vom TTY: `startx`.)

`install.sh` erkennt Arch oder Void, laedt die suckless-Releases, verifiziert
die Pruefsummen, ueberlagert die hier versionierten `config.h` (dwm) bzw.
`st-config.h` (st), baut und installiert beides. Zusaetzlich:

- `/usr/local/bin/dwm-run` — Start-Wrapper (Tastaturlayout, Statusbar, dann dwm)
- `/usr/share/xsessions/dwm.desktop` — damit **ly** dwm als Session anbietet
- `~/.xinitrc` — Fallback fuer `startx` vom TTY
- **Nord-Konsole**: Terminus-Font (`FONT=ter-116n` in `/etc/vconsole.conf` auf
  Arch bzw. `/etc/rc.conf` auf Void) + Nord-Palette
  (`/usr/local/bin/tty-palette`, beim TTY-Login aus `~/.bash_profile` geladen).
  Wirkt nur auf der echten TTY, in X harmlos.

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

`Mod+p` braucht **dmenu** (Arch: `sudo pacman -S dmenu`, Void:
`sudo xbps-install dmenu`), falls gewuenscht.

## Anpassen

- `config.h`     — dwm (Fonts, Farben, Keybinds, Layouts)
- `st-config.h`  — st (Font, Farben, Scrollback)

Nach Aenderung erneut `./install.sh` laufen lassen.
