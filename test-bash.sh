#!/bin/bash

# git clone dotfiles
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Installing DOTFILES for the first time..."
    git clone https://github.com/tallamjr/dotfiles.git "$HOME"
else
    echo "DOTFILES are already installed"
fi

# Check if Homebrew is install on system
which brew
exitCode=$?
if [[ $exitCode != 0 ]]; then
    # Determine operating system via uname. Install appropriate Homebrew.
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    #linuxbrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
    exit $exitCode;
fi

echo "========================="
echo " Updating Homebrew..."
echo "========================="

brew update

echo "========================="
echo " Installing Packages..."
echo "========================="

# needs work around for additional arguments such as 'override system-vi'
FILE=".brewlist"
while read line; do
    brew info $line
done < $FILE

# make symlinks for files and dotfiles
# check for certain files, remove if required, created if needed. ie bashrc and emacs.d
ln -s dotfiles/vimrc .vimrc
ln -s dotfiles/bashrc .bashrc
ln -s dotfiles/muttrc .muttrc
