#!/bin/bash
clear

echo " Beginning System Configuration File Install"
sleep 3
echo "............"
sleep 1
echo " Just Brace Yourself Rodney.... Brace Yourself!"


# Arrays containing list of dotfiles that will be in use.
dotfile_array=( .bash_profile .bashrc .emacs .gitconfig .inputrc .muttrc .tmux.conf .vimrc .xvimrc .zshrc )

# Define dotfile directory
dotfiles_DIR="$HOME/dotfiles"

echo "Looking for brew package manager..."
echo "======================================="
sleep 1
# Check if Homebrew is installed on system.
which brew
exitCode=$?
operatingSystem=`uname`

function xcode_install(){
# Install Xcode Command Line Tools
    echo " Installing Xcode Command Line tools..."
    echo "======================================="
    sleep 1
    xcode-select --install
}

if [[ $exitCode != 0 ]]; then
    # Determine operating system via uname. Install appropriate Homebrew.
    if [ $operatingSystem == "Darwin" ]; then

        echo " masOS System Detected..."
        echo "=========================="
        sleep 1

        xcode_install

        echo " Installing Homebrew..."
        echo "======================================="
        sleep 1
        # Homebrew
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
    else
        echo "Not running OSX or Linux. Sort it out mate!"
        exit $exitCode;
    fi
fi

if [ $operatingSystem == "Darwin" ]; then
    xcode_install
fi

echo "========================="
echo " Updating Homebrew..."
echo "========================="
sleep 1

brew update

echo "========================="
echo " Installing Packages..."
echo "========================="
sleep 1

# Brew install essentails for configuration script.
brew install stow
brew install git

# Install Java and the JVM.
brew cask install java

# Git clone dotfiles.
if [ ! -d "$dotfiles_DIR" ]; then
    echo "Cloning Dotfiles..."
    cd $HOME
    git clone https://github.com/tallamjr/dotfiles.git
else
    echo "DOTFILES are already installed."
    echo
    echo "To update dotfiles, cd ~/dotfiles && git pull."
    echo
    echo "If you would still like to install, please remove or rename your existing '~/dofiles' directory"
    echo
    exit
fi

function get_brewVimVersion(){

brew_VimVersion=`brew info vim | awk 'FNR==1 {print $3}'`
a=( ${brew_VimVersion//./ } )                   # replace points, split into array
brew_vimMajor="${a[0]}"
brew_vimMinor="${a[1]}"

}
get_brewVimVersion

function get_localVimVersion(){

local_VimVersion=`vim --version | awk 'FNR==1 {print $5}'`
a=( ${local_VimVersion//./ } )                   # replace points, split into array
local_vimMajor="${a[0]}"
local_vimMinor="${a[1]}"

}

function vim_install(){

brew install --system-override-vi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
sleep 2
# eval $(vim +PluginInstall +qall)

}

which vim
exitCode=$?
if [[ $exitCode != 0 ]]; then
    echo "Vim not found.. Installing latest version..."
    sleep 1
    vim_install
else
    get_localVimVersion
    if [ $local_vimMinor -lt $brew_vimMinor ]; then
        read -r -p "Would you like to update your version of vim? [y/N]" update_response
        update_response=${update_response,,}    # tolower
        if [[ $update_response =~ ^(yes|y)$ ]]; then
            vim_install
        fi
    fi
fi

if [ ! -d ~/.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    # eval $(vim +PluginInstall +qall)
    # `vim +PluginInstall +qall`
fi

# Ask user if they would like to install all brew packages in .brewlist
read -r -p "Install all brew packages now? [y/N] "  response

function brewlist_install(){
# Brew install each package in "brewlist" file.
brewlist="$dotfiles_DIR/brew/.brewlist"
while read line; do
    if [ "$line" == "vim" ]; then
        brew install vim --override-system-vi
    else
        brew install $line
    fi
done < $brewlist
}
response=${response,,}    # tolower
if [[ $response =~ ^(yes|y)$ ]]; then
    brewlist_install
fi

# Ask user if they would like to install all brew packages in .brewlist
read -r -p "Install all brew cask applications now? [y/N] "  response

function brewcasklist_install(){
# Brew cask install each package in "brewcask list" file.
brewlist="$dotfiles_DIR/brew/.brewcasklist"
while read line; do
        brew cask install $line
done < $brewlist
# Install further key apps.
# Install Chrome browser.
brew cask install google-chrome
# Install Firefox browser.
brew cask install firefox
# Install iTerm2 terminal app.
brew cask install iterm2
# Install VLC media player.
brew cask install vlc
# Install Skype video calling app.
brew cask install skype
# Install Slack messenger.
brew cask install slack
}

response=${response,,}    # tolower
if [[ $response =~ ^(yes|y)$ ]]; then
    # Install apps in brewcasklist
    brewcasklist_install
fi

#TODO Backup files are not being created.
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

sleep 2

function symlink_and_install(){
# Create symlinks of dotfiles in dotfile directory to home directory
cd $dotfiles_DIR

for d in */; do
    stow -v $d
done
}

symlink_and_install


function anaconda_install(){
# Install Anaconda, Python 2.7 in this case

echo " Installing Anaconda Python (2.7) Distribution ..."
echo "=================================================="
sleep 2

wget -P ~/Downloads https://repo.continuum.io/archive/Anaconda2-4.4.0-MacOSX-x86_64.sh
bash ~/Downloads/Anaconda2-4.4.0-MacOSX-x86_64.sh

}

# Check if system Python is already linked to the anaconda distribution
# grep -w checks for exact match of anaconda
which python | grep -w "anaconda2"
exitCode=$?
if [[ $exitCode != 0 ]]; then
    echo " Default Python Not Anaconda Distribution ..."
    echo "============================================="
    sleep 1
    # Ask user if they would like to install all brew packages in .brewlist
    read -r -p "Would you like to install Anaconda Python 2.7 now? [y/N] "  response

    response=${response,,}    # tolower
    if [[ $response =~ ^(yes|y)$ ]]; then
        # Install Anaconda Python
        anaconda_install
    fi
fi

source $HOME/.bashrc 2> /dev/null

# Install Vim plugins
vim +PluginInstall +qall
# Prevent accidental git push to master on GitHub.
# git remote set-url --push origin no-pushing

echo " Nice one bruva! Dotfiles Have Been Installed."
echo "=============================================="
echo " System Ready..."
sleep 5
echo " Please Re-Start Shell.. "
