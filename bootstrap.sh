#!/usr/bin/env bash
# Set up the whole computer from this repo, on Linux (Debian/Ubuntu, dwm desktop) or macOS.
#
# usage: ./bootstrap.sh [--dry-run] [STEP...]
#   no STEP      run every step of this platform, in order
#   --dry-run    print what would be done, change nothing
#
# What gets installed is listed in files, not in this script:
#   packages/apt.txt, packages/Brewfile   system packages (Linux / macOS)
#   packages/tools.txt                    uv / cargo / go / npm / pip tools
#   packages/opt.txt                      downloaded apps, into /opt (Linux)
#   builds/*.sh                           things built from source (Linux)
#   links.txt                             config symlinks, per platform
#
# steps (each is safe to re-run), L = Linux, M = macOS:
#   packages   L M  apt.txt / Brewfile
#   suckless   L    build + install dwm, dmenu, dwmblocks, st, slock (and libxft-bgra if libXft is old)
#   builds     L M  builds/emacs.sh, builds/zathura-mupdf.sh, builds/mix-mpd.sh (Linux);
#                   dmenu from desktop/mac/dmenu/dmenu.swift into ~/.local/bin (macOS)
#   tools      L M  packages/tools.txt
#   opt        L    packages/opt.txt
#   fonts      L M  the fonts of the assets repo (github.com/AnissL93/assets, fonts/)
#   links      L M  links.txt (+ Firefox profile files)
#   shell      L    oh-my-bash, and load dotfiles/bash/desktop.sh from ~/.bashrc
#   emacs      L M  Doom Emacs
#   session    L    dwm entry for display managers (/usr/share/xsessions)
#   keyboard   L    keyd remap: /etc/keyd/default.conf -> keymap/linux/keyd.conf
#   defaults   L M  zathura (Linux) / Skim (macOS) as the default document viewer
#   services   M    start skhd, borders and sketchybar
#   theme      L M  generate all colours, cursors, wallpaper (amber, or the current theme)
#
# Needs sudo (Linux) for packages, suckless, builds, opt, session and keyboard.
# Not automated (printed at the end): credentials, vendor apt repos, Firefox first start.

set -euo pipefail

ROOT="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
DOT="$ROOT/dotfiles"
DESK="$ROOT/desktop/linux"
DRY=""
STAMP="$(date +%Y%m%d-%H%M%S)"
case "$(uname -s)" in
    Linux)  OS=L ;;
    Darwin) OS=M ;;
    *) echo "unsupported system: $(uname -s)" >&2; exit 1 ;;
esac

# ---- helpers ------------------------------------------------------------------------------

say() { printf '\033[1m==> %s\033[0m\n' "$*"; }
x() {                                   # run (or just print with --dry-run)
    printf '  + %s\n' "$*"
    [ -n "$DRY" ] || "$@"
}
have() { command -v "$1" >/dev/null 2>&1; }
entries() { sed 's/#.*//' "$1" | awk 'NF'; }       # a list file without comments and blank lines

link() {                                # link SOURCE TARGET: TARGET becomes a symlink to SOURCE
    local src="$1" dst="$2"
    if [ "$(readlink -f "$dst" 2>/dev/null)" = "$(readlink -f "$src")" ]; then
        return                                              # already linked
    fi
    x mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        x mv "$dst" "$dst.bak-$STAMP"
    fi
    x ln -s "$src" "$dst"
}

# ---- steps --------------------------------------------------------------------------------

step_packages() {
    if [ "$OS" = L ]; then
        say "apt packages (packages/apt.txt)"
        x sudo apt-get update
        # shellcheck disable=SC2046  # one word per package
        x sudo apt-get install -y $(entries "$ROOT/packages/apt.txt")
    else
        say "Homebrew packages (packages/Brewfile)"
        have brew || { echo "  install Homebrew first: https://brew.sh"; return 1; }
        # Homebrew loads formulae from third-party taps only once they are trusted
        # shellcheck disable=SC2046  # one word per tap
        x brew trust $(sed -n 's/^tap "\([^"]*\)".*/\1/p' "$ROOT/packages/Brewfile")
        x brew bundle --file "$ROOT/packages/Brewfile"
    fi
}

step_suckless() {
    say "dwm, dmenu, dwmblocks, st, slock"
    # config.h is copied from config.def.h only when missing: remove it so edits are used
    x sh -c "cd '$DESK/dwm' && rm -f config.h && make && sudo make install"
    x sh -c "cd '$DESK/dwm/dmenu' && rm -f config.h && make && sudo make install"
    x sh -c "cd '$DESK/dwm/dwmblocks' && make clean && make && sudo make install"
    x sh -c "cd '$DESK/st' && make && sudo make install"          # st: config.h is edited directly
    x sh -c "cd '$DESK/slock' && rm -f config.h && make && sudo make install"

    # colour emoji in dwm/st needs libXft >= 2.3.5 (BGRA glyphs); build the patched one if older
    local v; v="$(pkg-config --modversion xft 2>/dev/null || echo 0)"
    if [ "$(printf '%s\n2.3.5\n' "$v" | sort -V | head -1)" != "2.3.5" ]; then
        say "libXft $v is older than 2.3.5: building libxft-bgra"
        [ -d "$DESK/libxft-bgra" ] || x git clone https://github.com/uditkarode/libxft-bgra "$DESK/libxft-bgra"
        x sh -c "cd '$DESK/libxft-bgra' && sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man && sudo make install"
    fi
}

step_builds() {
    if [ "$OS" = M ]; then
        say "build: dmenu (desktop/mac/dmenu/dmenu.swift)"
        x mkdir -p "$HOME/.local/bin"
        x swiftc -O "$ROOT/desktop/mac/dmenu/dmenu.swift" -o "$HOME/.local/bin/dmenu"
        return
    fi
    local b
    for b in emacs zathura-mupdf mix-mpd; do
        say "build: $b (builds/$b.sh)"
        x bash "$ROOT/builds/$b.sh"
    done
}

step_tools() {
    say "tools (packages/tools.txt)"
    local pf inst pkg cmd
    while read -r pf inst pkg; do
        [[ "$pf" == *"$OS"* ]] || continue
        case "$inst" in
            uv)    cmd=(uv tool install "$pkg") ;;
            cargo) cmd=(cargo install "$pkg") ;;
            go)    cmd=(go install "$pkg@latest") ;;
            npm)   cmd=(npm install -g "$pkg") ;;
            pip)   inst=python3; cmd=(python3 -m pip install --user --break-system-packages "$pkg") ;;
            *)     echo "  unknown installer in tools.txt: $inst"; continue ;;
        esac
        if have "$inst"; then x "${cmd[@]}"; else echo "  skipped $pkg: $inst is not installed"; fi
    done < <(entries "$ROOT/packages/tools.txt")
}

step_opt() {
    say "apps into /opt (packages/opt.txt)"
    local name url launcher dir file bin
    while read -r name url launcher; do
        dir="/opt/$name"
        if [ ! -d "$dir" ]; then
            file="${TMPDIR:-/tmp}/bootstrap-opt-$name"
            x curl -fL -o "$file" "$url"
            x sudo mkdir -p "$dir"
            case "$launcher" in
                *.AppImage) x sudo install -m 755 "$file" "$dir/$launcher" ;;
                *)          x sudo tar -xf "$file" -C "$dir" ;;
            esac
            x rm -f "$file"
            x sudo chown -R "$USER:" "$dir"                 # yours, so apps can update themselves
        fi
        # shellcheck disable=SC2086  # the launcher may hold a * (versioned folder)
        bin="$(ls -d $dir/$launcher 2>/dev/null | head -1 || true)"
        link "${bin:-$dir/$launcher}" "$HOME/.local/bin/$name"
    done < <(entries "$ROOT/packages/opt.txt")
}

step_fonts() {
    say "fonts (github.com/AnissL93/assets, fonts/)"
    # the assets clone if there is one, else a sparse clone holding only fonts/
    local src="$HOME/System/assets"
    if [ ! -d "$src/fonts" ]; then
        src="${XDG_CACHE_HOME:-$HOME/.cache}/assets"
        [ -d "$src/.git" ] || x git clone -q --depth 1 --filter=blob:none --sparse https://github.com/AnissL93/assets "$src"
        x git -C "$src" sparse-checkout set fonts
        x git -C "$src" pull -q
    fi
    if [ "$OS" = L ]; then
        link "$src/fonts" "$HOME/.local/share/fonts/personal-infra"
        x fc-cache -f
    else                                    # macOS does not reliably follow a linked folder here
        x mkdir -p "$HOME/Library/Fonts/personal-infra"
        x rsync -a --delete --exclude '*.md' --exclude '*.txt' "$src/fonts/" "$HOME/Library/Fonts/personal-infra/"
    fi
}

step_links() {
    say "config symlinks (links.txt)"
    [ -e "$ROOT/rime/cn_dicts/ext/flypy_sghot.dict.yaml" ] || x git -C "$ROOT" submodule update --init --recursive rime
    local pf src dst
    while read -r pf src dst; do
        [[ "$pf" == *"$OS"* ]] || continue
        link "$ROOT/$src" "${dst/#\~/$HOME}"
    done < <(entries "$ROOT/links.txt")

    if [ "$OS" = M ]; then                  # a target with spaces, which links.txt cannot hold
        link "$DOT/vscode/settings-mac.json" "$HOME/Library/Application Support/Code/User/settings.json"
    fi

    local ff
    if ff="$("$DESK/bin/ff-profile")"; then
        link "$DOT/firefox/user.js"         "$ff/user.js"
        link "$DOT/firefox/userChrome.css"  "$ff/chrome/userChrome.css"
        link "$DOT/firefox/userContent.css" "$ff/chrome/userContent.css"
    else
        say "no Firefox profile yet: start Firefox once, then run: $0 links theme"
    fi
}

step_shell() {
    say "shell"
    if [ ! -d "$HOME/.oh-my-bash" ]; then
        x sh -c 'curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh | bash -s -- --unattended'
    fi
    if [ -f "$HOME/.bashrc" ] && ! grep -q 'OSH_THEME="sexy"' "$HOME/.bashrc"; then
        x sed -i 's/^OSH_THEME=.*/OSH_THEME="sexy"/' "$HOME/.bashrc"
    fi
    if ! grep -qs 'dotfiles/bash/desktop.sh' "$HOME/.bashrc"; then
        printf '  + append "source ~/System/dotfiles/bash/desktop.sh" to ~/.bashrc\n'
        [ -n "$DRY" ] || printf '\n# desktop settings (PATH, TERMINAL, LS_COLORS, prompt colours), from personal-infra\nsource ~/System/dotfiles/bash/desktop.sh\n' >> "$HOME/.bashrc"
    fi
}

step_emacs() {
    say "Doom Emacs"
    have emacs || { echo "  no emacs yet: run the builds step (Linux) or packages (macOS) first"; return 1; }
    [ -d "$HOME/.config/emacs" ] || x git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    if [ -d "$HOME/.config/emacs/.local" ]; then
        x "$HOME/.config/emacs/bin/doom" sync             # already installed
    else
        x "$HOME/.config/emacs/bin/doom" install --no-config --force
    fi
}

step_session() {
    say "dwm session for display managers"
    x sudo install -m 644 "$DESK/dwm/dwm.desktop" /usr/share/xsessions/dwm.desktop
}

step_keyboard() {
    say "keyd keyboard remap"
    x sudo ln -sfn "$ROOT/keymap/linux/keyd.conf" /etc/keyd/default.conf
    x sudo systemctl enable keyd
    x sudo systemctl restart keyd                     # loads the config
}

step_defaults() {
    if [ "$OS" = M ]; then
        say "default apps: Skim for PDF"
        x duti -s net.sourceforge.skim-app.skim .pdf all
        return
    fi
    say "default apps: zathura for documents (images stay with feh)"
    x xdg-mime default org.pwmt.zathura.desktop \
        application/pdf application/epub+zip application/x-mobipocket-ebook application/x-fictionbook \
        application/x-fictionbook+xml application/oxps application/vnd.ms-xpsdocument \
        image/vnd.djvu image/vnd.djvu+multipage image/x-djvu \
        application/postscript application/x-gzpostscript application/x-bzpostscript image/x-eps \
        application/vnd.comicbook+zip application/vnd.comicbook-rar application/x-cbz application/x-cbr \
        application/x-cb7 application/x-cbt
}

step_services() {
    say "skhd, borders and sketchybar"
    x skhd --start-service
    x brew services restart borders
    x brew services restart sketchybar
}

step_theme() {
    say "colour theme"
    local t; t="$(cat "$HOME/.config/theme/current" 2>/dev/null || echo amber)"
    if [ "$OS" = M ] || [ -n "${DISPLAY:-}" ]; then
        x "$DOT/themes/theme" "$t"
    else
        say "not in X: the theme ($t) is generated on the first startx (see xinitrc)"
    fi
}

manual_steps() {
    if [ "$OS" = L ]; then cat <<'EOF'

Left to do by hand:
  - credentials (never in git): ~/System/dotfiles/doom/secrets.el, ~/.password-store,
    ~/.config/x2ray/*.json, ssh keys (mix-mpd is a private repo: the builds step needs them)
  - vendor apt repos, then their packages: see the end of packages/apt.txt
  - language toolchains before `tools`: uv, rustup, nvm (Node), Go (/usr/local/go)
  - VS Code: install it, then `vscode-ui-font on` (sudo) for the pixel UI font
  - Firefox: start it once, then `./bootstrap.sh links theme`
  - then log in on a TTY and run `startx`
EOF
    else cat <<'EOF'

Left to do by hand:
  - before anything else: xcode-select --install, then Homebrew (https://brew.sh)
  - apps installed by hand before: run the packages step once as
    HOMEBREW_CASK_OPTS=--adopt ./bootstrap.sh packages   (else brew stops at "already an App")
  - credentials: ssh keys, ~/System/dotfiles/doom/secrets.el
  - open AeroSpace once and allow it (and skhd) in System Settings > Privacy > Accessibility
  - Karabiner-Elements: open it, allow its driver, then Complex Modifications > Add rule >
    enable the "keymap" rules for your keyboard (right_command = Mac layout, right_alt = Windows layout)
  - SketchyBar: allow it in Privacy > Accessibility if asked
  - VS Code: Command Palette > "Shell Command: Install 'code' command in PATH" (theme uses `code`)
  - Squirrel: add it in System Settings > Keyboard > Input Sources, then "Deploy" from its menu
EOF
    fi
}

# ---- main ---------------------------------------------------------------------------------

if [ "$OS" = L ]; then
    ALL=(packages suckless builds tools opt fonts links shell emacs session keyboard defaults theme)
else
    ALL=(packages tools builds fonts links emacs defaults services theme)
fi
steps=()
for a in "$@"; do
    case "$a" in
        --dry-run) DRY=1 ;;
        -h|--help) sed -n '2,32p' "$0"; exit 0 ;;
        *) [[ " ${ALL[*]} " == *" $a "* ]] || { echo "unknown step: $a (steps here: ${ALL[*]})" >&2; exit 1; }
           steps+=("$a") ;;
    esac
done
[ ${#steps[@]} -gt 0 ] || steps=("${ALL[@]}")

[ -n "$DRY" ] && say "dry run: nothing will be changed"
for s in "${steps[@]}"; do "step_$s"; done
[ ${#steps[@]} -eq ${#ALL[@]} ] && manual_steps
exit 0
