# config

Useful config files for setting up new machines

## Organization

The config files are grouped by category:

- `nvim` holds the contents of `~/.config/nvim/` for a complete Neovim config
- `kitty` holds the contents of `~/.config/kitty/` for a complete Kitty terminal config
- `bash` holds various useful scripts like `.bashrc` and the like, for various in-terminal workflows
- `gnome` holds configuration settings for the Gnome desktop environment, like keyboard shortcuts

## Misc. Desktop Setup Notes

- Mouse acceleration (mouse sensitivity suddenly seems sluggish) --> In Gnome Tweaks, set mouse
  "Acceleration Profile" to "Flat"
- Window tiling manager: Install Pop!OS tiling manager
- Remving menu bar / title bar from terminal: `gsettings set ... @mb false`; Install Unite Gnome
  plugin
- PopOS shell: Modify JSON / XML files to change default keyboard shortcuts (by default,
  '<Super><Arrow Keys>' is used for tiling; changed by adding '<Ctrl>'
- Add Workspace Matrix Gnome extension
