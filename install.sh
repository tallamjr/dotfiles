#!/bin/bash
clear

# TODO --  Make backup of dotfiles with date, make function for this.
# Arrays containing list of dotfiles that will be in use.
dotfile_array=( .bash_profile .bashrc .emacs .gitconfig .inputrc .muttrc .tmux.conf .vimrc .xvimrc .zshrc )
# Check users home directory for existing dotfiles such as .bashrc and .vimrc and create a backup version.
for i in ${dotfile_array[*]}
do
    if [ -f "$HOME/$i" ]; then
        # Date variable, example 20170906, i.e. YYYYMMDD
        date=$(date +%Y%m%d)
        # echo "I have made fie: " $i
        echo "Creating backup of existing" $i
        mv $HOME/$i $HOME/$i-backup-$date
    else
        echo "No original configuration files found..."
    fi
done

operatingSystem=`uname`

# Determine operating system via uname. Install appropriate Homebrew.
if [ $operatingSystem == "Darwin" ]; then

    echo " macOS Detected..."
    echo "=========================="
    sleep 1
    # Ensure Apple's command line tools are installed
    if ! command -v cc > /dev/null; then
        echo "Installing xcode ..."
        xcode-select --install
    else
        echo "Xcode already installed. Skipping."
    fi
    echo " Installing Homebrew..."
    echo "======================================="
    sleep 1
    # Homebreww
    if ! command -v brew > /dev/null; then
        echo "Installing Homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew already installed. Skipping."
    fi

    brew cask install xquartz
    brew install ansible
    cd playbook
    ansible-playbook -i HOSTS -K $operatingSystem.yml -v

elif [ "$operatingSystem" == "Linux" ]; then

    echo " Linux Kernel Detected..."
    echo "=========================="
    sleep 1
    echo " Installing Homebrew..."
    echo "======================================="
    sleep 1
    # Linuxbrew
    sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
    export PATH="$HOME/.linuxbrew/bin:$PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

    brew install ansible
    cd playbook
    ansible-playbook -i HOSTS -K $operatingSystem.yml -v

else
    echo "Not running OSX or Linux. Sort it out mate!"
    exit 1;
fi

source $HOME/.bashrc 2> /dev/null
