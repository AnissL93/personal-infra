#!/usr/bin/env python3
"""Regenerate the GitHub Pages data: docs/data.js, docs/thumbs/*.webp, docs/fonts/*.png, docs/keymap.svg.

usage: docs/build.py      (run after adding themes or scripts, then commit docs/)
Wallpapers are read from ~/.local/share/wallpapers (`theme` downloads them there), fonts from ~/System/assets.
"""
import html
import json
import os
import re
import shutil
import sys
from importlib.machinery import SourceFileLoader

from PIL import Image

sys.dont_write_bytecode = True
ROOT = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
DOCS = os.path.join(ROOT, "docs")
THEMES = os.path.join(ROOT, "dotfiles", "themes")
WALLS = os.path.expanduser("~/.local/share/wallpapers")
FONTS = os.path.expanduser("~/System/assets/fonts")   # clone of github.com/AnissL93/assets
theme = SourceFileLoader("theme", os.path.join(THEMES, "theme")).load_module()

KEYS = ["name", "mode", "bg", "bg_alt", "bg_hl", "sel", "dim", "mid", "fg", "bright", "accent", "accent_fg",
        "bar", "bar_fg", "border", "comment", "string", "number", "keyword", "function", "type", "punct",
        "err", "warn", "ok"] + [f"color{i}" for i in range(16)]


def blurb(path):
    """First comment paragraph of a file, minus shebang, usage and colour-maths notes."""
    out = []
    for line in open(path, errors="replace").readlines()[:12]:
        s = line.strip()
        if s.startswith("#!") or (not out and s in ("", "#")):
            continue
        m = re.match(r"#+\s?(.*)", s) if s.startswith("#") else None
        if not m or not m.group(1) or re.match(r"(usage|design|color\d)", m.group(1), re.I):
            break
        out.append(m.group(1))
    return " ".join(out)


def thumb(wall):
    """640px webp of a wallpaper; returns its docs-relative path, or None if the wallpaper is missing."""
    src, rel = os.path.join(WALLS, wall), f"thumbs/{wall.rsplit('.', 1)[0]}.webp"
    dst = os.path.join(DOCS, rel)
    if not os.path.exists(src):
        print(f"missing wallpaper {wall}", file=sys.stderr)
        return None
    if not os.path.exists(dst) or os.path.getmtime(dst) < os.path.getmtime(src):
        im = Image.open(src).convert("RGB")
        im.thumbnail((640, 640))
        im.save(dst, "WEBP", quality=72)
    return rel


def themes():
    out = []
    for n in theme.themes():
        t = theme.load(n)
        wall = t.get("wallpaper_2560")
        out.append({"id": n, **{k: t[k] for k in KEYS if k in t},
                    "family": n.split("-")[0], "pixel": n.endswith("-pixel"),
                    "about": blurb(os.path.join(THEMES, n + ".conf")),
                    "wall": wall, "wall_wide": t.get("wallpaper_3440"), "thumb": wall and thumb(wall)})
    return out


def scripts(rel_dir, repo, repo_dir):
    d = os.path.join(ROOT, rel_dir)
    code = re.compile(r"[=;]|shellcheck")   # commented-out code or data, not a description
    return [{"name": f, "about": "" if code.search(b := blurb(os.path.join(d, f))) else b,
             "url": f"https://github.com/AnissL93/{repo}/blob/main/{repo_dir}/{f}"}
            for f in sorted(os.listdir(d)) if os.path.isfile(os.path.join(d, f)) and not f.startswith(".")]


def md(cell):
    """Inline markdown of a table cell -> HTML: `code` and [text](url)."""
    cell = html.escape(cell, quote=False)
    cell = re.sub(r"`([^`]+)`", r"<code>\1</code>", cell)
    cell = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", cell)
    return re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', cell)


def apps():
    """SOFTWARE.md tables -> {"linux"|"macos"|"all": [[section, rows]]}. An `LM` row whose
    "Installed by" is "linux way / mac way" shows only its own half on the per-OS lists."""
    out, section = {"linux": [], "macos": [], "all": []}, None
    for line in open(os.path.join(ROOT, "SOFTWARE.md")):
        if line.startswith("## "):
            section = line[3:].strip()
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) != 6 or cells[1] not in ("L", "M", "LM"):
            continue
        app, pf, inst, conf, themed, notes = cells
        halves = inst.split(" / ") if pf == "LM" and inst.count(" / ") == 1 else [inst, inst]
        for os_, flag, how in (("linux", "L", halves[0]), ("macos", "M", halves[-1]), ("all", "", inst)):
            if flag not in pf:
                continue
            name = section if os_ == "all" or not section.startswith("Desktop") else "Desktop"
            if not out[os_] or out[os_][-1][0] != name:
                out[os_].append([name, []])
            out[os_][-1][1].append({"app": md(app), "pf": pf, "how": md(how), "config": md(conf),
                                    "themed": bool(themed), "notes": md(notes)})
    return out


def fonts():
    """Rows of the assets repo's fonts/README.md table, with their preview copied into docs/fonts/."""
    out = []
    for line in open(os.path.join(FONTS, "README.md")):
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) != 5 or not cells[0].startswith("`"):
            continue
        folder = cells[0].strip("`/")
        shutil.copy(os.path.join(FONTS, "previews", folder + ".png"), os.path.join(DOCS, "fonts", folder + ".png"))
        out.append({"folder": folder, "family": cells[1], "used": md(cells[2]), "original": md(cells[3]),
                    "licence": md(cells[4]), "preview": f"fonts/{folder}.png",
                    "files": f"https://github.com/AnissL93/assets/tree/main/fonts/{folder}"})
    return out


if __name__ == "__main__":
    os.makedirs(os.path.join(DOCS, "fonts"), exist_ok=True)
    os.makedirs(os.path.join(DOCS, "thumbs"), exist_ok=True)
    shutil.copy(os.path.join(ROOT, "keymap", "keymap.svg"), os.path.join(DOCS, "keymap.svg"))
    data = {"themes": themes(), "fonts": fonts(), "apps": apps(), "scripts": {
        "desktop/linux/scripts": scripts("desktop/linux/scripts", "desktop", "linux/scripts"),
        "desktop/linux/bin": scripts("desktop/linux/bin", "desktop", "linux/bin"),
        "desktop/mac/bin": scripts("desktop/mac/bin", "desktop", "mac/bin"),
        "builds": scripts("builds", "personal-infra", "builds"),
    }}
    with open(os.path.join(DOCS, "data.js"), "w") as f:
        f.write("window.DATA = " + json.dumps(data, ensure_ascii=False, separators=(",", ":")) + ";\n")
    print(f"{len(data['themes'])} themes, {len(data['fonts'])} fonts, {sum(map(len, data['scripts'].values()))} scripts")
