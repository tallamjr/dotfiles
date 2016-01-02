# Vim key-bindings for movement within the shell.
set -o vi

# major=${BASH_VERSINFO[0]}
# minor=${BASH_VERSINFO[1]}
# if (( major > 4 )) || (( major == 4 && minor >= 3 )); then
#     bind -m vi-insert '"kj": vi-movement-mode'
# fi

# Locate file containing passwords and global variables that will be sourced within other files.
if [ -f ~/.localrc ]; then
	source ~/.localrc
fi

# If docker is installed on system. Run this command to start docker daemon as shell starts
# if [ -d ~/.docker ]; then
#     eval "$(docker-machine env default)"
# fi

if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
else
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
fi

if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
else
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi
#===============================================================================
#   PROMPT
#===============================================================================
#Shell prompt customisation with Blue time and bright green directory.
# export PS1="\[\e[0;36m\]\t \[\e[0;32m\]\w \[\e[0;92m\]:: \[\e[0m\]"
#Shell prompt customisation with Grey time, exit code status, blue directory and git branch informations.
export PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\e[01;34m\]\w\[\e[00m\] `[[ $(git status 2> /dev/null | head -n5 | tail -n1) == "nothing to commit, working directory clean" ]] && echo "\[\e[01;32m\]"$(__git_ps1 "(%s)") || echo "\[\e[01;31m\]"$(__git_ps1 "(%s)")` \[\e[00m\]:: '
#===============================================================================
#   PATH EXPORTS
#===============================================================================
# Setting PATH for EPD-6.3-1
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/EPD64.framework/Versions/Current/bin:${PATH}"
export PATH

# juliaVersion=`julia --version | awk '{ print $3 }'`
juliaVersion=`cd /Applications && ls | grep -i julia`
PATH="/Applications/$juliaVersion/Contents/Resources/julia/bin:${PATH}"
export PATH
# MacPorts Installer addition on 2010-11-26_at_17:56:28: adding an appropriate PATH variable for use with MacPorts.
##
# Your previous $HOME/.bash_profile file was backed up as $HOME/.bash_profile.macports-saved_2010-11-26_at_17:56:28
##
#export PATH="$HOME/anaconda/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.
# adding path for bash script to allow battery status bar in tmux
export PATH="$HOME/Documents/tmux/bin:$PATH"
# added by Anaconda3 2.1.0 installer
export PATH="$HOME/anaconda3/bin:$PATH"
# path for mysql
export PATH="/usr/local/mysql/bin:$PATH"
# mongodb PATH
export PATH="$HOME/mongodb/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
# Path to allow coreutils to use default names instead of having each one prefixed with g.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# jMusic classpath
export CLASSPATH="$HOME/jMusic/jmusic.jar:Users/tarek_allam/jMusic/inst/:$CLASSPATH"
#===============================================================================
#   COLOUR CUSTOMISATION
#===============================================================================
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad # Blue
export GREP_OPTIONS="--color=auto"
# Source for colouring of grep output.
source "`brew --prefix grc`/etc/grc.bashrc"
#===============================================================================
#   ALIASES
#===============================================================================
# force tmux to use 256 colours
#alias tmux="TERM=screen-256color-bce tmux"
# ipython
alias pylab="ipython -pylab"
# force tmux to use 256 colours
alias tmux="tmux -2"
# listing in colour and easy quitting
#alias ls="ls -Gh"
alias ls="ls --color"
alias cl="clear"
alias la="ls -lah"
alias qq="exit"
alias grep="grep -E"
# put computer to sleep
alias sleep="sudo shutdown -s now"
# colourful version of cat command
alias pat="pygmentize -g"
# application shortcuts
alias chrome="open /Applications/Google\ Chrome.app/"
alias poker="open /Applications/PokerStarsUK.app/"
alias fire="open -a /Applications/Firefox.app/"
# sublime shortcut
alias sub="open -a /Applications/Sublime\ Text\ 2.app/"
alias rr="R CMD BATCH "
alias xx="chmod +x"
alias todo="vim `$DATE`.md"
alias lsg="ls | grep -i"
alias crontabedit="env EDITOR=vim crontab -e"
alias ff="gfortran"
alias dockerdaemon="eval '$(docker-machine env default)'"
alias pingg="ping www.google.com"
alias kali="docker run -t -i kali /bin/bash"
#===============================================================================
#   MISC.
#===============================================================================
MKL_NUM_THREADS=1
export MKL_NUM_THREADS
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Global variable for date format YY-MM-DD
DATE='date +%Y-%m-%d'
export DATE
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=$HOME/.docker/machine/machines/default
export DOCKER_TLS_VERIFY=1
