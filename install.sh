#!/bin/bash
clear

echo " Beginning System Configuration Install"
sleep 3
echo "............"
sleep 1
echo " Just Brace Yourself Rodney.... Brace Yourself!"
sleep 3

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

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

function stow_files(){
# Symlink dotfiles to home directory
pushd $ROOT
cd dotfiles && stow -v \
    bash/ \
    brew/ \
    conda / \
    config/ \
    emacs/ \
    git/ \
    mutt/ \
    readline/ \
    tmux/ \
    vim/ \
    xcode/ \
    zsh/
popd
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
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed. Skipping."
    fi

    brew install xquartz
    brew install java
    brew install stow

    stow_files
elif [ "$operatingSystem" == "Linux" ]; then
    echo " Linux Kernel Detected..."
    echo "=========================="
    sleep 1
    # Install Linuxbrew
    if ! command -v brew > /dev/null; then
        echo " Installing Homebrew..."
        echo "======================================="
        sleep 1
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
        echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
    fi
    # install stow dependencies
    brew install stow
    stow_files
else
    echo "Not running OSX or Linux. Sort it out mate!"
    exit 1;
fi

# Although inside ~/.bashrc, these export are required to continue installation
if [ `uname -m` == "x86_64" ]; then
    export PATH="/usr/local/bin:$PATH"
    # Allows Coreutils package to be used without 'g' prefix before each command.
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
    if [ `uname` == "Linux" ]; then
        # Export path variables for linuxbrew.
        export PATH="$HOME/.linuxbrew/bin:$PATH"
        export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
        export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
    fi
else
    # Running on Apple silicon
    export PATH="/opt/homebrew/bin:$PATH"
    # Allows Coreutils package to be used without 'g' prefix before each command.
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
    export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
    export PATH="/opt/homebrew/grep/libexec/gnubin:$PATH"
fi
# Brew install packages
cat brew/.brewlist | xargs brew install

# Install Miniforge
brew reinstall miniforge > /dev/null 2>&1
conda init "$(basename "${SHELL}")"

mkdir -p ~/miniforge/envs

ENV=`grep 'name:' $ROOT/conda/environment.yml | tail -n1 | awk '{ print $2}'`
conda activate $ENV

# Install VIM and NEOVIM
# Clone repo for bundle plug-ins installation. Currently using vim-plug
brew install vim
vim --version
brew install neovim
nvim --version
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
bash --rcfile <(echo '. bash/.bashrc; vim +PlugInstall +qall')
# Restart SHELL for installation to take effect
echo "===============================  "
echo " DOTFILES Installed.             "
echo " System Ready.                   "
echo " Please Restart $SHELL           "
echo " Double check vim plugins with:  "
echo "                                 "
echo "      vim +PlugInstall +qall     "
echo "                                 "
echo "==============================   "
