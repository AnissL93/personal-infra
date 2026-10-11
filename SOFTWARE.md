# Software

Everything I use, one row each. **Add a row whenever something new is installed**, plus a line in
the file named in "Installed by".

- **Pf** (platform): `L` Linux, `M` macOS, `LM` both.
- **Installed by**: `apt.txt`, `Brewfile`, `tools.txt`, `opt.txt` (lists in `packages/`),
  `builds/NAME.sh` (built from source), another `./bootstrap.sh` step, or **`manual`**
  (installed by hand: a fresh machine will not get it).
- **Config**: where its config lives in this repo (linked into `$HOME` by `links.txt`).
- **Themed**: colours written by `dotfiles/themes/theme`.

## Desktop: Linux (X11)

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Xorg, xinit | L | `apt.txt` | `desktop/linux/x11/` | | started from gdm or `startx` |
| dwm, dmenu, dwmblocks | L | step `suckless` | `desktop/linux/dwm` | ✓ | own fork, built to `/usr/local` |
| st | L | step `suckless` | `desktop/linux/st` | ✓ | own fork |
| slock | L | step `suckless` | `desktop/linux/slock` | ✓ | own fork |
| cursors | L | `theme` | `desktop/linux/cursors` | ✓ | generated per theme |
| xcompmgr, xdotool | L | `apt.txt` | | | |
| dunst | L | `apt.txt` | `desktop/linux/dunst/` | ✓ | |
| flameshot | L | `apt.txt` | | | |
| redshift | L | `apt.txt` | `desktop/linux/redshift.conf` | | |
| keyd | L | `apt.txt`, step `keyboard` | `keymap/linux/keyd.conf` | | |
| fcitx5 + Rime | L | `apt.txt` | `rime/` | ✓ | |
| GTK settings | L | | `desktop/linux/gtk-3.0/` | | cursor only |
| desktop scripts | L | | `desktop/linux/scripts/`, `desktop/linux/bin/` | | status bar blocks, dmenu helpers, font tools |
| fonts | LM | step `fonts` | `github.com:AnissL93/assets` (`fonts/`) | | one folder per family with its licence; StarLovePencil local only (licence unknown) |
| wallpapers | LM | `theme` (downloads on first use) | `github.com:AnissL93/assets` | ✓ | cache `~/.local/share/wallpapers`; Linux: feh, macOS: osascript (one image on all screens); other collections are forks, see the assets README |

## Desktop: macOS

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| AeroSpace | M | `Brewfile` | `desktop/mac/aerospace/` | | tiling WM |
| skhd | M | `Brewfile`, step `services` | `desktop/mac/skhd/` | | hotkeys |
| JankyBorders | M | `Brewfile`, step `services` | `desktop/mac/borders/` | ✓ | |
| Squirrel + librime | M | `Brewfile` | `rime/` (`~/Library/Rime`) | | librime for emacs-rime |
| SketchyBar | M | `Brewfile`, step `services` | `desktop/mac/sketchybar/` | ✓ | status bar like dwm + dwmblocks |
| Karabiner-Elements | M | `Brewfile` | `keymap/mac/` | | rules generated from `keymap/linux/keyd.conf` |
| dmenu (own, Swift) | M | step `builds` | `desktop/mac/dmenu/dmenu.swift` | ✓ | dwm's dmenu on macOS: bar over SketchyBar, theme bar colours, same flags; `dmenu_run` (AeroSpace `cmd-d`) and `getpass` in `desktop/mac/bin/` |
| pinentry-mac | M | `Brewfile` | `desktop/mac/gnupg/gpg-agent.conf` | | GPG passphrase dialog, so `pass` works without a terminal |
| f.lux | M | `Brewfile` | | | redshift on Linux |
| nowplaying-cli, switchaudio-osx | M | `Brewfile` | | | playerctl / pulsemixer on Linux |
| duti | M | `Brewfile`, step `defaults` | | | default apps |

## Terminal and shell

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| alacritty | LM | `apt.txt` / `Brewfile` | `dotfiles/alacritty/` | ✓ | `linux.toml` / `alacritty.toml` |
| kitty | M | `Brewfile` | `dotfiles/kitty/` | ✓ | macOS terminal (`cmd-enter` → `desktop/mac/bin/term`: a window in the running kitty, 0.2 s vs ~1.3 s for a new process), st's keys: `alt-l` open link, `alt-y` copy link, `alt-o` copy last output |
| swallow | M | step `links` | `desktop/mac/bin/swallow`, `desktop/mac/zsh/swallow.zsh` | | dwm's swallow on AeroSpace: an app run from a terminal hides it until the app exits; `~/.zshrc` sources the hook |
| bash + oh-my-bash | L | step `shell` | `dotfiles/bash/` | ✓ | prompt colours |
| zsh | LM | `apt.txt` | | | macOS default shell; Mac shell config not in git |
| tmux | LM | `apt.txt` / `Brewfile` | | | no config |
| fzf | LM | `apt.txt` / `Brewfile` | | | also `~/System/fzf` (git clone) |
| ripgrep | LM | `apt.txt` / `Brewfile` | | | |
| lf | LM | `apt.txt` / `Brewfile` | `dotfiles/lf/` | | **not linked** |
| htop / btop | LM | `apt.txt` / `Brewfile` | | | |
| thefuck | M | `Brewfile` | `dotfiles/thefuck/` | | |
| jq, wget | M | `Brewfile` | | | |
| impala | L | `tools.txt` (cargo) | | | Wi-Fi TUI |
| rtk | L | **manual** | | | `~/.local/bin` |

## Editors and IDEs

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Emacs | LM | `builds/emacs.sh` / `Brewfile` (emacs-plus@31) | | | Linux: 30.2 in `/usr/local`, Lucid, native-comp; macOS: 31 |
| Doom Emacs | LM | step `emacs` | `dotfiles/doom/` | ✓ | |
| Neovim | LM | `apt.txt` / `Brewfile` | `dotfiles/nvim-config/` | ✓ | |
| VS Code | LM | **manual** (vendor repo) / `Brewfile` | `dotfiles/vscode/` | ✓ | macOS: `settings-mac.json` (Retina sizes, no UI zoom), linked by step `links` (path has spaces) |
| PyCharm, RustRover | LM | `opt.txt` / `Brewfile` | | | Linux: `/opt/pycharm`, `/opt/rustrover` |
| Obsidian | LM | **manual** (deb) / `Brewfile` | `dotfiles/obsidian/` | ✓ | themed vault: Linux `/srv/sync/WorkNotes`, macOS `~/Sync/WorkNotes`; + `obsidian-cli` in `~/.local/bin` (Linux) |

## Development

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| gcc/g++ 14, clang, clangd, clang-format | L | `apt.txt` | | | |
| cmake, meson, ninja, ccache | L | `apt.txt` | | | |
| git, gh | LM | `apt.txt` / `Brewfile` | | | |
| Go + gopls | LM | **manual** (Go) / `Brewfile` + `tools.txt` (gopls) | | | Linux: `/usr/local/go` |
| Rust + rust-analyzer | LM | **manual** (rustup) / `Brewfile` (rust) | | | `~/.cargo` |
| uv + basedpyright | LM | **manual** (Linux: astral.sh installer, `~/.local/bin/uv`) / `Brewfile` (uv) + `tools.txt` | | | every Python project and tool; old conda envs exported to `~/System/backups/conda-envs/` |
| Node + npm globals | LM | **manual** (nvm) / `Brewfile` + `tools.txt` | | | vtsls, typescript, marp-cli, emacs-lsp-proxy, 9router |
| Docker (+ nvidia-container-toolkit on Linux) | LM | **manual** (vendor repo) / `Brewfile` (docker-desktop) | | | |
| CUDA toolkit 13, NVIDIA driver 595 | L | **manual** (vendor repo) | | | |
| Google Cloud CLI | L | **manual** (vendor repo) | | | |
| ESP-IDF | L | **manual** | | | `~/System/esp`; minicom (`apt.txt`) for serial |

## AI tools

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Claude Code | LM | **manual** | `dotfiles/claude/` | ✓ | `~/.claude` mostly not in git |
| Codex | L | **manual** | | | `~/.codex` |
| CodeIsland | M | `builds/codeisland.sh` | | ✓ | Claude Code / Codex / Gemini CLI status around the notch; upstream release + pixel patch (`builds/codeisland-pixel.py`: Cubic 11, theme bar colours, no self-update) in `~/System/CodeIsland` |
| llama.cpp | L | **manual** (source) | | | `~/System/llama.cpp` (15 GB) |
| research-idea-explorer (`rie`), tapp-cli | L | **manual** | | | `~/.local/bin` |

## Documents and reading

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| zathura + djvu/cb/ps plugins | LM | `apt.txt` / `Brewfile`, step `defaults` | `dotfiles/zathura/` | ✓ | default document viewer; macOS: `~/Applications/Zathura.app` (step `builds`) passes Finder's files to it. No AZW3 (MuPDF cannot read it) |
| zathura-pdf-mupdf | LM | `builds/zathura-mupdf.sh` / `Brewfile` | | | EPUB/MOBI |
| Zotero | LM | `opt.txt` / `Brewfile` | | | Linux: `/opt/zotero` |
| hledger | LM | **manual** / `Brewfile` | `dotfiles/hledger/` | | |

## Media

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| mpv, vlc | LM | `apt.txt` / `Brewfile` | | | |
| mix-mpd | L | `builds/mix-mpd.sh` | `desktop/linux/systemd/mix-mpd.service` | | `github.com:AnissL93/mix-mpd` (private; based on net-mpd, extended to mpv and other sources) in `~/System/mix-mpd` → `~/go/bin/mix-mpd` |
| rmpc | L | `tools.txt` (cargo) | `~/.config/rmpc` (not in git) | ✓ | client for mix-mpd |
| feh | L | `apt.txt` | | | image viewer and wallpaper setter |
| ffmpeg, Blender | LM | `apt.txt` / `Brewfile` | | | |
| LosslessCut | LM | `opt.txt` / `Brewfile` | | | Linux: `/opt/losslesscut` |
| yt-dlp | LM | `tools.txt` (uv) | | | used by mix-mpd |

## Internet, sync, remote

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Firefox | LM | `opt.txt` / `Brewfile` | `dotfiles/firefox/` | ✓ | Linux: `/opt/firefox`; apt `firefox` (snap stub) also installed |
| Chromium / Google Chrome | LM | **manual** (snap) / `Brewfile` (google-chrome) | | | |
| Syncthing | LM | **manual** (vendor repo) / `Brewfile` | | | |
| Tailscale | LM | **manual** (vendor repo) / `Brewfile` | | | |
| rclone, openlist | LM | **manual** / `Brewfile` (rclone) | | | `~/.local/bin`; openlist Linux only |
| frpc | L | `opt.txt` | | | `/opt/frpc` |
| Bitwarden CLI (`bw`) | LM | **manual** / `Brewfile` | | | Linux: `~/.local/bin`; macOS also the Bitwarden app |
| qBittorrent | LM | `apt.txt` / **manual** (macOS: the Homebrew cask is disabled, fails Gatekeeper) | | | |
| Baidu Netdisk | L | **manual** (deb) | | | |
| LocalSend | LM | **manual** (snap) / `Brewfile` | | | |
| WeChat | LM | `opt.txt` / `Brewfile` | | | Linux: `/opt/wechat` (AppImage) |
| sshfs, x11vnc | L | `apt.txt` | | | |

## Other

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| ecc | L | **manual** (git) | | | `~/System/ecc`, Claude Code plugin |
