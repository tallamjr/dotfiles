#!/bin/bash
clear

# Arrays containing list of dotfiles that will be in use.
dotfile_array=( .bash_profile .bashrc .emacs .gitconfig .inputrc .muttrc .tmux.conf .vimrc .xvimrc .zshrc )

# Git clone dotfiles.
if [ ! -d "$HOME/dotfiles/" ]; then
    echo "Installing DOTFILES for the first time..."
    git clone https://github.com/tallamjr/dotfiles.git "$HOME/"
else
    echo "DOTFILES are already installed."
    echo
    echo "To update dotfiles, cd ~/dotfiles && git pull."
    echo
    echo "If you would still like to install, please remove or rename your existing '~/dofiles' directory"
    echo
    exit
fi

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
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
    else
        echo "Not running OSX or Linux. Sort it out mate!"
        # Need a catch here to halt script alltogether.
    fi
    # exit $exitCode;
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

# Brew install each package in "brewlist" file.
brewlist="dotfiles/brew/.brewlist"
while read line; do
    if [ "$line" == "vim"]; then
        brew install --override-system-vim
    else
        brew install $line
    fi
done < $brewlist

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
echo "Please choose what type of installation to carry out..."
echo

full_install(){
    # Full system install. Ideal for use on own property.
    file='uninstall.sh'
    insert='choice="FULL"'

    my_output="$(awk -v insert="$insert" '{print} NR==1{print insert}' $file)"
    echo "$my_output" > $file

    stow -v bash/ brew/ emacs/ git/ mutt/ readline/ tmux/ vim/ xcode/ zsh/

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}

temporay_install(){
    # For use when temporarily using a system but would still like personal configuration.
    file='uninstall.sh'
    insert='choice="TEMPORARY"'

    my_output="$(awk -v insert="$insert" '{print} NR==1{print insert}' $file)"
    echo "$my_output" > $file

    stow -v bash/ brew/ vim/ readline/

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
}

emails_only_install(){
    # Will only install bash, vim  and mutt to view, edit and send emails.
    file='uninstall.sh'
    insert='choice="EMAILS"'

    my_output="$(awk -v insert="$insert" '{print} NR==1{print insert}' $file)"
    echo "$my_output" > $file

    stow -v bash/ vim/ mutt/

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
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
echo "==============================="
echo " DOTFILES have been installed."
echo " System ready."
echo " Please re-start shell"
echo "=============================="
