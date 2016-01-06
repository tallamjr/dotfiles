#!/bin/bash
case $choice in
    "FULL" )
        echo "Full uninstall was selected";
        stow -Dv bash/ brew/ emacs/ git/ mutt/ readline/ tmux/ vim/ xcode/ zsh/;;
    "TEMPORARY" )
        echo "Temp uninstall was selected";
        stow -Dv bash/ brew/ vim/ readline/;;
    "EMAILS" )
        echo "Emails uninstall was selected";
        stow -Dv bash/ vim/ mutt/;;
    * )
        echo "Please run install script first befire uninstall" ;
        exit;;
esac

dotfile_array=(.bash_profile .bashrc .emacs .gitconfig .inputrc .muttrc .tmux.conf .vimrc .xvimrc .zshrc)
for i in ${dotfile_array[*]}
do
    if [ -f "$HOME/$i-backup" ]; then
        # echo "I have made fie: " $i
        mv $HOME/$i-backup $HOME/$i
    fi
done

# This will remove dotfiles directory
cd $HOME && rm -rf dotfiles/ .vim/
