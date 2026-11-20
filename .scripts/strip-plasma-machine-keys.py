#!/usr/bin/env python3
"""Strip machine-specific noise from plasma-org.kde.plasma.desktop-appletsrc.

Plasma constantly rewrites this file with state that only makes sense on the
computer it came from: desktop icon positions (which also leak the names of
files on the desktop), per-resolution icon geometry, the desktop-file to screen
mapping, and remembered sizes of settings dialogs and popups. None of it is
needed to reproduce the panel/widget setup on another machine.

Usage:
    strip-plasma-machine-keys.py FILE...   # rewrite files in place
    strip-plasma-machine-keys.py < in > out
Exit status is 0; files that are already clean are left untouched.
"""

import re
import sys

# Keys removed wherever they appear.
DROP_KEYS = {
    "changedPositions",  # desktop icon positions
    "positions",  # desktop icon positions
    "lastResolution",
    "ToolBoxButtonX",
    "ToolBoxButtonY",
    "popupHeight",
    "popupWidth",
}
DROP_KEY_PREFIXES = ("ItemGeometries",)  # per-resolution icon geometry

# Whole sections removed.
DROP_SECTION_RE = re.compile(r"^\[ScreenMapping\]$|\[ConfigDialog\]$")

# Individual key=value pairs removed (broken paths copied from theme defaults).
DROP_LINE_RE = re.compile(r"^SlidePaths=/home/vince/")

SECTION_RE = re.compile(r"^\[.*\]$")


def strip(text: str) -> str:
    sections = []  # list of (header, [lines])
    header, body = None, []
    for line in text.splitlines():
        if SECTION_RE.match(line):
            sections.append((header, body))
            header, body = line, []
        else:
            body.append(line)
    sections.append((header, body))

    out = []
    for header, body in sections:
        if header is not None and DROP_SECTION_RE.search(header):
            continue
        kept = []
        for line in body:
            key = line.split("=", 1)[0] if "=" in line else None
            if key is not None and (
                key in DROP_KEYS or key.startswith(DROP_KEY_PREFIXES)
            ):
                continue
            if DROP_LINE_RE.match(line):
                continue
            kept.append(line)
        if not any(l.strip() for l in kept):
            continue  # section (or the preamble before the first one) is empty
        if header is not None:
            out.append(header)
        # Trim surrounding blank lines; sections are separated by one blank line.
        while kept and not kept[0].strip():
            kept.pop(0)
        while kept and not kept[-1].strip():
            kept.pop()
        out.extend(kept)
        out.append("")
    while out and not out[-1].strip():
        out.pop()
    return "\n".join(out) + "\n"


def main() -> int:
    if len(sys.argv) == 1:
        sys.stdout.write(strip(sys.stdin.read()))
        return 0
    for path in sys.argv[1:]:
        try:
            with open(path, encoding="utf-8") as f:
                original = f.read()
        except FileNotFoundError:
            continue
        cleaned = strip(original)
        if cleaned != original:
            with open(path, "w", encoding="utf-8") as f:
                f.write(cleaned)
            print(f"stripped machine-specific keys from {path}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
