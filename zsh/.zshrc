#bindkey -v
. /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# added by travis gem
[ -f /Users/tallamjr/.travis/travis.sh ] && source /Users/tallamjr/.travis/travis.sh

. "$HOME/.cargo/env"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
