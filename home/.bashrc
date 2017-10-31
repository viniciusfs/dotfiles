# .bashrc file
# Vinícius Figueiredo <viniciusfs@gmail.com>

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length.
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%d/%m/%y %T "

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Bash completions
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Functions
if [ -f ~/.functions ]; then
    . ~/.functions
fi

# Put ~/bin on PATH
if [ -d $HOME/bin ]; then
    PATH="$PATH:$HOME/bin"
fi

# Set vim as EDITOR
HAVE_VIM=$(which vim)
if [ -n $HAVE_VIM ]; then
    EDITOR=vim
    export EDITOR
fi

# Virtualenv Wrapper settings
export PROJECT_HOME=$HOME/ownCloud/Code
export WORKON_HOME=$HOME/.virtualenvs

distro_version=$(lsb_release -si)
if [ ${distro_version} == 'Ubuntu' ]; then
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
elif [ ${distro_version} == 'CentOS' ]; then
    source /usr/bin/virtualenvwrapper.sh
fi
unset distro_version

# Bash prompt
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

# Homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
