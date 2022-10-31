#!/usr/bin/env zsh

dotfiles_dir="${${0:a:h}#~/}"

files_to_install=(
  bashrc
  config/pythonrc.py
  gitconfig
  tmux.conf
  vimrc
  zshrc
  zkbd
)

mkdir -p ~/.config
for f in $files_to_install
do
  ln -sf ${dotfiles_dir}/${f} ~/.${f}
done
