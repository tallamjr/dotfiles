#Find .bashrc file and source.
if [ -f ~/.bashrc ]; then
	   source ~/.bashrc
fi

# added by Anaconda 2.3.0 installer - if moved it loads 3.4 python 
export PATH="$HOME/anaconda/bin:$PATH"

# test -r /sw/bin/init.sh && . /sw/bin/init.sh
