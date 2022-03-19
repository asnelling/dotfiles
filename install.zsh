#!/usr/bin/zsh

dotfiles=${0:a:h}

files_to_install=(
  config/pythonrc.py
  gitconfig
  tmux.conf
  vimrc
  zshrc
)

mkdir -p ~/.config
for f in $files_to_install
do
  ln -sfr ${dotfiles}/${f} ~/.${f}
done
