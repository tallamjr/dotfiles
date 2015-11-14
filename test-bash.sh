#!/bin/bash

# Grab install script from github, perhaps use curl
# git clone dotfiles
# make symlinks for files and dotfiles

# Check if Homebrew is install on system
which brew
ec=$?
if [[ $ec != 0 ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    exit $ec;
fi

FILE=".brewlist"
while read line; do
    brew info $line
done < $FILE
