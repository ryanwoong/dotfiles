#!/bin/sh
# Install the packages and apps this config depends on. Runs once per machine,
# before chezmoi writes any files. Needs sudo; skipped on non-Fedora systems.
set -u

if ! command -v dnf >/dev/null 2>&1; then
    echo "install-packages: dnf not found, skipping (this setup targets Fedora KDE)"
    exit 0
fi

echo "==> Installing base packages (sudo needed)"
# Vinyl launcher, the start menu on both bottom panels.
sudo dnf -y copr enable ekaaty/kde-extras
sudo dnf -y install git python3 kitty flatpak vinyl-theme

echo "==> Installing panel launcher apps"
# Visual Studio Code (Microsoft's rpm repository).
if ! rpm -q code >/dev/null 2>&1; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
    sudo dnf -y install code
fi

# SourceGit (latest x86_64 rpm from GitHub releases).
if ! rpm -q sourcegit >/dev/null 2>&1; then
    url=$(curl -fsSL https://api.github.com/repos/sourcegit-scm/sourcegit/releases/latest \
        | grep -o 'https://[^"]*x86_64\.rpm' | head -n 1)
    if [ -n "$url" ]; then
        sudo dnf -y install "$url"
    else
        echo "install-packages: could not find a SourceGit rpm; install it manually"
    fi
fi

# Obsidian and Discord from Flathub.
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y --noninteractive flathub md.obsidian.Obsidian com.discordapp.Discord

# Never fail the whole `chezmoi apply` because one app could not be installed.
exit 0
