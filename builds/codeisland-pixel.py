#!/usr/bin/env python3
"""Pixel patch for CodeIsland (github.com/wxtsky/CodeIsland), applied by builds/codeisland.sh.

usage: codeisland-pixel.py SRC    (SRC: a clean CodeIsland checkout)

- every system font becomes Cubic 11, a pixel font, at 11 (22 for large text): its native size, crisp on
  Retina, with Latin and Chinese
- the island takes the desktop theme's bar colours (~/.config/theme/sketchybar.sh, written by `theme`;
  read at launch): BAR_BG for its black panel, BAR_FG for its white text, lines and greys
- Sparkle auto-update off (it would replace this build with upstream); the app-icon step, which needs
  Xcode, may fail (the prebuilt AppIcon.icns is used)
Upstream code can change: call sites the patterns miss keep the system font, and are counted below.
"""
import pathlib
import re
import subprocess
import sys

SRC = pathlib.Path(sys.argv[1])
APP = SRC / "Sources/CodeIsland"

PIXEL_STYLE = '''// personal-infra patch (builds/codeisland-pixel.py): pixel font and desktop-theme colours.
import AppKit
import SwiftUI

enum PixelStyle {
    // Cubic 11 is drawn on an 11 px grid: 11 and 22 stay sharp (Retina 2x)
    static let fontName = "Cubic_11"
    static func size(_ s: CGFloat) -> CGFloat { s > 16 ? 22 : 11 }
    static func font(_ s: CGFloat) -> Font { .custom(fontName, fixedSize: size(s)) }
    static func nsFont(_ s: CGFloat) -> NSFont {
        NSFont(name: fontName, size: size(s)) ?? .monospacedSystemFont(ofSize: s, weight: .regular)
    }

    // the desktop theme's bar colours: KEY=0xffRRGGBB
    static let fg = themeColor("BAR_FG") ?? .white
    static let bg = themeColor("BAR_BG") ?? .black

    private static func themeColor(_ key: String) -> Color? {
        let path = NSHomeDirectory() + "/.config/theme/sketchybar.sh"
        guard let text = try? String(contentsOfFile: path, encoding: .utf8),
              let line = text.split(separator: "\\n").first(where: { $0.hasPrefix(key + "=0x") }),
              let v = UInt32(line.dropFirst(key.count + 5), radix: 16) else { return nil }   // after "=0xff"
        return Color(red: Double(v >> 16 & 0xff) / 255, green: Double(v >> 8 & 0xff) / 255,
                     blue: Double(v & 0xff) / 255)
    }
}
'''

SIZE = r"([^,()]+?(?:\([^()]*\))?)"                     # 11, fontSize, type.body, max(a) ...
STYLE_SIZES = {"caption2": 10, "caption": 10, "footnote": 11, "subheadline": 11, "callout": 12, "body": 13,
               "headline": 13, "title3": 15, "title2": 17, "title": 22, "largeTitle": 26}
STYLES = "|".join(sorted(STYLE_SIZES, key=len, reverse=True))
FONT_PATTERNS = [
    (re.compile(r"(?:Font)?\.system\(size:\s*" + SIZE + r"\s*(?:,\s*weight:\s*[^,()]+)?\s*(?:,\s*design:\s*[^,()]+)?\)"),
     r"PixelStyle.font(\1)"),
    (re.compile(r"(?:Font)?\.system\(\.(" + STYLES + r")\s*(?:,\s*design:\s*[^,()]+)?\s*(?:,\s*weight:\s*[^,()]+)?\)"),
     lambda m: f"PixelStyle.font({STYLE_SIZES[m[1]]})"),
    (re.compile(r"\.font\(\.(" + STYLES + r")\)"), lambda m: f".font(PixelStyle.font({STYLE_SIZES[m[1]]}))"),
    (re.compile(r"NSFont\.(?:monospacedSystemFont|systemFont|boldSystemFont)\(ofSize:\s*" + SIZE
                + r"(?:\s*,\s*weight:\s*[^,()]+)?\)"), r"PixelStyle.nsFont(\1)"),
]
# the island: black panel -> theme bg; white and greys (white at some level, on black) -> theme fg.
# NSColor.white (letters on coloured avatars) and the mascots' own colours stay.
ISLAND = {"NotchPanelView.swift", "MarkdownReplyView.swift", "AgentTaskProgressView.swift",
          "SessionListOrdering.swift", "NotchAnimation.swift"}
COLOR_PATTERNS = [
    (re.compile(r"\.fill\(\.black\)"), ".fill(PixelStyle.bg)"),
    (re.compile(r"(?<![\w.])(?:Color)?\.white\b"), "PixelStyle.fg"),
    (re.compile(r"\bColor\(white:\s*([\d.]+)\)"), r"PixelStyle.fg.opacity(\1)"),
]


def sub_all(text: str, patterns: list) -> tuple[str, int]:
    count = 0
    for pat, rep in patterns:
        text, n = pat.subn(rep, text)
        count += n
    return text, count


fonts = colors = 0
for f in sorted(APP.glob("*.swift")):
    text = f.read_text()
    text, n = sub_all(text, FONT_PATTERNS)
    fonts += n
    if f.name in ISLAND:
        text, n = sub_all(text, COLOR_PATTERNS)
        colors += n
    f.write_text(text)
(APP / "PixelStyle.swift").write_text(PIXEL_STYLE)

# no self-update: Sparkle would install the upstream build over this one
plist = str(SRC / "Info.plist")
subprocess.run(["/usr/libexec/PlistBuddy", "-c", "Set :SUEnableAutomaticChecks false", plist], check=True)
subprocess.run(["/usr/libexec/PlistBuddy", "-c", "Delete :SUFeedURL", plist], check=True)

# the icon catalog needs Xcode's actool; carry on without it (AppIcon.icns is copied anyway)
build = SRC / "build.sh"
text = build.read_text()
text, n = re.subn(r'(\n\s*"\$ICON_SOURCE")\n', r'\1 || echo "actool needs Xcode: using AppIcon.icns only"\n', text)
if n != 1:
    sys.exit("codeisland-pixel: build.sh icon step not found, upstream changed")
build.write_text(text)

left = subprocess.run(["grep", "-rcE", r"\.system\(size|SystemFont\(ofSize|\.font\(\.(" + STYLES + r")\)", str(APP)],
                      capture_output=True, text=True).stdout
missed = sum(int(line.rsplit(":", 1)[1]) for line in left.splitlines() if line.rsplit(":", 1)[1] != "0")
print(f"codeisland-pixel: {fonts} font calls, {colors} island colours patched; {missed} font calls left as system font")
