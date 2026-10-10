# personal-infra

My whole computer setup in one place. Each part is its own repo, added here as a submodule.

**Website + theme gallery: <https://anissl93.github.io/personal-infra/>** (`docs/`, regenerate with `docs/build.py`).

| Path | Repo | What |
|---|---|---|
| `dotfiles/` | `github.com:AnissL93/Dotfiles` (public) | configs, scripts, colour themes (`themes/`), **user manual: [`dotfiles/MANUAL.md`](dotfiles/MANUAL.md)** |
| `desktop/` | `github.com:AnissL93/desktop` | window-manager layer, per OS: `linux/` (dwm with dmenu/dwmblocks, st, slock as submodules; x11, dunst, scripts, bin, gtk, fontconfig, cursor generator) and `mac/` (AeroSpace, skhd, borders, SketchyBar, Mac setup scripts) |
| `keymap/` | `github.com:AnissL93/homerow-keymap` | keyboard layout: keyd for Linux (`linux/keyd.conf`, `/etc/keyd/default.conf` links here), Karabiner for macOS (`mac/`) |
| `rime/` | `github.com:AnissL93/rime` | Rime input schemes (小鹤双拼 + 形码辅助) for fcitx5 (`~/.local/share/fcitx5/rime` links here) and Squirrel on macOS (`~/Library/Rime`). Typing history (`*.userdb`, `sync/`) and `build/` are git-ignored |
| `knowledge-forge/` | `github.com:AnissL93/knowledge-forge` | public Obsidian vault template (research + startup pipeline). My private vault is synced with Syncthing; improvements are periodically folded back into this template |

The old paths `~/System/dotfiles` and `~/Projects/knowledge-forge` are
symlinks into this folder, so existing links and scripts keep working.

Working with submodules:

```sh
git clone --recursive git@github.com:AnissL93/personal-infra.git   # fresh machine
git submodule update --init --recursive                              # after a plain clone
# change something: commit + push inside the submodule first, then here:
git add dotfiles && git commit -m "Bump dotfiles"
```

Every installed app, how it is installed and where its config lives: [`SOFTWARE.md`](SOFTWARE.md).
What bootstrap installs is listed in `packages/` (apt, Brewfile, tools, `/opt` apps), `builds/`
(built from source) and `links.txt` (config symlinks, per platform).

## New machine

```sh
git clone --recursive git@github.com:AnissL93/personal-infra.git ~/System/personal-infra
cd ~/System/personal-infra && ./bootstrap.sh --dry-run   # then without --dry-run
```

The same command sets up Linux (dwm on X11) and macOS (AeroSpace, SketchyBar, the Swift dmenu, Karabiner,
CodeIsland); it detects the OS and runs only that platform's steps. `./bootstrap.sh --help` lists the steps;
each one can be run on its own and re-run safely. On a Mac, apps installed by hand first need
`HOMEBREW_CASK_OPTS=--adopt brew bundle --file packages/Brewfile`.
How the Mac maps onto the Linux desktop: `dotfiles/MANUAL.md`, section "macOS".
Details: `dotfiles/MANUAL.md`, section "Where things live".
