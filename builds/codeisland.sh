#!/usr/bin/env bash
# CodeIsland (github.com/wxtsky/CodeIsland, macOS) with the pixel patch (builds/codeisland-pixel.py):
# Cubic 11 pixel font and the desktop theme's bar colours. Clones into ~/System/CodeIsland, resets it to
# the latest upstream release, patches and builds (the command line tools are enough), then installs
# /Applications/CodeIsland.app. Re-run to update; its own auto-update is off.
set -euo pipefail
SRC="$HOME/System/CodeIsland"
HERE="$(cd "$(dirname "$0")" && pwd)"

[ -d "$SRC/.git" ] || git clone https://github.com/wxtsky/CodeIsland.git "$SRC"
cd "$SRC"
git fetch -q --tags origin
tag=$(git describe --tags --abbrev=0 origin/main)
git reset -q --hard "$tag"                    # drop the previous patch before applying it again
echo "CodeIsland $tag"
python3 "$HERE/codeisland-pixel.py" "$SRC"
./build.sh

osascript -e 'quit app "CodeIsland"' 2>/dev/null || true
sleep 1
rm -rf /Applications/CodeIsland.app
ditto .build/release/CodeIsland.app /Applications/CodeIsland.app
open -g /Applications/CodeIsland.app
