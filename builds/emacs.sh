#!/usr/bin/env bash
# Build GNU Emacs from source into /usr/local (Linux): Lucid toolkit, native compilation,
# tree-sitter, modules. Skips when that version is already installed. Needs sudo.
set -euo pipefail
VER="${EMACS_VERSION:-30.2}"
SRC="${XDG_CACHE_HOME:-$HOME/.cache}/build/emacs-$VER"

if [ "$(emacs --version 2>/dev/null | head -1)" = "GNU Emacs $VER" ]; then
    echo "emacs $VER already installed"; exit 0
fi

sudo apt-get install -y build-essential autoconf texinfo pkg-config \
    "libgccjit-$(gcc -dumpversion | cut -d. -f1)-dev" libtree-sitter-dev \
    libxaw7-dev libxt-dev libxpm-dev libxi-dev libcairo2-dev libharfbuzz-dev libfreetype-dev \
    libgif-dev libjpeg-dev libpng-dev libtiff-dev libwebp-dev liblcms2-dev \
    libgnutls28-dev libxml2-dev libsqlite3-dev libgmp-dev libselinux1-dev libseccomp-dev \
    libasound2-dev libncurses-dev

mkdir -p "$(dirname "$SRC")"
[ -d "$SRC" ] || curl -fL "https://ftpmirror.gnu.org/emacs/emacs-$VER.tar.gz" | tar -xz -C "$(dirname "$SRC")"
cd "$SRC"
./configure --with-tree-sitter --with-json --with-modules --with-x-toolkit=lucid
make -j"$(nproc)"
sudo make install
