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

operatingSystem=`uname`

exitCode=$?
if [[ $exitCode != 0 ]]; then
    if [ $operatingSystem == "Darwin" ]; then
    # Determine operating system via uname. Install appropriate Homebrew.
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
elif [ "$operatingSystem" == "Linux" ]; then
    #linuxbrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
else
    echo "Not running OSX or Linux. Sort it out mate!"
    fi
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
    if [ "$line" == "vim"]; then
       brew install --override-system-vim
    else
       brew install $line
    fi
done < $FILE

# make symlinks for files and dotfiles
# check for certain files, remove if required, created if needed. ie bashrc and emacs.d
if [ ! -f "$HOME/.vimrc" ]; then
    ln -s dotfiles/vimrc .vimrc
else
    mv $HOME/.vimrc $HOME/.vimrc-backup-`$DATE` && ln -s dotfiles/vimrc .vimrc
fi
if [ ! -f "$HOME/.vimrc" ]; then
    ln -s dotfiles/vimrc .vimrc
else
    mv $HOME/.vimrc $HOME/.vimrc-backup-`$DATE` && ln -s dotfiles/vimrc .vimrc
fi
if [ ! -f "$HOME/.vimrc" ]; then
    ln -s dotfiles/vimrc .vimrc
else
    mv $HOME/.vimrc $HOME/.vimrc-backup-`$DATE` && ln -s dotfiles/vimrc .vimrc
fi
ln -s dotfiles/bashrc .bashrc
ln -s dotfiles/muttrc .muttrc

# set up cron job for daily back up of brewlist

# source bashrc, source vimrc, source muttrc (stderr to dev null)

echo "========================="
echo " DOTFILES have been installed."
echo " System ready."
echo "========================="
