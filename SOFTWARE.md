# Software

Everything I use, one row each. **Add a row whenever something new is installed.**

- **Pf** (platform): `L` Linux, `M` macOS, `LM` both.
- **Installed by**: `bootstrap` (a `./bootstrap.sh` step), `mac-setup` (`desktop/mac/setup.sh`), or **`manual`**
  (installed by hand: a fresh machine will not get it; these are the gaps to close).
- **Config**: where its config lives in this repo (linked into `$HOME`).
- **Themed**: colours written by `dotfiles/themes/theme`.

## Desktop: Linux (X11)

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Xorg, xinit | L | bootstrap `packages` | `desktop/linux/x11/` | | started from gdm or `startx` |
| dwm, dmenu, dwmblocks | L | bootstrap `suckless` | `desktop/linux/dwm` | ✓ | own fork, built to `/usr/local` |
| st | L | bootstrap `suckless` | `desktop/linux/st` | ✓ | own fork |
| slock | L | bootstrap `suckless` | `desktop/linux/slock` | ✓ | own fork |
| cursors | L | `theme` | `desktop/linux/cursors` | ✓ | generated per theme |
| xcompmgr, xdotool | L | bootstrap `packages` | | | |
| dunst | L | bootstrap `packages` | `desktop/linux/dunst/` | ✓ | |
| flameshot | L | bootstrap `packages` | | | |
| redshift | L | bootstrap `packages` | `desktop/linux/redshift.conf` | | |
| keyd | L | bootstrap `keyboard` | `keymap/linux/keyd.conf` | | |
| fcitx5 + Rime | L | bootstrap `packages`, `input` | `rime/` | ✓ | |
| GTK settings | L | bootstrap `links` | `desktop/linux/gtk-3.0/` | | cursor only |
| desktop scripts | L | bootstrap `links` | `desktop/linux/scripts/`, `desktop/linux/bin/` | | status bar blocks, dmenu helpers, font tools |
| fonts | LM | bootstrap `fonts` | `github.com:AnissL93/assets` (`fonts/`) | | one folder per family with its licence; StarLovePencil local only (licence unknown) |
| wallpapers | L | `theme` (downloads on first use) | `github.com:AnissL93/assets` | ✓ | cache `~/.local/share/wallpapers`; other collections are forks, see the assets README |

## Desktop: macOS

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| AeroSpace | M | mac-setup | `desktop/mac/aerospace/` | | tiling WM; **not linked** by `config_mac.sh` |
| skhd | M | | `desktop/mac/skhd/` | | hotkeys; **not installed** by `setup.sh` |
| JankyBorders | M | mac-setup | `desktop/mac/borders/` | | **not linked** |
| librime (for emacs-rime) | M | `desktop/mac/install_rime.sh` | | | pinned to 1.7.1 |

## Terminal and shell

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| alacritty | LM | **manual** (apt) / mac-setup | `dotfiles/alacritty/` | ✓ | `linux.toml` / `alacritty.toml` |
| bash + oh-my-bash | L | bootstrap `shell` | `dotfiles/bash/` | ✓ | prompt colours |
| zsh | LM | **manual** (apt) | | | macOS default shell; Mac shell config not in git |
| tmux | L | **manual** (apt) | | | no config |
| fzf | LM | bootstrap `packages`, mac-setup | | | also `~/System/fzf` (git clone) |
| ripgrep | L | **manual** (apt) | | | |
| lf | L | bootstrap `packages` | `dotfiles/lf/` | | **not linked** |
| htop / btop | LM | bootstrap `packages` / mac-setup | | | |
| thefuck | LM | mac-setup | `dotfiles/thefuck/` | | |
| zoxide, eza, starship, jq, wget | M | mac-setup | | | smarter `cd`, nicer `ls`, prompt |
| rtk | L | **manual** | | | `~/.local/bin` |

## Editors and IDEs

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Emacs 30.2 | L | **manual** (source build) | | | `/usr/local`; bootstrap `emacs` installs apt emacs instead |
| Doom Emacs | LM | bootstrap `emacs` | `dotfiles/doom/` | ✓ | |
| Neovim | LM | **manual** (apt) / mac-setup | `dotfiles/nvim-config/` | ✓ | |
| VS Code | L | **manual** (deb) | `dotfiles/vscode/` | ✓ | |
| JetBrains IDEs | L | **manual** | | | `~/System/JetBrains` (8.9 GB) |
| Obsidian | L | **manual** (deb) | `dotfiles/obsidian/` | ✓ | + `obsidian-cli` in `~/.local/bin` |

## Development

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| gcc/g++ 14, clang, clangd, clang-format | L | **manual** (apt) | | | `build-essential` is in bootstrap |
| cmake, meson, ninja, ccache | L | **manual** (apt) | | | meson/ninja via bootstrap `zathura` |
| git, gh | L | **manual** (apt) | | | |
| Go + gopls | L | **manual** | | | `/usr/local/go`, `~/.local/bin/gopls` |
| Rust (rustup) + rust-analyzer | L | **manual** | | | `~/.cargo` |
| uv + basedpyright | L | **manual** | | | |
| Miniforge (conda) | L | **manual** | | | `~/miniforge3`: envs `0g`, `imm` (pure Python), `SVIP` (full Anaconda); provides yt-dlp and the `python3` that runs `theme` |
| Node (nvm) + npm globals | L | **manual** | | | vtsls, typescript, marp-cli, emacs-lsp-proxy, 9router, … |
| Docker + nvidia-container-toolkit | L | **manual** (apt repo) | | | |
| CUDA toolkit 13, NVIDIA driver 595 | L | **manual** (apt) | | | |
| Google Cloud CLI | L | **manual** (apt repo) | | | |
| ESP-IDF | L | **manual** | | | `~/System/esp`; minicom for serial |

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
| zathura + djvu/cb/ps plugins | L | bootstrap `zathura` | `dotfiles/zathura/` | ✓ | default document viewer |
| zathura-pdf-mupdf | L | bootstrap `zathura` | | | source build (EPUB/MOBI) |
| Zotero | L | **manual** | | | `~/System/Zotero_linux-x86_64` |
| hledger | L | **manual** | `dotfiles/hledger/` | | |

## Media

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| mpv, vlc | L | **manual** (apt) | | | |
| mix-mpd + rmpc | L | **manual** (own build + cargo) | `~/.config/rmpc` (not in git) | ✓ | `github.com:AnissL93/mix-mpd` (based on net-mpd, extended to mpv and other sources) in `~/System/mix-mpd` → `~/go/bin/mix-mpd`, systemd user unit `mix-mpd.service` |
| feh | L | bootstrap `packages` | | | image viewer and wallpaper setter |
| ffmpeg, Blender | L | **manual** (apt) | | | |
| LosslessCut | L | **manual** | | | `~/System/LosslessCut-linux-x64` |
| yt-dlp | L | **manual** (conda) | | | |

## Internet, sync, remote

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Firefox | L | **manual** | `dotfiles/firefox/` | ✓ | tarball in `~/System/firefox`; apt `firefox` also installed |
| Chromium | L | **manual** (snap) | | | |
| Syncthing | L | **manual** (apt repo) | | | |
| Tailscale | L | **manual** (apt repo) | | | |
| rclone, openlist | L | **manual** | | | `~/.local/bin` |
| frp | L | **manual** | | | `~/System/frp_0.69.1_linux_amd64` |
| Bitwarden CLI (`bw`) | L | **manual** | | | `~/.local/bin` |
| qBittorrent | L | **manual** (apt) | | | |
| Baidu Netdisk | L | **manual** (deb) | | | |
| LocalSend | L | **manual** (snap) | | | |
| WeChat | L | **manual** (AppImage) | | | `~/System/WeChatLinux_x86_64.AppImage` |
| sshfs, x11vnc | L | **manual** (apt) | | | |

## Other

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| ecc | L | **manual** (git) | | | `~/System/ecc`, Claude Code plugin |

## To do

Reorganisation (plan: `packages/`, `builds/`, `links.txt`; apps to `/opt`):

- macOS: use the same fonts as Linux; link `~/Library/Rime` to `rime/` (Squirrel) and replace
  `install_rime.sh` with a current librime.
- Decide: keep zoxide / eza / starship on the Mac? Move Miniforge envs to uv? Remove Ollama?
