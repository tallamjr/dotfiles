# added by Anaconda 2.3.0 installer - if moved it loads 3.4 python
export PATH="$HOME/anaconda/bin:$PATH"
# export PATH="/usr/local/opt/ruby/bin:$PATH"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tallamjr/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/tallamjr/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/tallamjr/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/tallamjr/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/tallamjr/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/tallamjr/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

#Find .bashrc file and source.
if [ -f ~/.bashrc ]; then
       source ~/.bashrc
fi


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
. "$HOME/.cargo/env"
export PATH="/opt/homebrew/sbin:$PATH"
