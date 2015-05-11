MKL_NUM_THREADS=1
export MKL_NUM_THREADS

#Shell prompt customisation
#PS1="\[\033[0;41m\]\u @\t> \w: \[\033[0m\]"
#export PS1
#export PS1="\[\e[0;35m\]\u \[\e[0;36m\]\t \[\e[0;33m\]\w \[\e[0;33m\]:: \[\e[0m\]"
#export PS1="\[\e[0;35m\]\u \[\e[0;36m\]\t \[\e[0;33m\]\w \[\e[0m\]"

alias mp="cd ~/Google\ Drive/ucl_2015/MajorProject"

#Find .bashrc file and source.
if [ -f ~/.bashrc ]; then
	   source ~/.bashrc
fi

source "`brew --prefix grc`/etc/grc.bashrc"
