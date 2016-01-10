# ================ Initialisation  ==============
#
# Vim key-bindings for movement within the shell.
set -o vi
# Locate file containing passwords and global variables that will be sourced within other files.
if [ -f ~/.localrc ]; then
	source ~/.localrc
fi
# If docker is installed on system. Run this command to start docker daemon as shell starts
if [ -d ~/.docker ]; then
    eval "$(docker-machine env default)"
fi
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
export PATH="$HOME/anaconda3/bin:$PATH"
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
export CLASSPATH="$HOME/jMusic/jmusic.jar:Users/tarek_allam/jMusic/inst/:$CLASSPATH"

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
alias todo="vim `$DATE`.md"
alias lsg="ls | grep -i"        # Search a directory listing with grep case-insensitive.
alias crontabedit="env EDITOR=vim crontab -e"   # Edit crontab with vim
alias ff="gfortran"
alias dockerdaemon="eval '$(docker-machine env default)'"           # Set enviroment variables for docker default machine.
alias pingg="ping www.google.com"
alias kali="dockerdaemon && docker run -t -i kali:latest /bin/bash" # Start Kalilinux via docker vm.
alias vimplugininstall="vim +PluginInstall +qall"                   # Vim pluin install from command line.
alias lsc="ls | wc | awk '{print \$1}'"                             # Show the 'count' of files in a director.
alias py3="source activate py3"                                     # Conda enviroment for Python 3.5.

# ================ Functions ==============
#
function mkcd() {
#
mkdir $1 && cd $1
}

function cmdfu() {
#
curl "http://www.commandlinefu.com/commands/matching/$(echo "$@" | sed 's/ /-/g')/$(echo -n $@ | base64)/plaintext"
}

function calc() {
#
python -ic "from __future__ import division; from math import *; from random import *"
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
