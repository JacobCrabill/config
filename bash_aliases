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

# Pipe text to system clipboard
alias clip='xclip -selection clipboard'

# Copy the most recent Git commit hash to the system clipboard
alias cliphash='git log | head -n 1 | cut -d " " -f 2 | xclip -selection clipboard'

# Run clang-format on all .h / .cpp files under the current directory
alias do-clang-format='find . \( -name *.h -o -name *.cpp \) -type f -exec clang-format-10 -i {} \;'

# --------------------------------------------------------------------------------
# Python Virtual Environment Management
# --------------------------------------------------------------------------------
# Source (creating if needed) a local Python virtual environment, or one from PYTHON_VENV_HOME
venv() {
    PYTHON_VENV_HOME=${HOME}/python-venvs

    if [ $# -gt 1 ]; then
        echo "Expected 0 or 1 arguments"
        echo "usage:"
        echo -e "\tvenv           # Sources local '.venv'"
        echo -e "\tvenv venv_name # Sources venv at '${PYTHON_VENV_HOME}/venv_name'"
        return
    fi

    if [ -n "${VIRTUAL_ENV}" ]; then
      echo "Deactivating current Python virtual environment"
      unset VIRTUAL_ENV & deactivate
    fi

    if [ $# == 0 ]; then
        if [ ! -d .venv ]; then
            echo jw
            read -p "Creating Python virtual environment in current directory at .venv - Continue? [y/N] " yn
            case $yn in
                [Yy]* ) ;; # Continue
                * ) echo "Cancelling"; return;;
            esac
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

# Autocomplete for the 'venv' function
__venv_complete() {
    PYTHON_VENV_HOME=${HOME}/python-venvs
    if [ "$COMP_CWORD" -ne 1 ]; then
        return 0
    fi
    local comps=""

    for file in ${PYTHON_VENV_HOME}/*
    do
        if [ -d $file ]; then
            comps="${comps} $(basename $file)"
        fi
    done
    COMPREPLY=( $(compgen -W '$comps' -- ${COMP_WORDS[COMP_CWORD]}) )
    return 0
}
complete -F __venv_complete venv

# -------------------------------------------------------------------------------
# Image File Management
# -------------------------------------------------------------------------------
resize_images() {
  if [ $# -ne 2 ]; then
    echo "Required arguments: input_dir output_dir"
  fi

  IN_DIR=$1
  OUT_DIR=$2

  mkdir -p ${OUT_DIR}

  if [ "${IN_DIR}" = "${OUT_DIR}" ]; then
    echo "Input and output directories are the same - quitting"
    return
  fi

  for f in ${IN_DIR}/*.jpg; do
    OUT_NAME="$(basename "${f}")"
    OUT_NAME="${OUT_DIR}/${OUT_NAME::-4}_30pct.jpg"
    if [ ! -f "${OUT_NAME}" ]; then
      echo "resize ${f} to ${OUT_NAME}"
      convert "${f}" -resize 30% "${OUT_NAME}"
    fi
  done

}

# --------------------------------------------------------------------------------
# Private aliases (Not to be stored in this common file)
# --------------------------------------------------------------------------------
if [ -f ${HOME}/.private_aliases ]; then
  source ${HOME}/.private_aliases
fi
