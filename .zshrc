# The following lines were added by compinstall
zstyle :compinstall filename '/home/asnell/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt extendedglob \
    share_history

autoload -U promptinit
promptinit
prompt clint

autoload -Uz \
    run-help \
    run-help-git \
    run-help-ip \
    run-help-openssl \
    run-help-sudo
unalias run-help
alias help=run-help

export TERMINFO=~/.terminfo
export EDITOR=vim
export VISUAL=vim
export USE_CCACHE=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export LESS="-i -R -F -S -M -K"
export LESSHISTFILE=~/.history/less
export LESSHISTSIZE=1000
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[1;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export GIT_CEILING_DIRECTORIES=~

alias mgrep='grep --color=auto --extended-regexp'
alias msed='sed --regexp-extended'
alias view=vim
alias psf="ps -u ${USER} -F"

typeset -U path
path+=(
    ~/.local/bin
)

source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[F1]} ]] && bindkey "${key[F1]}" run-help

export GPG_TTY=$(tty)
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

function mcp () {
    echo "argc: $ARGC"
    printf "arg: %s\n" $argv
    if [[ $ARGC > 2 && ! -e $argv[-1] ]]; then
        echo "directory does not exist: $argv[-1]"
        echo "create? (y|n)"
        read -q && mkdir -p $argv[-1]
    fi

    cp --interactive $argv
}
# Lines configured by zsh-newuser-install
HISTFILE=~/.history/zsh
HISTSIZE=1000
SAVEHIST=100000
# End of lines configured by zsh-newuser-install

# source /usr/share/zsh/plugins/zsh-notify/notify.plugin.zsh
# zstyle ':notify:*' error-title "FAILED command : #{time_elapsed} seconds"
# zstyle ':notify:*' success-title "Command completed : #{time_elapsed} seconds"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# must be sourced after zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-history-substring-search/blob/v1.0.1/README.md#usage
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "${key[Up]}" history-substring-search-up
bindkey "${key[Down]}" history-substring-search-down

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

powerline-daemon -q
source /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

source /opt/google-cloud-sdk/completion.zsh.inc
