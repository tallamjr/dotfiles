
function _omb_theme_PROMPT_COMMAND() {

  # check if system is darwin
  if [ "$(uname)" == "Darwin" ]; then
    PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\e[01;34m\]\w\[\e[00m\] `[[ $(git status 2> /dev/null | head -n5 | tail -n1) == "nothing to commit, working tree clean" ]] && echo "\[\e[01;32m\]"$(__git_ps1 "(%s)") || echo "\[\e[01;31m\]"$(__git_ps1 "(%s)")` \[\e[00m\]:: '
  else
    PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi``hostname`\[\e[01;34m\]\w\[\e[00m\] `[[ $(git status 2> /dev/null | head -n5 | tail -n1) == "nothing to commit, working tree clean" ]] && echo "\[\e[01;32m\]"$(__git_ps1 "(%s)") || echo "\[\e[01;31m\]"$(__git_ps1 "(%s)")` \[\e[00m\]:: '
  fi
  PROMPT_DIRTRIM=5
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND

