# Software

Everything I use, one row each. **Add a row whenever something new is installed.**

- **Platform**: `L` Linux, `M` macOS, `LM` both.
- **Installed by**: `bootstrap` (`./bootstrap.sh` step), `mac-setup` (`dotfiles/setup.sh`), or **`manual`**
  (installed by hand: a fresh machine will not get it; these are the gaps to close).
- **Config**: folder in `dotfiles/` (linked into `$HOME`), or another place.
- **Themed**: colours written by `dotfiles/themes/theme`.

## Desktop: Linux (X11)

| App                           | Pf  | Installed by                  | Config                                                          | Themed | Notes                                                    |
| ----------------------------- | --- | ----------------------------- | --------------------------------------------------------------- | ------ | -------------------------------------------------------- |
| Xorg, xinit                   | L   | bootstrap `packages`          | `desktop/linux/x11/`                                                          |        | started from gdm or `startx`                             |
| dwm, dmenu, dwmblocks         | L   | bootstrap `suckless`          | `desktop/linux/dwm`                                             | ✓      | built from source to `/usr/local`                        |
| st                            | L   | bootstrap `suckless`          | `desktop/linux/st`                                              | ✓      |                                                          |
| slock                         | L   | bootstrap `suckless`          | `desktop/linux/slock`                                           | ✓      |                                                          |
| cursors                       | L   | `theme`                       | `desktop/linux/cursors`                                         | ✓      | generated per theme                                      |
| xcompmgr, xwallpaper, xdotool | L   | bootstrap `packages`          |                                                                 |        |                                                          |
| dunst                         | L   | bootstrap `packages`          | `desktop/linux/dunst/`                                                        | ✓      |                                                          |
| flameshot                     | L   | bootstrap `packages`          |                                                                 |        |                                                          |
| redshift                      | L   | bootstrap `packages`          | `desktop/linux/redshift.conf`                                                 |        |                                                          |
| keyd                          | L   | bootstrap `keyboard`          | `keymap/linux/keyd.conf`                                        |        |                                                          |
| fcitx5 + Rime                 | L   | bootstrap `packages`, `input` | `rime/`                                                         | ✓      |                                                          |
| GTK settings                  | L   | bootstrap `links`             | `desktop/linux/gtk-3.0/`                                                      |        | cursor only                                              |
| fonts                         | LM  | bootstrap `fonts`             | `fonts/desktop/`                                                |        | `fonts/` (3.4 GB) is local only                          |
| wallpapers                    | L   | `theme`                       | `themes/wallpapers/`, `wallpapers/`, `desktop/wallpapers` | ✓      | **three copies**; the last is makccr/wallpapers (8.3 GB) |

### FIX
- change xwallpaper to feh for setting wallpaper.
- For wallpaper: keep the images used in my theme, and for other peoples wallpaper repo, fork them and link in doc only
- For fonts: keep the one used in the font script, pixel and bubble, and the ones used in obsidian, remove all others.
- Keyd: this should be getting from the homerow-keymap repo
## Desktop: macOS

| App                                       | Pf  | Installed by      | Config       | Themed | Notes                                        |
| ----------------------------------------- | --- | ----------------- | ------------ | ------ | -------------------------------------------- |
| AeroSpace                                 | M   | mac-setup         | `desktop/mac/aerospace/` |        | tiling WM; **not linked** by `config_mac.sh` |
| skhd                                      | M   |                   | `desktop/mac/skhd/` |        | hotkeys; **not installed** by `setup.sh`     |
| JankyBorders                              | M   | mac-setup         | `desktop/mac/borders/` |        | **not linked**                               |
| Raycast                                   | M   | mac-setup         |              |        |                                              |
| 1Password                                 | M   | mac-setup         |              |        |                                              |
| SF Symbols, SF Mono/Pro, Meslo Nerd fonts | M   | mac-setup         |              |        |                                              |
| switchaudio-osx, nowplaying-cli           | M   | mac-setup         |              |        |                                              |
| librime (for emacs-rime)                  | M   | `install_rime.sh` |              |        | pinned to 1.7.1                              |

### FIX
- remove Raycast and 1Password
- Remove SF, Meslo font, use the same font as Linux
- remove switchaudio-osx, nowplaying-cli
- Update librime and rime on macOS to reuse the rime repo we just modified
## Terminal and shell

| App                             | Pf  | Installed by                     | Config       | Themed | Notes                           |
| ------------------------------- | --- | -------------------------------- | ------------ | ------ | ------------------------------- |
| alacritty                       | LM  | **manual** (apt)                 | `alacritty/` | ✓      | `linux.toml` / `alacritty.toml` |
| WezTerm                         | M   | mac-setup                        |              |        |                                 |
| bash + oh-my-bash               | L   | bootstrap `shell`                | `bash/`      | ✓      | prompt colours                  |
| zsh                             | L   | **manual** (apt)                 |              |        |                                 |
| tmux                            | L   | **manual** (apt)                 |              |        | no config                       |
| fzf                             | LM  | bootstrap `packages`, mac-setup  |              |        | also `~/System/fzf` (git clone) |
| ripgrep                         | L   | **manual** (apt)                 |              |        |                                 |
| lf                              | L   | bootstrap `packages`             | `lf/`        |        | **not linked**                  |
| htop / btop                     | LM  | bootstrap `packages` / mac-setup |              |        |                                 |
| thefuck                         | LM  | mac-setup                        | `thefuck/`   |        |                                 |
| zoxide, eza, starship, jq, wget | M   | mac-setup                        |              |        |                                 |
| rtk                             | L   | **manual**                       |              |        | `~/.local/bin`                  |
| bluetuith                       | L   | **manual**                       |              |        | `~/.local/bin`                  |

### FIX
- Remove WezTerm
- explain zoxide, eza, starship, I don't remember what they are for.
- Remove bluetuith
## Editors and IDEs

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Emacs 30.2 | L | **manual** (source build) | | | `/usr/local`; bootstrap `emacs` installs apt emacs instead |
| Doom Emacs | LM | bootstrap `emacs` | `doom/` | ✓ | |
| Neovim | LM | **manual** (apt) / mac-setup | `nvim-config/` | ✓ | |
| VS Code | L | **manual** (deb) | `vscode/` | ✓ | |
| JetBrains IDEs | L | **manual** | | | `~/System/JetBrains` (8.9 GB) |
| Obsidian | L | **manual** (deb) | `obsidian/` | ✓ | + `obsidian-cli` in `~/.local/bin` |
| Typora | L | **manual** (apt) | | | |

### FIX
- Remove Typora
## Development

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| gcc/g++ 14, clang, clangd, clang-format | L | **manual** (apt) | | | `build-essential` is in bootstrap |
| cmake, meson, ninja, ccache | L | **manual** (apt) | | | meson/ninja via bootstrap `zathura` |
| git, gh | L | **manual** (apt) | | | |
| lazygit | L | — | `~/.config/theme/lazygit.yml` | ✓ | **not installed yet** |
| Go + gopls | L | **manual** | | | `/usr/local/go`, `~/.local/bin/gopls` |
| Rust (rustup) + rust-analyzer | L | **manual** | | | `~/.cargo` |
| uv + basedpyright | L | **manual** | | | |
| Miniforge (conda) | L | **manual** | | | `~/miniforge3`; also provides yt-dlp |
| Node + npm globals | L | **manual** | | | vtsls, typescript, marp-cli, emacs-lsp-proxy, … |
| Docker + nvidia-container-toolkit | L | **manual** (apt repo) | | | |
| CUDA toolkit 13, NVIDIA driver 595 | L | **manual** (apt) | | | |
| Google Cloud CLI | L | **manual** (apt repo) | | | |
| ESP-IDF | L | **manual** | | | `~/System/esp`; minicom for serial |

### FIX
- explain lazygit, what is it for?
- Explain: Can I use uv to replace miniforge?
## AI tools

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| Claude Code | LM | **manual** | `claude/` | ✓ | `~/.claude` mostly not in git |
| Codex | L | **manual** | | | `~/.codex` |
| Ollama | L | **manual** | | | `/usr/local/bin` |
| llama.cpp | L | **manual** (source) | | | `~/System/llama.cpp` (15 GB) |
| Unsloth Studio | L | **manual** | | | `~/.unsloth` |
| research-idea-explorer (`rie`), tapp-cli | L | **manual** | | | `~/.local/bin` |
| npm: openhands agent-canvas, cloudcli, inkos, 9router | L | **manual** | | | |

### FIX
- remove inkos, openhands, cloudcli
- remove ollama
- remove unsloth studio

## Documents and reading

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| zathura + djvu/cb/ps plugins | L | bootstrap `zathura` | `zathura/` | ✓ | default document viewer |
| zathura-pdf-mupdf | L | bootstrap `zathura` | | | source build (EPUB/MOBI) |
| KOReader | L | **manual** (deb) | | | |
| calibre | L | **manual** (apt) | | | |
| Zotero | L | **manual** | | | `~/System/Zotero_linux-x86_64` |
| hledger | L | **manual** | `hledger/` | | |

### FIX
- Remove calibre
- Remove KOReader
## Media

| App                         | Pf  | Installed by             | Config | Themed | Notes                                                                   |
| --------------------------- | --- | ------------------------ | ------ | ------ | ----------------------------------------------------------------------- |
| mpv, vlc                    | L   | **manual** (apt)         |        |        |                                                                         |
| mpd + rmpc                  | L   | **manual** (apt + cargo) |        | ✓      |                                                                         |
| feh, imagemagick            | L   | **manual** / bootstrap   |        |        | feh is the image viewer                                                 |
| ffmpeg, OBS Studio, Blender | L   | **manual** (apt)         |        |        |                                                                         |
| LosslessCut                 | L   | **manual**               |        |        | `~/System/LosslessCut-linux-x64` (+ an AppImage and two archives of it) |
| Kdenlive                    | L   | **manual** (AppImage)    |        |        | `~/System/kdenlive-26.04.1-x86_64.AppImage`                             |
| yt-dlp, mutagen             | L   | **manual** (conda / pip) |        |        |                                                                         |
| v4l2loopback                | L   | **manual** (apt)         |        |        | virtual webcam                                                          |

### FIX
- Remove mpd installed from apt, I'm using net-mpd of my own build
- Remove Kdenlive
- what is mutagen?
- what is v4l2loopback?
- remove imagemagick
- remove obs studio
## Internet, sync, remote

| App                  | Pf  | Installed by          | Config     | Themed | Notes                                                       |
| -------------------- | --- | --------------------- | ---------- | ------ | ----------------------------------------------------------- |
| Firefox              | L   | **manual**            | `firefox/` | ✓      | tarball in `~/System/firefox`; apt `firefox` also installed |
| Chromium             | L   | **manual** (snap)     |            |        |                                                             |
| Syncthing            | L   | **manual** (apt repo) |            |        |                                                             |
| Tailscale            | L   | **manual** (apt repo) |            |        |                                                             |
| rclone, openlist     | L   | **manual**            |            |        | `~/.local/bin`                                              |
| frp                  | L   | **manual**            |            |        | `~/System/frp_0.69.1_linux_amd64`                           |
| Bitwarden CLI (`bw`) | L   | **manual**            |            |        | `~/.local/bin` (+ stray `bw.zip`)                           |
| qBittorrent          | L   | **manual** (apt)      |            |        |                                                             |
| Baidu Netdisk        | L   | **manual** (deb)      |            |        |                                                             |
| LocalSend            | L   | **manual** (snap)     |            |        |                                                             |
| WeChat               | L   | **manual** (AppImage) |            |        | `~/System/WeChatLinux_x86_64.AppImage`                      |
| sshfs, x11vnc        | L   | **manual** (apt)      |            |        |                                                             |

## Other

| App | Pf | Installed by | Config | Themed | Notes |
|---|---|---|---|---|---|
| desktop scripts | L | bootstrap `links` | `desktop/linux/scripts/`, `desktop/linux/bin/` | | status bar blocks, dmenu helpers |
| autocut | L | **manual** (git) | | | `~/System/autocut` |
| net-mpd | L | **manual** (git) | | | `~/System/net-mpd` |
| claude-code-video-toolkit, ecc | L | **manual** (git) | | | `~/System/` |

### FIX
- claude-code-video-toolkit should be in project, I'm working on it.
- autocut should be in Project
- desktop scripts should be part of linux-desktop or mac-desktop


# Other comments
- Should I use linux-desktop as the repo name? I kind of want to have linux and mac desktop, some of the settings are overlapped. give me some suggestion of better organizing the stuff.

