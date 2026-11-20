# Fedora KDE Plasma dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for my personal
Fedora KDE Plasma installation.

## What is included

| Source                                                       | Installed location                                  | Purpose                                                                                                                |
| ------------------------------------------------------------ | --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `dot_zprofile`                                               | `~/.zprofile`                                       | Login-shell PATH additions, including JetBrains Toolbox.                                                               |
| `dot_config/kitty/`                                          | `~/.config/kitty/`                                  | Kitty configuration and the Ayu, Flatland and Espresso themes. Ayu is selected by default.                             |
| `dot_config/private_plasma-org.kde.plasma.desktop-appletsrc` | `~/.config/plasma-org.kde.plasma.desktop-appletsrc` | Plasma panel layout, widgets, launchers, and wallpaper references (machine-specific state stripped; see below).        |
| `dot_config/private_kactivitymanagerdrc`                    | `~/.config/kactivitymanagerdrc`                     | Plasma activity ID, so the desktop settings in `appletsrc` attach to the current activity.                              |
| `dot_local/share/fonts/`                                     | `~/.local/share/fonts/`                             | FantasqueSansM Nerd Font (kitty) and Inter (KDE UI and panel clock).                                                   |
| `dot_local/share/aurorae/`                                   | `~/.local/share/aurorae/`                           | Orchis window-decoration themes.                                                                                       |
| `dot_local/share/color-schemes/`                             | `~/.local/share/color-schemes/`                     | Orchis and Orchis Dark colour schemes.                                                                                 |
| `dot_local/share/icons/Reversal/`                            | `~/.local/share/icons/Reversal/`                    | Reversal icon theme.                                                                                                   |
| `dot_local/share/plasma/desktoptheme/`                       | `~/.local/share/plasma/desktoptheme/`               | Orchis Plasma desktop theme.                                                                                           |
| `dot_local/share/plasma/look-and-feel/`                      | `~/.local/share/plasma/look-and-feel/`              | Orchis global theme / look-and-feel package.                                                                           |
| `dot_local/share/plasma/plasmoids/`                          | `~/.local/share/plasma/plasmoids/`                  | Bundled Plasma widgets: KdeControlStation, Quick Clock, Panel Colorizer, Shutdown or Switch, and Plasma Music Toolbar. |

## Install on a new Fedora KDE system

Log in to the Plasma desktop once, open a terminal, and run:

```sh
sudo dnf install chezmoi
chezmoi init --apply https://github.com/ryanwoong/dotfiles.git
```

Enter your sudo password when asked. That one `chezmoi` command:

1. **Installs packages** (`.chezmoiscripts/run_once_before_10-install-packages.sh`,
   once per machine): kitty, python3, the Vinyl launcher from the
   `ekaaty/kde-extras` COPR, VS Code, SourceGit, and Obsidian and Discord from
   Flathub.
2. **Stops Plasma** (`run_onchange_before_20-stop-plasma`) so it cannot
   overwrite the new panel layout when it exits.
3. **Writes the files**: kitty, `.zprofile`, the Plasma panel layout, the
   activity ID, fonts, and the Orchis/Reversal themes and widgets.
4. **Selects the theme** (`run_onchange_after_20-apply-theme.sh`): Orchis
   global theme, colours, Plasma style and window decorations, Reversal icons
   and Inter UI fonts.
5. **Starts Plasma again** (`run_onchange_after_90-start-plasma`).
6. **Enables the git pre-commit hook** for this repository (once per machine).

Log out and back in once afterwards so every application picks up the fonts and
theme.

To preview first instead, run `chezmoi init https://github.com/ryanwoong/dotfiles.git`
and `chezmoi diff`, then `chezmoi apply -v`.

### Not included

- **Wallpapers**: the panels expect `~/Pictures/wallpapers/`, which is too large
  for GitHub (the images are 130 to 160 MB each). Copy that folder over, or
  pick a wallpaper in System Settings.
- **Mouse, keyboard and touchpad settings**: tied to specific devices, so
  configure them per machine (see `kcminputrc` below).
- **Extra monitors**: the layout has panels for three screens. On a machine
  with fewer screens only the panels for the connected screens appear.

### Running `chezmoi apply` on the original machine

The scripts also run on the computer this repo came from. The package step
will ask for sudo (everything is already installed), and Plasma restarts with
the panel layout **from the repository**. If you changed the panels since the
last commit, save those changes first with
`chezmoi re-add ~/.config/plasma-org.kde.plasma.desktop-appletsrc` and commit
them, or they are lost.

## Keeping machine-specific state out of the repository

Plasma constantly writes per-machine state into
`plasma-org.kde.plasma.desktop-appletsrc`: desktop icon positions (which
include the names of every file on the desktop), the file-to-screen mapping,
and remembered dialog/popup sizes. `.scripts/strip-plasma-machine-keys.py`
removes it, and runs automatically in two places:

- **chezmoi hooks**: `.chezmoi.toml.tmpl` runs the script after every
  `chezmoi add` and `chezmoi re-add`. `chezmoi init` generates the config that
  contains them (run it again after changing the template).
- **git pre-commit hook**: `.githooks/pre-commit` strips the file again before
  every commit. `chezmoi apply` enables it once per machine.

`~/.config/kcminputrc` is listed in `.chezmoiignore` because its settings are
tied to specific mice, keyboards and touchpads by USB ID.

Because this machine's live `appletsrc` still has its icon positions,
`chezmoi diff` will always show those lines as differences here. Applying the
file on this machine resets desktop icon positions.

## Updating and managing the files

To pull newer versions from the remote repository and apply them:

```sh
chezmoi update -v
```

To change a managed file on the current computer and save that change back to
the chezmoi source directory:

```sh
chezmoi edit ~/.config/kitty/kitty.conf
chezmoi apply
cd "$(chezmoi source-path)"
git status
```

For a desktop-only trial, apply an individual target instead of the whole
repository, for example:

```sh
chezmoi apply ~/.config/kitty/kitty.conf
```
