#!/usr/bin/env bash
# zathura-pdf-mupdf (EPUB, MOBI, FB2, XPS for zathura): Ubuntu does not package it.
# Builds the newest release not newer than the installed zathura. Skips when installed. Needs sudo.
set -euo pipefail
SRC="${XDG_CACHE_HOME:-$HOME/.cache}/build/zathura-pdf-mupdf"

plugdir="$(pkg-config --variable=plugindir zathura 2>/dev/null || echo /usr/lib/x86_64-linux-gnu/zathura)"
[ -e "$plugdir/libpdf-mupdf.so" ] && { echo "zathura-pdf-mupdf already installed"; exit 0; }

sudo apt-get install -y zathura-dev libmupdf-dev meson ninja-build
[ -d "$SRC" ] || git clone https://github.com/pwmt/zathura-pdf-mupdf "$SRC"
# plugin tags and zathura versions are both dates
# ponytail: newest tag <= zathura's version; pin the tag by hand if a build fails
zv="$(pkg-config --modversion zathura)"
tag="$({ git -C "$SRC" tag | grep -E '^[0-9]{4}\.'; echo "$zv ZATHURA"; } | sort -V | sed '/ ZATHURA$/,$d' | tail -1)"
git -C "$SRC" checkout -q -f "$tag"
# Ubuntu's mupdf.pc reports an older version than the installed headers and library
sed -i 's/^mupdf_required_version_minor = .*/mupdf_required_version_minor = 0/' "$SRC/meson.build"
rm -rf "$SRC/build"
meson setup "$SRC/build" "$SRC" --prefix=/usr -Dbuildtype=release
ninja -C "$SRC/build"
sudo ninja -C "$SRC/build" install
