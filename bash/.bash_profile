if [ -f ~/.bashrc ]; then
       source ~/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
. "$HOME/.cargo/env"
export PATH="/opt/homebrew/sbin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniforge/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

. "/Users/tallam/.deno/env"