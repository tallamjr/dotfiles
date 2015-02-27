#===============================================================================
#PROMPT
#===============================================================================
export PS1="\[\e[0;35m\]\u \[\e[0;36m\]\t \[\e[0;33m\]\w \[\e[0;33m\]:: \[\e[0m\]"
#===============================================================================
#PATH EXPORTS
#===============================================================================
# Setting PATH for EPD-6.3-1
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/EPD64.framework/Versions/Current/bin:${PATH}"
export PATH
# MacPorts Installer addition on 2010-11-26_at_17:56:28: adding an appropriate PATH variable for use with MacPorts.
##
# Your previous /Users/tarek_allam/.bash_profile file was backed up as /Users/tarek_allam/.bash_profile.macports-saved_2010-11-26_at_17:56:28
##
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.
# adding path for bash script to allow battery status bar in tmux
export PATH="/Users/tarek_allam/Documents/tmux/bin:$PATH"
# added by Anaconda3 2.1.0 installer
export PATH="/Users/tarek_allam/anaconda3/bin:$PATH"
# path for mysql
export PATH="/usr/local/mysql/bin:$PATH"
#===============================================================================
#COLOUR CUSTOMISATION
#===============================================================================
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad # Blue
#export LSCOLORS=GxFxCxDxBxegedabagaced - Green
#export LSCOLORS=exfxcxdxbxegedabagacad - Blue
#export LSCOLORS=Cxfxcxdxbxegedabagacad
#export LSCOLORS=Dxfxcxdxbxegedabagacad - Yellow
export GREP_OPTIONS="--color=auto"
#===============================================================================
#ALIASES
#===============================================================================
# force tmux to use 256 colours
#alias tmux="TERM=screen-256color-bce tmux"
# ipython 
alias pylab="ipython -pylab"
# force tmux to use 256 colours
alias tmux="tmux -2"
# sublime shortcut
alias sub="open -a /Applications/Sublime\ Text\ 2.app/"
# azure mysql connection shortcut
alias dbcw="mysql -h eu-cdbr-azure-north-b.cloudapp.net -u b868b961e0bfe6 -p554e5f66 -D MarkingP2PDB"

alias ls="ls -Gh"
alias cl="clear"
alias la="ls -la"
alias qq="exit"

alias sleep="sudo shutdown -s now"
