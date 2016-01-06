#!/bin/bash
clear

# Arrays containing list of dotfiles that will be in use.
dotfile_array=( .bash_profile .bashrc .emacs .gitconfig .inputrc .muttrc .tmux.conf .vimrc .xvimrc .zshrc )

# Git clone dotfiles.
if [ ! -d "$HOME/dotfiles/" ]; then
    echo "Installing DOTFILES for the first time..."
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

echo "Looking for brew package manager..."
sleep 1
# Check if Homebrew is install on system.
which brew
exitCode=$?
operatingSystem=`uname`
if [[ $exitCode != 0 ]]; then
    # Determine operating system via uname. Install appropriate Homebrew.
    if [ $operatingSystem == "Darwin" ]; then
        # Homebrew
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    elif [ "$operatingSystem" == "Linux" ]; then
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

echo "========================="
echo " Updating Homebrew..."
echo "========================="
sleep 1

brew update

echo "========================="
echo " Installing Packages..."
echo "========================="
sleep 1

brew install stow

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
brewlist="dotfiles/brew/.brewlist"
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

# Check users home directory for existing dotfiles such as .bashrc and .vimrc and create a backup version.
for i in ${dotfile_array[*]}
do
    if [ -f "$HOME/$i" ]; then
        # echo "I have made fie: " $i
        echo "Creating backup of existing' " $i
        mv $HOME/$i $HOME/$i-backup
    fi
done

sleep 2
echo
echo "Please choose what type of installation to carry out...??"
echo

function full_install(){
    # Full system install. Ideal for use on own property.
    file='dofiles/uninstall.sh'
    insert='choice="FULL"'

    my_output="$(awk -v insert="$insert" '{print} NR==1{print insert}' $file)"
    echo "$my_output" > $file

    cd dotfiles/ && stow -v bash/ brew/ emacs/ git/ mutt/ readline/ tmux/ vim/ xcode/ zsh/

}

function temporay_install(){
    # For use when temporarily using a system but would still like personal configuration.
    file='dotfiles/uninstall.sh'
    insert='choice="TEMPORARY"'

    my_output="$(awk -v insert="$insert" '{print} NR==1{print insert}' $file)"
    echo "$my_output" > $file

    cd dotfiles/ && stow -v bash/ brew/ vim/ readline/

}

function emails_only_install(){
    # Will only install bash, vim  and mutt to view, edit and send emails.
    file='dotfiles/uninstall.sh'
    insert='choice="EMAILS"'

    my_output="$(awk -v insert="$insert" '{print} NR==1{print insert}' $file)"
    echo "$my_output" > $file

    cd dotfiles/ && stow -v bash/ vim/ mutt/

}

while true; do
    select choice in FULL TEMPORARY EMAILS
    do
        echo "$REPLY : $choice"
        break
    done

    case $choice in
        "FULL" )
            echo "Full system install was selected. Brace yourself Rodney.. Brace yourself..";
            sleep 2;
            full_install;
            break ;;
        "TEMPORARY" )
            echo "Temp install was selected";
            temporay_install;
            break ;;
        "EMAILS" )
            echo "Emails was selected";
            emails_only_install;
            break ;;
        * )
            echo "Dafuq was that you entered. Choose 1, 2, or 3 fool!" ;;
    esac
done
# TODO::set up cron job for daily back up of brewlist
source $HOME/.bashrc 2> /dev/null
# Install Vim plugins
vim +PluginInstall +qall
echo "==============================="
echo " DOTFILES have been installed."
echo " System ready."
echo " Please re-start shell"
echo "=============================="
