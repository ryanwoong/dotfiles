#!/bin/sh
# Select the themes and fonts this repo installs (Orchis global theme, colours,
# Plasma style and window decorations; Reversal icons; Inter UI fonts).
# Re-runs whenever this script changes.
set -u

echo "==> Refreshing font cache"
fc-cache -f >/dev/null 2>&1 || true

echo "==> Applying Orchis / Reversal theme"
kw() { kwriteconfig6 "$@" 2>/dev/null || true; }

kw --file kdeglobals --group KDE --key LookAndFeelPackage com.github.vinceliuice.Orchis
kw --file kdeglobals --group KDE --key widgetStyle Breeze

# plasma-apply-colorscheme also copies the scheme's colours into kdeglobals.
plasma-apply-colorscheme Orchis >/dev/null 2>&1 ||
    kw --file kdeglobals --group General --key ColorScheme Orchis
plasma-apply-desktoptheme Orchis >/dev/null 2>&1 ||
    kw --file plasmarc --group Theme --key name Orchis
/usr/libexec/plasma-changeicons Reversal >/dev/null 2>&1 ||
    kw --file kdeglobals --group Icons --key Theme Reversal

kw --file kwinrc --group org.kde.kdecoration2 --key library org.kde.kwin.aurorae.v2
kw --file kwinrc --group org.kde.kdecoration2 --key theme __aurorae__svg__Orchis

echo "==> Setting Inter UI fonts"
kw --file kdeglobals --group General --key font "Inter 24pt,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group General --key menuFont "Inter 24pt,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group General --key fixed "Inter 18pt,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group General --key smallestReadableFont "Inter 18pt,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group General --key toolBarFont "Inter 18pt,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group WM --key activeFont "Inter 24pt,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

# Ask KWin to reload decorations if it is running.
for q in qdbus6 qdbus-qt6 qdbus; do
    if command -v "$q" >/dev/null 2>&1; then
        "$q" org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
        break
    fi
done
exit 0
