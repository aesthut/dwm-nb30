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

## Tastenbelegung

Mod = **Super** (Windows-Taste). Die Belegung ist an **niri** (Framework)
angeglichen, damit dieselben Griffe auf beiden Geraeten sitzen — sie weicht
daher an vielen Stellen vom dwm-Default ab.

**Im Zweifel: `Super+Shift+7` (also `Super+Shift+/`) oder `Super+F1`** zeigt den
vollstaendigen Spickzettel in einem st-Fenster (`keys.txt`).

| Taste | Aktion | Default war |
|-------|--------|-------------|
| `Super+Return` | st (Terminal) | `Super+Shift+Return` |
| `Super+D` | dmenu | `Super+p` |
| `Super+B` | Browser (netsurf/surf/luakit) | `togglebar` |
| `Super+Q` | Fenster schliessen | `Super+Shift+C` |
| `Super+F` | maximieren (monocle) | Layout float |
| `Super+J` / `Super+K` | Fokus wechseln | gleich |
| `Super+H` / `Super+L` | Master-Feld schmaler/breiter | gleich |
| `Super+1` / `Super+2` | Tag wechseln | gleich |
| `Super+Shift+1/2` | Fenster auf Tag | gleich |
| `Super+Shift+Space` | schwebend/gekachelt | gleich |
| `Super+Shift+B` | Statusleiste ein/aus | `Super+B` |
| `Super+Alt+L` | sperren (slock) | — |
| `Druck` / `Shift+Druck` | Screenshot ganz / Bereich (maim) | — |
| Lautstaerke-/Helligkeitstasten | `vol` / `bright` | — |
| `Super+Shift+E` | dwm beenden | `Super+Shift+Q` |

Wo niri kein Gegenstueck in dwm hat (Spalten, Overview), liegt die naechst-
liegende dwm-Aktion auf demselben Griff: `Super+H/L` schiebt in niri den Fokus
zwischen Spalten, hier veraendert es die Master-Breite.

`install.sh` legt dazu drei Helfer nach `/usr/local/bin`:

- `vol up|down|mute` — nimmt `wpctl` (Pipewire), sonst `amixer` (ALSA)
- `bright up|down` — `brightnessctl`, sonst folgenlos
- `dwm-keys` — zeigt `keys.txt` in st

**tmux** (aus [`tmux-nb30`](https://github.com/aesthut/tmux-nb30)) spiegelt diese
Griffe mit **Alt** statt Super — die Super-Taste kommt im Terminal nicht an.
Also `Alt+J/K` = Pane-Fokus, `Alt+Q` = Pane zu, `Alt+F` = Zoom.

## Anpassen

- `config.h`     — dwm (Fonts, Farben, Keybinds, Layouts)
- `st-config.h`  — st (Font, Farben, Scrollback)

**Schrift** ist **JetBrains Mono** (holt `install.sh` von GitHub nach
`/usr/local/share/fonts` — kraeftiger + besser lesbar als der duenne Default).
Groesse/Gewicht justieren und danach erneut `./install.sh`:

- st: `st-config.h` → `static char *font = "JetBrains Mono:style=Medium:pixelsize=15…"`
  — `pixelsize` rauf/runter; `style=Medium` → `Bold` (fetter) oder `Regular` (duenner).
- dwm-Bar/dmenu: `config.h` → `fonts[]` / `dmenufont` (`size=11`).

Auf dem 1024×600-Display sind `pixelsize=14–16` (st) bzw. `size=10–12` (Bar) sinnvoll.
