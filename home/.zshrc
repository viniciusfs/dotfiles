# homeshick

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# oh my zsh
export ZSH=/home/vfigueiredo/.oh-my-zsh

ZSH_THEME="ultrav"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git virtualenv virtualenvwrapper)

source $ZSH/oh-my-zsh.sh

# put ~/bin on PATH
if [ -d $HOME/bin ]; then
    PATH="$PATH:$HOME/bin"
fi

# set vim as EDITOR
HAVE_VIM=$(which vim)
if [ -n $HAVE_VIM ]; then
    EDITOR=vim
    export EDITOR
fi

# virtualenv wrapper
export PROJECT_HOME=$HOME/Code
export WORKON_HOME=$PROJECT_HOME/.virtualenvs
