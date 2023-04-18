#!/usr/bin/env bash
# =================================================================================
# Custom Aliases
# =================================================================================

# Allow colors in 'less'
alias less='/usr/bin/less -r'

# Trim the BASH prompt to a max of 4 directories
export PROMPT_DIRTRIM=4

# --------------------------------------------------------------------------------
# Git-related aliases
# --------------------------------------------------------------------------------
# Update all submodules
alias gitsub='git submodule sync --recursive && git submodule update --init --recursive'

# 'Pretty' print of Git log
alias gitlogp='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue) <%an> %Creset" --abbrev-commit'
alias gitlog='git log'

# List all remotes
alias gitremote='git config --list | grep "remote.*url"'

# Compact summary of current changes
alias gitshow='git show --compact-summary'

alias grc='git rebase --continue'

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

# --------------------------------------------------------------------------------
# Miscellaneous
# --------------------------------------------------------------------------------
# Equivalent to double-clicking on a file
alias xo='xdg-open'

# Connect to the Shield office VPN
alias cisco-vpn='/opt/cisco/anyconnect/bin/vpnui' # sdoffice.shield.ai

# Pipe text to system clipboard
alias clip='xclip -selection clipboard'

# Copy the most recent Git commit hash to the system clipboard
alias cliphash='git log | head -n 1 | cut -d " " -f 2 | xclip -selection clipboard'

# Run clang-format on all .h / .cpp files under the current directory
alias do-clang-format='find . \( -name *.h -o -name *.cpp \) -type f -exec clang-format-10 -i {} \;'

# Enter my Sphinx build environment
alias sphinx='source /home/jacob/.sphinx-env/bin/activate'

# VBAT Commander App
alias vbc='/home/jacob/.local/bin/HMCWebCommander-linux-x86_64-1.1.47.AppImage'

# Commonly used directories
alias cdnv='cd ~/.config/nvim/'
alias cde='cd ~/Codes/EdgeAI/'
alias cdv='cd ~/Codes/vbats/'
alias cdc='cd ~/Codes/EdgeAI/src/extern/CommonTaskBehaviorFoundations/'
alias cdb='cd ~/Codes/EdgeAI/src/subsystems/behavior_subsystem/'
alias cdx='cd ~/Codes/EdgeAI/src/subsystems/executive_manager/'
alias cda='cd ~/Codes/EdgeAI/src/subsystems/automode/'
alias cdee='cd ~/Codes/EdgeAI/src/subsystems/executive_manager/'
alias coco='cd ~/Codes/coco/ && nvim .'

alias cdros='cd /home/jacob/.cache/bazel/_bazel_jacob/68f101af79500e6e660242ddfdc0b6a2/external/'

# --------------------------------------------------------------------------------
# Python Virtual Environment Management
# --------------------------------------------------------------------------------
# Source (creating if needed) a local Python virtual environment, or one from PYTHON_VENV_HOME
venv() {
    PYTHON_VENV_HOME=${HOME}/python-venvs

    if [ $# -gt 1 ]; then
        echo "Expected 0 or 1 arguments"
        echo "usage:"
        echo "\tvenv # Sources local .venv"
        echo "\tvenv venv_name # Sources venv at $PYTHON_VENV_HOME/venv"
        return
    fi

    if [ -n "${VIRTUAL_ENV}" ]; then
      echo "Deactivating current Python virtual environment"
      unset VIRTUAL_ENV & deactivate
    fi

    if [ $# == 0 ]; then
        if [ ! -d .venv ]; then
            echo "Creating Python virtual environment in current directory at .venv"
            python3 -m venv .venv
        fi
        source .venv/bin/activate

    elif [ $# == 1 ]; then
        VENV_DIR=${PYTHON_VENV_HOME}/$1
        if [ ! -d ${VENV_DIR} ]; then
            echo "Creating Python virtual environment at ${VENV_DIR}"
            python3 -m venv ${VENV_DIR}
        fi
        source ${VENV_DIR}/bin/activate
    fi
}
