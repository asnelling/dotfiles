[[ -a ~/.history ]] || mkdir ~/.history

# History
setopt share_history 
HISTFILE=~/.history/zsh
HISTSIZE=100000
SAVEHIST=100000

setopt extendedglob
unsetopt beep
bindkey -e

# The following lines were added by compinstall
zstyle :compinstall filename ~/.zshrc

autoload -Uz compinit
compinit -u
# End of lines added by compinstall

autoload -U promptinit
promptinit
prompt clint

readonly dotfiles_zshrc="$(realpath ${ZDOTDIR-~}/.zshrc)"
if [[ -f "${dotfiles_zshrc%/*}/functions.zsh" ]]; then
    source "${dotfiles_zshrc%/*}/functions.zsh"
    setup_android_sdk
    setup_help
    setup_java
    setup_terraform_completions
    setup_zkbd

    prepend_to_path ~/.local/bin
fi

source "${dotfiles_zshrc%/*}/lscolors.zsh"

alias ls="ls --color"
alias lsl="ls -al"

# refresh password timeout with each invocation of sudo
alias sudo="sudo -v; sudo"

export EDITOR=vim
export LESS="-i -S -R -M"
export LESSHISTFILE=~/.history/lesshst
export LESSHISTSIZE=1000

if [[ -f ~/.config/pythonrc.py ]]; then
    export PYTHONSTARTUP=~/.config/pythonrc.py
fi
