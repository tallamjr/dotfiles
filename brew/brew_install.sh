#!/bin/bash

# Brew install all pacakges listed in brewlist and brewcasklist
# brew info `grep $(find . -type f -name ".brewlist")`
# brew info `grep $(find . -type f -name ".brewlist")`
brew install `cat $(find . -type f -name ".brewlist")`

operatingSystem=`uname`
if [ $operatingSystem == "Darwin" ]; then
    # Brew install all applications listed in brewcasklist
    brew cask reinstall `cat $(find . -type f -name ".brewcasklist") | grep -v "anaconda"`
    # brew cask info `cat ".brewcasklist`
    conda_prefix="/usr/local/anaconda3"
    export PATH="$HOME/anaconda3/bin:$PATH"
elif [[ $operatingSystem == Linux ]]; then
    wget https://repo.continuum.io/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && bash ~/anaconda.sh -b -p ~/anaconda3 && rm ~/anaconda.sh
    conda_prefix="$HOME/anaconda3"
fi
source $HOME/.bashrc 2> /dev/null
