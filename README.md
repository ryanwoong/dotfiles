# Fedora KDE Plasma dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for a my personal
Fedora KDE Plasma installation.

## What is included

| Source                                                       | Installed location                                  | Purpose                                                                                                                |
| ------------------------------------------------------------ | --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `dot_zprofile`                                               | `~/.zprofile`                                       | Login-shell PATH additions, including JetBrains Toolbox.                                                               |
| `dot_config/kitty/`                                          | `~/.config/kitty/`                                  | Kitty configuration and the Ayu, Flatland and Espresso themes. Ayu is selected by default.                             |
| `dot_config/private_plasma-org.kde.plasma.desktop-appletsrc` | `~/.config/plasma-org.kde.plasma.desktop-appletsrc` | Plasma panel layout, widgets, launchers, and wallpaper references (machine-specific state stripped; see below).                                             |
| `dot_local/share/aurorae/`                                   | `~/.local/share/aurorae/`                           | Orchis window-decoration themes.                                                                                       |
| `dot_local/share/color-schemes/`                             | `~/.local/share/color-schemes/`                     | Orchis and Orchis Dark colour schemes.                                                                                 |
| `dot_local/share/icons/Reversal/`                            | `~/.local/share/icons/Reversal/`                    | Reversal icon theme.                                                                                                   |
| `dot_local/share/plasma/desktoptheme/`                       | `~/.local/share/plasma/desktoptheme/`               | Orchis Plasma desktop theme.                                                                                           |
| `dot_local/share/plasma/look-and-feel/`                      | `~/.local/share/plasma/look-and-feel/`              | Orchis global theme / look-and-feel package.                                                                           |
| `dot_local/share/plasma/plasmoids/`                          | `~/.local/share/plasma/plasmoids/`                  | Bundled Plasma widgets: KdeControlStation, Quick Clock, Panel Colorizer, Shutdown or Switch, and Plasma Music Toolbar. |

## Install on a new Fedora KDE system

Install chezmoi and the basic applications first:

```sh
sudo dnf install chezmoi git zsh fzf lsd kitty
```

Preview the changes before writing anything. This clones the repository into
chezmoi's source directory and shows the changes that would be made:

```sh
chezmoi init https://github.com/ryanwoong/dotfiles.git
chezmoi diff
```

If the diff looks right, apply the files:

```sh
chezmoi apply -v
```

For a one-command install, use:

```sh
chezmoi init --apply https://github.com/ryanwoong/dotfiles.git
```

Log out and back in afterwards, or restart Plasma with `kquitapp6 plasmashell
&& kstart plasmashell`, so KDE reloads the new configuration.

## Important first-time checks

The Plasma configuration is a snapshot of one machine's panels. Before
applying it, review the output of `chezmoi diff`, especially if you already
have a customized desktop. `plasma-org.kde.plasma.desktop-appletsrc` still
contains:

- Panels and desktops for three screens (`lastScreen=0`, `1`, `2`).
- The Plasma activity ID of the original install (`activityId=`).
- Absolute wallpaper paths under `~/Pictures/wallpapers/`, which are not part
  of this repository, and app launchers for VS Code, Obsidian, Discord and
  SourceGit.

Kitty is configured for `FantasqueSansM Nerd Font Mono Bold`; install that
Nerd Font or choose another font in `~/.config/kitty/kitty.conf`.

## Keeping machine-specific state out of the repository

Plasma constantly writes per-machine state into
`plasma-org.kde.plasma.desktop-appletsrc`: desktop icon positions (which
include the names of every file on the desktop), the file-to-screen mapping,
and remembered dialog/popup sizes. `.scripts/strip-plasma-machine-keys.py`
removes it, and runs automatically in two places:

- **chezmoi hooks**: `.chezmoi.toml.tmpl` runs the script after every
  `chezmoi add` and `chezmoi re-add`. Run `chezmoi init` once after cloning (or
  after changing the template) to generate `~/.config/chezmoi/chezmoi.toml`.
- **git pre-commit hook**: `.githooks/pre-commit` strips the file again before
  every commit. Enable it once per clone with
  `git -C "$(chezmoi source-path)" config core.hooksPath .githooks`.

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
