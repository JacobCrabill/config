" ============================================================================
" NeoVim Config File
" ----------------------------------------------------------------------------
" Location: ~/.config/nvim/init.vim
" Requires: NeoVim >= v0.9 - e.g. [v0.7.2](https://github.com/neovim/neovim/releases/tag/v0.9.4)
"
" First-Time Usage:
" 1. Install a [Nerd Font](https://github.com/ryanoasis/nerd-fonts#option-3-install-script)
" 2. Install python3 support: 'pip3 install neovim pynvim'
" 3. Install [vim-plug](https://github.com/junegunn/vim-plug)
" 4. Call: `:PlugInstall`
" 5. Profit
" ============================================================================
" Source our plugin include file
:runtime plug.vim

scriptencoding utf-8 " Enable utf-8 in the rest of this script

" Source the rest of our setup files
:runtime lua/init.lua
