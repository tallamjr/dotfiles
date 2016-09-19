# ================ Initialisation  ==============
#
# Vim key-bindings for movement within the shell.
set -o vi
# Locate file containing passwords and global variables that will be sourced within other files.
if [ -f ~/.localrc ]; then
	source ~/.localrc
fi
# If docker is installed on system. Run this command to start docker daemon as shell starts
# if [ -d ~/.docker ]; then
#     eval "$(docker-machine env default)"
# fi
# For Git completion
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
else
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
fi
# For Git branch information in prompt
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
else
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi
# If fuzzy finder installed, source
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# ================ Prompt ==============
#
# Shell prompt customisation with Grey time, exit code status, blue directory and git branch informations.
export PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\e[01;34m\]\w\[\e[00m\] `[[ $(git status 2> /dev/null | head -n5 | tail -n1) == "nothing to commit, working directory clean" ]] && echo "\[\e[01;32m\]"$(__git_ps1 "(%s)") || echo "\[\e[01;31m\]"$(__git_ps1 "(%s)")` \[\e[00m\]:: '

# ================ Path Exports ==============
#
#
export PATH="/usr/local/bin:$PATH"
#
export PATH="/usr/local/Cellar/gcc/5.2.0/bin:$PATH"
# Setting PATH for EPD-6.3-1
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/EPD64.framework/Versions/Current/bin:${PATH}"
export PATH

if [ `uname` == "Darwin" ]; then
    # juliaVersion=`julia --version | awk '{ print $3 }'`
    juliaVersion=`cd /Applications && ls | grep -i julia`
    PATH="/Applications/$juliaVersion/Contents/Resources/julia/bin:${PATH}"
    export PATH
fi

if [ `uname` == "Linux" ]; then
    # Export path variables for linuxbrew.
    export PATH="$HOME/.linuxbrew/bin:$PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi
#export PATH="$HOME/anaconda/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# TMUX Battery Status
export PATH="$HOME/Documents/tmux/bin:$PATH"
# Added by Anaconda3 2.1.0 installer
export PATH="$HOME/anaconda/bin:$PATH"

# export PATH="$HOME/anaconda3/bin:$PATH"
# MySQL
export PATH="/usr/local/mysql/bin:$PATH"
# Mongodb PATH
export PATH="$HOME/mongodb/bin:$PATH"
#
export PATH="/usr/local/sbin:$PATH"
# Allows Coreutils package to be used without 'g' prefix before each command.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# jMusic classpath
export CLASSPATH="/Users/tarek_allam/jMusic/jMusic1.6.4.jar:$HOME/jMusic/inst/:$CLASSPATH"
export CLASSPATH="/Users/tarek_allam/jMusic/HelperGUIAdapter.jar:$CLASSPATH"
# Java jars classpath
# export CLASSPATH="$HOME/Books/:$CLASSPATH"
export CLASSPATH="$HOME/Books/:$CLASSPATH"
# Full path to jar file is required to allow proper access to all classes that
# reside inside, not just the path of where the jar is located.
export CLASSPATH="/Users/tarek_allam/myJars/jsyn_16_7_3.jar:$CLASSPATH"

#Caffe path.
export PATH="$HOME/Caffe-Home/caffe/build/tools:$PATH"

# MATLAB command line.
export PATH="/Applications/MATLAB_R2015a.app/bin:$PATH"

export PATH="/Users/tarek_allam/UCL_2016/major-project/main/src/RICNN/plot_logs.py:$PATH"

# ================ Colour Customisation  ==============
#
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad # Blue
export GREP_OPTIONS="--color=auto"
# Source for colouring of grep output.
source "`brew --prefix grc`/etc/grc.bashrc"

# ================ Aliases ==============
#
alias pylab="ipython -pylab"    # Ipython
alias tmux="tmux -2"            # Force tmux to use 256 colours
alias ls="ls --color"           # Listing in colour
alias cl="clear"
alias la="ls -lah"              # Listing in human-readable format
alias qq="exit"
alias grep="grep -E"
alias sleep="sudo shutdown -s now"  # Put computer to sleep
alias pat="pygmentize -g"           # Colourful 'cat' output
alias chrome="open /Applications/Google\ Chrome.app/"
alias poker="open /Applications/PokerStarsUK.app/"
alias fire="open /Applications/Firefox.app/"
alias rr="R CMD BATCH "
alias xx="chmod +x"             # Make file executable
# alias todo="vim `$DATE`.md"
alias todo="vim +VimwikiIndex"
alias lsg="ls | grep -i"        # Search a directory listing with grep case-insensitive.
alias crontabedit="env EDITOR=vim crontab -e"   # Edit crontab with vim
alias ff="gfortran"
# alias dockerdaemon="eval '$(docker-machine env default)'"           # Set enviroment variables for docker default machine.
alias pingg="ping www.google.com"
alias kali="dockerdaemon && docker run -t -i kali:latest /bin/bash" # Start Kalilinux via docker vm.
alias vimplugininstall="vim +PluginInstall +qall"                   # Vim pluin install from command line.
alias lsc="ls | wc | awk '{print \$1}'"                             # Show the 'count' of files in a director.
alias py3="source activate py3"                                     # Conda enviroment for Python 3.5.
alias f="fzf -i --color=hl:200,hl+:200"
alias sb="source ~/.bashrc"
alias vb="vim ~/.bashrc"
alias gcc="gcc-5"
alias speed="speedtest-cli"
alias dls="cd ~/Downloads/ && la -rt"
alias vimrc="vim ~/.vimrc"
alias ttop="top -o CPU"
alias mp="cd ~/UCL_2016/major-project/"
alias matlab="matlab -nodesktop"
alias lrt="ls -lart"
alias df="df -h"
alias du="du -sh"

# ================ Functions ==============
#
function mkcd() {
# Make directory and cd into it straight away.
mkdir $1 && cd $1
}

function cmdfu() {
# Get random command line fact from commanlinefu.com
curl "http://www.commandlinefu.com/commands/matching/$(echo "$@" | sed 's/ /-/g')/$(echo -n $@ | base64)/plaintext"
}

function calc() {
# Python calculator
python -ic "from __future__ import division; from math import *; from random import *"
}

function lag() {
# List of files in a directory and grep for a certain one.
ls -la | grep -i "$1" | awk '{print $9}'
}

function extract() {
# Extract any compressed file, courtsey http://efavdb.com/dotfiles/
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar -jxvf "$1"                        ;;
            *.tar.gz)   tar -zxvf "$1"                        ;;
            *.bz2)      bunzip2 "$1"                          ;;
            *.dmg)      hdiutil mount "$1"                    ;;
            *.gz)       gunzip "$1"                           ;;
            *.tar)      tar -xvf "$1"                         ;;
            *.tbz2)     tar -jxvf "$1"                        ;;
            *.tgz)      tar -zxvf "$1"                        ;;
            *.zip)      unzip "$1"                            ;;
            *.ZIP)      unzip "$1"                            ;;
            *.pax)      cat "$1" | pax -r                     ;;
            *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
            *.Z)        uncompress "$1"                       ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file to extract"
    fi
}

# ================ Miscellaneous ==============
#
MKL_NUM_THREADS=1
export MKL_NUM_THREADS
# Global variable for date format YY-MM-DD
DATE='date +%Y-%m-%d'
export DATE
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=$HOME/.docker/machine/machines/default
export DOCKER_TLS_VERIFY=1
# Command line cheat
export CHEATCOLORS=true
# --appdir=/my/path changes the path where the symlinks to the applications
# (above) will be generated. This is commonly used to create the links in the
# root Applications directory instead of the home Applications directory by
# specifying --appdir=/Applications. Default is ~/Applications. See
# https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# For awscli completion
complete -C aws_completer aws
source /usr/local/etc/bash_completion.d/password-store

# ++++++++++++++++++++++++++++++++++++++
# ================  EOF   ==============
# ++++++++++++++++++++++++++++++++++++++
