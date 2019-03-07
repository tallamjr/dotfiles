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
        echo "Creating backup of existing" $i
        mv $HOME/$i $HOME/$i-backup
    else
        echo $i " configuration file not found ..."
    fi
done

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
    # Install Homebreww
    if ! command -v brew > /dev/null; then
        echo "Installing Homebrew..."
        which ruby
        ruby --version
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
    # Install Linuxbrew
    if ! command -v brew > /dev/null; then
        echo " Installing Homebrew..."
        echo "======================================="
        sleep 1
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

        test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
        test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
        test -r ~/.bash_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.bash_profile
        echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile
    fi
    # install stow dependencies
    brew install stow
    stowFiles
else
    echo "Not running OSX or Linux. Sort it out mate!"
    exit 1;
fi
# Install Anaconda
if [[ $operatingSystem == Darwin ]]; then
    brew cask install anaconda > /dev/null 2>&1
    conda_prefix="/usr/local/anaconda3"
elif [[ $operatingSystem == Linux ]]; then
    wget https://repo.continuum.io/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && bash ~/anaconda.sh -b -p ~/anaconda3 && rm ~/anaconda.sh
    conda_prefix="$HOME/anaconda3"
fi
# Clone repo for bundle plug-ins installation
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
brew install vim
vim --version
# Restart SHELL for installation to take effect
echo "===============================  "
echo " DOTFILES Installed.             "
echo " System Ready.                   "
echo " Please Restart $SHELL, Then Run:"
echo "                                 "
echo "      vim +PluginInstall +qall   "
echo "                                 "
echo "==============================   "
