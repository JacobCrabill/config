#!/usr/bin/env bash
# =================================================================================
# Custom Aliases
# =================================================================================

# Allow colors in 'less'
alias less='/usr/bin/less -r'

# Trim the BASH prompt to a max of 4 directories
export PROMPT_DIRTRIM=4

# Equivalent of double-clicking on a file
alias xo='xdg-open'

# Update all submodules
alias gitsub='git submodule sync --recursive && git submodule update --init --recursive'

# 'Pretty' print of Git log
alias gitlogp='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue) <%an> %Creset" --abbrev-commit'
alias gitlog='git log'

# List all remotes
alias gitremote='git config --list | grep "remote.*url"'

# Source a local Python virtual environment
# alias venv='source .venv/bin/activate'
venv() {
    if [ ! -d .venv ]; then
        python3 -m venv .venv
    fi
    source .venv/bin/activate
}

# Connect to the Shield office VPN
alias cisco-vpn='/opt/cisco/anyconnect/bin/vpnui' # sdoffice.shield.ai

alias nvim=/home/jacob/.local/bin/nvim.appimage

alias cde='cd ~/Codes/EdgeAI/'
alias cdb='cd ~/Codes/EdgeAI/src/subsystems/behavior_subsystem/'
alias cdee='cd ~/Codes/EdgeAI/src/subsystems/executive_manager/'

alias cdros='cd /home/jacob/.cache/bazel/_bazel_jacob/68f101af79500e6e660242ddfdc0b6a2/external/'

alias gitshow='git show --compact-summary '

alias clip='xclip -selection clipboard'
alias cliphash='git log | head -n 1 | cut -d " " -f 2 | xclip -selection clipboard'

# Git blame of a directory
blamedir()
{
  FILE_W=35;
  BLAME_FORMAT="%C(auto) %h %ad %C(dim white)%an %C(auto)%s";

  for f in $1*;
  do
    git log -n 10 --pretty="$(printf "%-*s" $FILE_W "$f") $BLAME_FORMAT" -- $f
  done;
};

