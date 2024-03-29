[[ -a ~/.history ]] || mkdir ~/.history

# History
setopt share_history 
HISTFILE=~/.history/zsh
HISTSIZE=100000
SAVEHIST=100000

setopt extendedglob
unsetopt beep
bindkey -e

autoload -U promptinit
promptinit
prompt clint

readonly dotfiles_zshrc="$(realpath ${ZDOTDIR-~}/.zshrc)"
if [[ -f "${dotfiles_zshrc%/*}/functions.zsh" ]]; then
    source "${dotfiles_zshrc%/*}/functions.zsh"
    setup_android_sdk
    setup_brew_guard
    setup_help
    setup_terraform_completions
    setup_zkbd
    setup_zsh_completions

    prepend_to_path ~/.local/bin
    prepend_to_path /usr/local/opt/ncurses/bin
    prepend_to_path /usr/local/opt/man-db/libexec/bin

    prepend_to_path /usr/local/opt/openjdk/bin
    prepend_to_path /usr/lib/jvm/default-java/bin

    try_source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
    try_source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

    try_source \
      ~/.local/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
      /usr/local/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
      /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
      /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

fpath+=(
    "${dotfiles_zshrc%/*}/functions"
)

funcs=(${dotfiles_zshrc%/*}/functions/*)
autoload -U ${funcs##*/}
(cd "${dotfiles_zshrc%/*}/functions" && autoload -U *)

source "${dotfiles_zshrc%/*}/lscolors.zsh"

alias g="grep --color=always -E -i "
alias l="ls --color "
alias ll="l -al "
alias lt="l -altr "
alias lz="l -alSr "
alias s="sed -E "

# allow alias expansion on the word following `sudo` commands
alias sudo='sudo '

export EDITOR=vim
export LESS="-i -S -R -M -a -j20"
export LESSHISTFILE=~/.history/lesshst
export LESSHISTSIZE=1000

if [[ -f ~/.config/pythonrc.py ]]; then
    export PYTHONSTARTUP=~/.config/pythonrc.py
fi

#[[ -s /etc/grc.zsh ]] && source /etc/grc.zsh

# The following lines were added by compinstall
zstyle :compinstall filename ~/.zshrc

autoload -Uz compinit
compinit -u
# End of lines added by compinstall
alias mps='ps -u user1 -H -o pid,ppid,ni,pmem,pcpu,thcount,rss,wchan,alarm,lsession:5,stat,tname,time,args --cols $COLUMNS'

#powerline-daemon -q
#source /usr/share/powerline/bindings/zsh/powerline.zsh


bindkey "^[[3~" delete-char
