#!/bin/bash

dotfiles=".vimrc .bashrc .muttrc"

for dotfile in $dotfiles
do
    echo "this is a file:" $dotfile
done

if [ ! -f "$HOME/$dotfile" ]; then
    ln -s dotfiles/vimrc .vimrc
else
    mv $HOME/.vimrc $HOME/.vimrc-backup-`$DATE` && ln -s dotfiles/vimrc .vimrc
fi
