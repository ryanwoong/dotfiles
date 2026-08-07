# Fedora KDE Plasma dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for a my personal
Fedora KDE Plasma installation.

## What is included

| Source                                                       | Installed location                                  | Purpose                                                                                                                |
| ------------------------------------------------------------ | --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `dot_zshrc`                                                  | `~/.zshrc`                                          | Zsh, Oh My Zsh, history, aliases, FZF, Bun, LM Studio, and SDKMAN settings.                                            |
| `dot_zprofile`                                               | `~/.zprofile`                                       | Login-shell PATH additions, including JetBrains Toolbox.                                                               |
| `dot_config/kitty/`                                          | `~/.config/kitty/`                                  | Kitty configuration and the Flatland and Espresso themes. Flatland is selected by default.                             |
| `dot_config/private_kdeglobals`                              | `~/.config/kdeglobals`                              | KDE appearance, colours, fonts, icons, and general UI preferences.                                                     |
| `dot_config/private_kwinrc`                                  | `~/.config/kwinrc`                                  | KWin window-manager settings, including tiling layouts and XWayland scale.                                             |
| `dot_config/private_kcminputrc`                              | `~/.config/kcminputrc`                              | Libinput mouse and keyboard preferences.                                                                               |
| `dot_config/private_plasma-org.kde.plasma.desktop-appletsrc` | `~/.config/plasma-org.kde.plasma.desktop-appletsrc` | Plasma desktop/panel layout, widgets, launchers, and wallpaper references.                                             |
| `dot_config/private_plasmarc`                                | `~/.config/plasmarc`                                | Plasma wallpaper history and preferences.                                                                              |
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

The Plasma configuration is intentionally a snapshot of one machine. Before
applying it, review the output of `chezmoi diff`, especially if you already
have a customized desktop. It contains:

- Hardware-specific input-device sections in `kcminputrc`.
- Display scaling and virtual-desktop IDs in `kwinrc`.
- Panel layout, application launchers, desktop icon positions, and absolute
  wallpaper paths in `plasma-org.kde.plasma.desktop-appletsrc` and `plasmarc`.

The Zsh configuration expects Oh My Zsh, the `zsh-autosuggestions` and
`zsh-syntax-highlighting` plugins, and several optional tools (`bun`,
SDKMAN, LM Studio, and Android platform tools). Install the tools you want, or
comment out their corresponding lines in `~/.zshrc` after applying.

Kitty is configured for `FantasqueSansM Nerd Font Mono Bold`; install that
Nerd Font or choose another font in `~/.config/kitty/kitty.conf`.

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
