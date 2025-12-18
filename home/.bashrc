# .bashrc file
# Vinícius Figueiredo <viniciusfs@gmail.com>

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length.
HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT="%d/%m/%Y %T "

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

# Alias definitions
if [ -f "$HOME"/.bash_aliases ]; then
    source "$HOME"/.bash_aliases
fi

# Bash completions
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Put ~/bin on PATH
if [ -d "$HOME"/bin ]; then
    PATH="$PATH:$HOME/bin"
fi

# Set vim as EDITOR
HAVE_VIM=$(which vim)
if [ -n "$HAVE_VIM" ]; then
    export EDITOR=vim
fi

# Virtualenv Wrapper settings
# export PROJECT_HOME=$HOME/Code
# export WORKON_HOME=$HOME/.virtualenvs
# source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# Homeshick
source "$HOME"/.homesick/repos/homeshick/homeshick.sh
source "$HOME"/.homesick/repos/homeshick/completions/homeshick-completion.bash

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
source <(asdf completion bash)
# asdf golang
source ${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.bash

# kubectl completion
HAVE_KUBECTL=$(which kubectl)
if [ -n "$HAVE_KUBECTL" ]; then
  export SET_K8S_CONTEXT=1
  source <(kubectl completion bash)
fi

# Prompt
if [ -f "$HOME"/.bash_prompt ]; then
    source "$HOME"/.bash_prompt
fi

# uv
export PATH="$HOME/.local/bin:$PATH"

# rust
export PATH="$HOME/.asdf/installs/rust/1.90.0/bin:$HOME/.cargo/bin:$PATH"
source "$HOME/.asdf/installs/rust/1.90.0/env"

# neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

