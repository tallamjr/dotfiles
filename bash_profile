MKL_NUM_THREADS=1
export MKL_NUM_THREADS

#Shell prompt customisation
PS1="\[\033[0;41m\]\u @\t> \w: \[\033[0m\]"
export PS1

#Find .bashrc file and source.
if [ -f ~/.bashrc ]; then
	   source ~/.bashrc
fi

source "`brew --prefix grc`/etc/grc.bashrc"
