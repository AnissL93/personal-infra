# personal-infra

My whole computer setup in one place. Each part is its own repo, added here as a submodule.

| Path | Repo | What |
|---|---|---|
| `dotfiles/` | `gitlab.com:aniss93/dotfiles` | configs, scripts, colour themes (`themes/`), **user manual: [`dotfiles/MANUAL.md`](dotfiles/MANUAL.md)** |
| `linux-desktop/` | `github.com:AnissL93/linux-desktop` | wallpapers, cursor generator, install scripts; its own submodules `dwm` (with dmenu, dwmblocks), `st`, `slock`, `wallpapers`, `Dotfiles` |
| `knowledge-forge/` | `github.com:AnissL93/knowledge-forge` | public Obsidian vault template (research + startup pipeline). My private vault is synced with Syncthing; improvements are periodically folded back into this template |

The old paths `~/System/dotfiles`, `~/System/linux-desktop` and `~/Projects/knowledge-forge` are
symlinks into this folder, so existing links and scripts keep working.

Working with submodules:

```sh
git clone --recursive git@github.com:AnissL93/personal-infra.git   # fresh machine
git submodule update --init --recursive                              # after a plain clone
# change something: commit + push inside the submodule first, then here:
git add dotfiles && git commit -m "Bump dotfiles"
```
