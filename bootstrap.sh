#!/usr/bin/env bash
# Set up the whole desktop on a new (Debian/Ubuntu) machine from this repo.
#
# usage: ./bootstrap.sh [--dry-run] [STEP...]
#   no STEP      run every step in order
#   --dry-run    print what would be done, change nothing
#
# steps (each is safe to re-run):
#   packages   apt packages: X, build deps, desktop tools, input method, fonts
#   suckless   build + install dwm, dmenu, dwmblocks, st, slock (and libxft-bgra if libXft is old)
#   fonts      install the desktop fonts from dotfiles/fonts/desktop
#   links      symlink configs into $HOME (existing files are backed up as *.bak-<date>)
#   shell      oh-my-bash, and load dotfiles/bash/desktop.sh from ~/.bashrc
#   input      fcitx5 + Rime data (github AnissL93/rime)
#   emacs      Doom Emacs
#   python     lunar_python for the 八字 status block
#   session    dwm entry for display managers (/usr/share/xsessions)
#   keyboard   keyd remap: /etc/keyd/default.conf -> keymap/linux/keyd.conf
#   theme      generate all colours, cursors, wallpaper (amber, or the current theme)
#
# Replaces linux-desktop/install.sh. Needs sudo for packages, suckless, session and keyboard.
# Not automated (printed at the end): credentials, VS Code UI font, Firefox first start.

set -euo pipefail

ROOT="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
DOT="$ROOT/dotfiles"
DESK="$ROOT/linux-desktop"
DRY=""
STAMP="$(date +%Y%m%d-%H%M%S)"

# ---- helpers ------------------------------------------------------------------------------

say() { printf '\033[1m==> %s\033[0m\n' "$*"; }
x() {                                   # run (or just print with --dry-run)
    printf '  + %s\n' "$*"
    [ -n "$DRY" ] || "$@"
}
have() { command -v "$1" >/dev/null 2>&1; }

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
    say "apt packages"
    x sudo apt-get update
    x sudo apt-get install -y \
        xorg xinit x11-xserver-utils xdotool xclip xsel xwallpaper xcompmgr \
        build-essential pkg-config git curl autoconf automake libtool xutils-dev \
        libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev libharfbuzz-dev \
        libxrandr-dev libxext-dev libcrypt-dev fontconfig \
        dunst libnotify-bin flameshot pulsemixer playerctl xbacklight redshift upower bc psmisc \
        htop lf fzf zathura imagemagick python3-pip \
        fcitx5 fcitx5-rime \
        fonts-noto-color-emoji fonts-noto-cjk fonts-liberation
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

step_fonts() {
    say "desktop fonts"
    local missing=0 f fams
    fams="$(fc-list : family | tr , '\n')"         # not piped into grep -q: pipefail + SIGPIPE
    for f in "PxPlus IBM VGA 8x16" "Ac437 IBM CGA" "Cubic 11" "typicons" "Fuzzy Bubbles"; do
        grep -qxF "$f" <<<"$fams" || missing=1
    done
    [ "$missing" = 1 ] || { echo "  (all installed)"; return; }
    x mkdir -p "$HOME/.local/share/fonts/personal-infra"
    x cp "$DOT/fonts/desktop/"*.ttf "$HOME/.local/share/fonts/personal-infra/"
    x fc-cache -f
}

step_links() {
    say "config symlinks"
    # scripts and configs refer to these paths
    [ "$ROOT/dotfiles" -ef "$HOME/System/dotfiles" ] || link "$ROOT/dotfiles" "$HOME/System/dotfiles"
    [ "$ROOT/linux-desktop" -ef "$HOME/System/linux-desktop" ] || link "$ROOT/linux-desktop" "$HOME/System/linux-desktop"

    link "$DOT/x11/xinitrc"            "$HOME/.xinitrc"
    link "$DOT/x11/Xresources"         "$HOME/.Xresources"
    link "$DOT/doom"                   "$HOME/.config/doom"
    link "$DOT/dunst"                  "$HOME/.config/dunst"
    link "$DOT/scripts"                "$HOME/.config/Scripts"
    link "$DOT/alacritty/linux.toml"   "$HOME/.config/alacritty/alacritty.toml"
    link "$DOT/fontconfig/fonts.conf"  "$HOME/.config/fontconfig/fonts.conf"
    link "$DOT/gtk-3.0/settings.ini"   "$HOME/.config/gtk-3.0/settings.ini"
    link "$DOT/redshift.conf"          "$HOME/.config/redshift.conf"
    link "$DOT/vscode/settings.json"   "$HOME/.config/Code/User/settings.json"
    link "$DOT/themes/theme"           "$HOME/.local/bin/theme"
    for f in set-en-font set-cjk-font font-preset vscode-ui-font ff-profile; do
        link "$DOT/bin/$f" "$HOME/.local/bin/$f"
    done

    local ff
    if ff="$("$DOT/bin/ff-profile")"; then
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

step_input() {
    say "fcitx5 + Rime"
    if [ ! -d "$HOME/.local/share/fcitx5/rime/.git" ]; then
        [ -d "$HOME/.local/share/fcitx5/rime" ] && x mv "$HOME/.local/share/fcitx5/rime" "$HOME/.local/share/fcitx5/rime.bak-$STAMP"
        x git clone git@github.com:AnissL93/rime.git "$HOME/.local/share/fcitx5/rime"
    fi
}

step_emacs() {
    say "Doom Emacs"
    have emacs || x sudo apt-get install -y emacs
    [ -d "$HOME/.config/emacs" ] || x git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    if [ -d "$HOME/.config/emacs/.local" ]; then
        x "$HOME/.config/emacs/bin/doom" sync             # already installed
    else
        x "$HOME/.config/emacs/bin/doom" install --no-config --force
    fi
}

step_python() {
    say "python packages"
    python3 -c 'import lunar_python' 2>/dev/null && return
    x python3 -m pip install --user lunar_python \
        || x python3 -m pip install --user --break-system-packages lunar_python
}

step_session() {
    say "dwm session for display managers"
    x sudo install -m 644 "$DESK/dwm/dwm.desktop" /usr/share/xsessions/dwm.desktop
}

step_keyboard() {
    say "keyd keyboard remap"
    dpkg -s keyd >/dev/null 2>&1 || x sudo apt-get install -y keyd
    x sudo ln -sfn "$ROOT/keymap/linux/keyd.conf" /etc/keyd/default.conf
    x sudo systemctl enable keyd
    x sudo systemctl restart keyd                     # loads the config
}

step_theme() {
    say "colour theme"
    local t; t="$(cat "$HOME/.config/theme/current" 2>/dev/null || echo amber)"
    if [ -n "${DISPLAY:-}" ]; then
        x "$DOT/themes/theme" "$t"
    else
        say "not in X: the theme ($t) is generated on the first startx (see xinitrc)"
    fi
}

manual_steps() {
    cat <<'EOF'

Left to do by hand:
  - credentials (never in git): ~/System/dotfiles/doom/secrets.el, ~/System/dotfiles/tokens/,
    ~/.password-store, ~/.config/x2ray/*.json, ssh keys
  - VS Code: install it, then `vscode-ui-font on` (sudo) for the pixel UI font
  - Firefox: start it once, then `./bootstrap.sh links theme`
  - Obsidian: vault paths in OBSIDIAN_VAULTS in dotfiles/themes/theme
  - then log in on a TTY and run `startx`
EOF
}

# ---- main ---------------------------------------------------------------------------------

ALL=(packages suckless fonts links shell input emacs python session keyboard theme)
steps=()
for a in "$@"; do
    case "$a" in
        --dry-run) DRY=1 ;;
        -h|--help) sed -n '2,22p' "$0"; exit 0 ;;
        *) [[ " ${ALL[*]} " == *" $a "* ]] || { echo "unknown step: $a (steps: ${ALL[*]})" >&2; exit 1; }
           steps+=("$a") ;;
    esac
done
[ ${#steps[@]} -gt 0 ] || steps=("${ALL[@]}")

[ -n "$DRY" ] && say "dry run: nothing will be changed"
for s in "${steps[@]}"; do "step_$s"; done
[ ${#steps[@]} -eq ${#ALL[@]} ] && manual_steps
exit 0
