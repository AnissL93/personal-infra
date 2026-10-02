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
| wallpapers | L | `theme` (downloads on first use) | `github.com:AnissL93/assets` | ✓ | cache `~/.local/share/wallpapers`; other collections are forks, see the assets README |

## Desktop: macOS

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| AeroSpace | M | `Brewfile` | `desktop/mac/aerospace/` | | tiling WM |
| skhd | M | `Brewfile`, step `services` | `desktop/mac/skhd/` | | hotkeys |
| JankyBorders | M | `Brewfile`, step `services` | `desktop/mac/borders/` | | |
| Squirrel + librime | M | `Brewfile` | `rime/` (`~/Library/Rime`) | | librime for emacs-rime |

## Terminal and shell

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| alacritty | LM | `apt.txt` / `Brewfile` | `dotfiles/alacritty/` | ✓ | `linux.toml` / `alacritty.toml` |
| bash + oh-my-bash | L | step `shell` | `dotfiles/bash/` | ✓ | prompt colours |
| zsh | LM | `apt.txt` | | | macOS default shell; Mac shell config not in git |
| tmux | L | `apt.txt` | | | no config |
| fzf | LM | `apt.txt` / `Brewfile` | | | also `~/System/fzf` (git clone) |
| ripgrep | LM | `apt.txt` / `Brewfile` | | | |
| lf | L | `apt.txt` | `dotfiles/lf/` | | **not linked** |
| htop / btop | LM | `apt.txt` / `Brewfile` | | | |
| thefuck | M | `Brewfile` | `dotfiles/thefuck/` | | |
| zoxide, eza, starship, jq, wget | M | `Brewfile` | | | smarter `cd`, nicer `ls`, prompt |
| impala | L | `tools.txt` (cargo) | | | Wi-Fi TUI |
| rtk | L | **manual** | | | `~/.local/bin` |

## Editors and IDEs

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Emacs 30.2 | LM | `builds/emacs.sh` / `Brewfile` (emacs-plus) | | | Linux: `/usr/local`, Lucid, native-comp |
| Doom Emacs | LM | step `emacs` | `dotfiles/doom/` | ✓ | |
| Neovim | LM | `apt.txt` / `Brewfile` | `dotfiles/nvim-config/` | ✓ | |
| VS Code | L | **manual** (vendor repo) | `dotfiles/vscode/` | ✓ | |
| PyCharm, RustRover | L | `opt.txt` | | | `/opt/pycharm`, `/opt/rustrover` |
| Obsidian | L | **manual** (deb) | `dotfiles/obsidian/` | ✓ | + `obsidian-cli` in `~/.local/bin` |

## Development

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| gcc/g++ 14, clang, clangd, clang-format | L | `apt.txt` | | | |
| cmake, meson, ninja, ccache | L | `apt.txt` | | | |
| git, gh | LM | `apt.txt` / `Brewfile` | | | |
| Go + gopls | L | **manual** (Go) + `tools.txt` (gopls) | | | `/usr/local/go` |
| Rust (rustup) + rust-analyzer | L | **manual** | | | `~/.cargo` |
| uv + basedpyright | LM | **manual** / `Brewfile` (uv) + `tools.txt` | | | |
| Miniforge (conda) | L | **manual** | | | `~/miniforge3`: envs `0g`, `imm` (pure Python), `SVIP` (full Anaconda); provides the `python3` that runs `theme` |
| Node (nvm) + npm globals | L | **manual** (nvm) + `tools.txt` | | | vtsls, typescript, marp-cli, emacs-lsp-proxy, 9router |
| Docker + nvidia-container-toolkit | L | **manual** (vendor repo) | | | |
| CUDA toolkit 13, NVIDIA driver 595 | L | **manual** (vendor repo) | | | |
| Google Cloud CLI | L | **manual** (vendor repo) | | | |
| ESP-IDF | L | **manual** | | | `~/System/esp`; minicom (`apt.txt`) for serial |

## AI tools

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Claude Code | LM | **manual** | `dotfiles/claude/` | ✓ | `~/.claude` mostly not in git |
| Codex | L | **manual** | | | `~/.codex` |
| llama.cpp | L | **manual** (source) | | | `~/System/llama.cpp` (15 GB) |
| Ollama | L | **manual** | | | `/usr/local/bin`; models 29 GB in `/usr/share/ollama` (kept for now) |
| research-idea-explorer (`rie`), tapp-cli | L | **manual** | | | `~/.local/bin` |

## Documents and reading

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| zathura + djvu/cb/ps plugins | L | `apt.txt`, step `defaults` | `dotfiles/zathura/` | ✓ | default document viewer |
| zathura-pdf-mupdf | L | `builds/zathura-mupdf.sh` | | | EPUB/MOBI |
| Zotero | L | `opt.txt` | | | `/opt/zotero` |
| hledger | L | **manual** | `dotfiles/hledger/` | | |

## Media

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| mpv, vlc | L | `apt.txt` | | | |
| mix-mpd | L | `builds/mix-mpd.sh` | `desktop/linux/systemd/mix-mpd.service` | | `github.com:AnissL93/mix-mpd` (private; based on net-mpd, extended to mpv and other sources) in `~/System/mix-mpd` → `~/go/bin/mix-mpd` |
| rmpc | L | `tools.txt` (cargo) | `~/.config/rmpc` (not in git) | ✓ | client for mix-mpd |
| feh | L | `apt.txt` | | | image viewer and wallpaper setter |
| ffmpeg, Blender | L | `apt.txt` | | | |
| LosslessCut | L | `opt.txt` | | | `/opt/losslesscut` |
| yt-dlp | L | `tools.txt` (uv) | | | used by mix-mpd |

## Internet, sync, remote

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Firefox | L | `opt.txt` | `dotfiles/firefox/` | ✓ | `/opt/firefox`; apt `firefox` (snap stub) also installed |
| Chromium | L | **manual** (snap) | | | |
| Syncthing | L | **manual** (vendor repo) | | | |
| Tailscale | L | **manual** (vendor repo) | | | |
| rclone, openlist | L | **manual** | | | `~/.local/bin` |
| frpc | L | `opt.txt` | | | `/opt/frpc` |
| Bitwarden CLI (`bw`) | L | **manual** | | | `~/.local/bin` |
| qBittorrent | L | `apt.txt` | | | |
| Baidu Netdisk | L | **manual** (deb) | | | |
| LocalSend | L | **manual** (snap) | | | |
| WeChat | L | `opt.txt` | | | `/opt/wechat` (AppImage) |
| sshfs, x11vnc | L | `apt.txt` | | | |

## Other

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| ecc | L | **manual** (git) | | | `~/System/ecc`, Claude Code plugin |

## To do

- Decide: keep zoxide / eza / starship on the Mac? Move Miniforge envs to uv? Remove Ollama?
