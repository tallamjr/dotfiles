#!/bin/bash

if [ ! -d "$HOME/dotfiles" ]; then
    echo "Installing DOTFILES for the first time..."
    git clone https://github.com/tallamjr/dotfiles.git "$HOME"
else
    echo "DOTFILES are already installed"
fi

# Grab install script from github, perhaps use curl
# git clone dotfiles
# make symlinks for files and dotfiles

# Check if Homebrew is install on system
which brew
ec=$?
if [[ $ec != 0 ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    #linuxbrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
    exit $ec;
fi

echo "========================="
echo " Updating Homebrew"
echo "========================="

brew update


FILE=".brewlist"
while read line; do
    brew info $line
done < $FILE
