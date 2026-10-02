#!/usr/bin/env bash
# mix-mpd (github.com/AnissL93/mix-mpd, private: needs the GitHub SSH key): clone into
# ~/System/mix-mpd, install the binary to ~/go/bin, enable the systemd user service
# (unit: desktop/linux/systemd/mix-mpd.service, linked by `bootstrap.sh links`).
set -euo pipefail
SRC="$HOME/System/mix-mpd"

[ -d "$SRC/.git" ] || git clone git@github.com:AnissL93/mix-mpd.git "$SRC"
(cd "$SRC" && go install ./cmd/mix-mpd)
systemctl --user daemon-reload
systemctl --user enable mix-mpd.service
systemctl --user restart mix-mpd.service
