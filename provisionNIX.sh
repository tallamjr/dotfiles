#!/bin/bash
clear

echo " Beginning System Configuration Install"
sleep 3
echo "............"
sleep 1
echo " Just Brace Yourself Rodney.... Brace Yourself!"
sleep 3

# Arrays containing list of dotfiles that will be in use.
dotfile_array=( .bash_profile .bashrc .emacs .gitconfig .inputrc .muttrc .tmux.conf .vimrc .xvimrc .zshrc )
# Check users home directory for existing dotfiles such as .bashrc and .vimrc and create a backup version.
for i in ${dotfile_array[*]}
do
    if [ -f "$HOME/$i" ]; then
        # Date variable, example 20170906, i.e. YYYYMMDD
        # date=$(date +%Y%m%d)
        # echo "I have made fie: " $i
        echo "Creating backup of existing" $i
        mv $HOME/$i $HOME/$i-backup
    else
        echo $i " configuration file not found ..."
    fi
done

# Clone dotfiles
git clone https://github.com/tallamjr/dotfiles.git

function stowFiles(){
# Symlink dotfiles to home directory
cd dotfiles && stow -v \
    bash/ \
    brew/ \
    emacs/ \
    git/ \
    mutt/ \
    readline/ \
    tmux/ \
    vim/ \
    xcode/ \
    zsh/
}

operatingSystem=`uname`

# Determine operating system via uname. Install appropriate Homebrew.
if [ $operatingSystem == "Darwin" ]; then

    echo " macOS Detected..."
    echo "======================================="
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
    brew cask install java
    brew install stow

    stowFiles

elif [ "$operatingSystem" == "Linux" ]; then

    echo " Linux Kernel Detected..."
    echo "=========================="
    sleep 1
    echo " Installing Homebrew..."
    echo "======================================="
    sleep 1
    # Linuxbrew
    apt-get update
    apt-get install sudo

    # Debian
    sudo apt-get install build-essential curl file git python-setuptools ruby stow

    # Red Hat
    sudo yum groupinstall 'Development Tools' && sudo yum install curl file git irb python-setuptools ruby

    # useradd -m linuxbrew
    # sudo -u linuxbrew -i /bin/bash
    # PATH=~/.linuxbrew/bin:/usr/sbin:/usr/bin:/sbin:/bin

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"

    stowFiles

    test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$PATH"
    test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    test -r ~/.bash_profile && echo 'export PATH="$(brew --prefix)/bin:$PATH"' >>~/.bash_profile
    echo 'export PATH="$(brew --prefix)/bin:$PATH"' >>~/.profile

    echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.bash_profile
    echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.bash_profile
    echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.bash_profile
    # export PATH="$HOME/.linuxbrew/bin:$PATH"
    # export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    # export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

    # source $HOME/.bashrc 2> /dev/null
    source $HOME/.bashrc 2> /dev/null
    source $HOME/.porfile 2> /dev/null
    source $HOME/.bash_profile 2> /dev/null

else
    echo "Not running OSX or Linux. Sort it out mate!"
    exit 1;
fi

# Full path required for travis CI
brewlist_loc=`find / -type f -name ".brewlist" 2> /dev/null`
brewcasklist_loc=`find / -type f -name ".brewcasklist" 2> /dev/null`

echo $brewlist_loc
echo $brewcasklist_loc

# Brew install all pacakges listed in brewlist, except VIM
brew install `grep -v vim $brewlist_loc`
if [ $operatingSystem == "Darwin" ]; then
    # Brew install all applications listed in brewcasklist
    brew cask install `cat $brewcasklist_loc`
    export PATH="$HOME/anaconda/bin:$PATH"
fi
# Install VIM 8.0+ compiled with Python 3.5+
brew install vim --with-override-system-vi --with-python3
# Clone repo for bundle plug-ins installation
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Install VIM plugins
vim +PluginInstall! +qall

source $HOME/.bashrc 2> /dev/null
