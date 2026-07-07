# ==================================================================================================
#                                           INITIALISATION
# ==================================================================================================
# Vim key-bindings for movement within the shell.
set -o vi
# bash History
# What is the difference between HISTSIZE vs. HISTFILESIZE?
# http://stackoverflow.com/questions/19454837/bash-histsize-vs-histfilesize
export HISTSIZE=-1
export HISTFILESIZE=-1
export HISTTIMEFORMAT='%d/%m/%y %H:%M '
export HISTCONTROL=ignoreboth:erasedups
# export HISTIGNORE="pwd:ls *:la:cl:cd *:ppwd:vim *:whoami: git add *:git ss: git co *:git commit"
unset HISTIGNORE

# Refs:
# - https://unix.stackexchange.com/a/131507
# - https://phoenixnap.com/kb/linux-history-command
shopt -s histappend
export PROMPT_COMMAND="history -a;history -c;history -r"

export PAGER="less --IGNORE-CASE"
export GIT_PAGER="less --IGNORE-CASE"

which nvim > /dev/null; exitCode=$?
if [[ ${exitCode} -eq 0 ]]; then
	export EDITOR=nvim
	export GIT_EDITOR=nvim
	alias vimdiff="nvim -d"
else
	export EDITOR=vim
	export GIT_EDITOR=vim
fi

# Temporay directory
export TMP=/tmp

# # For Git completion
# if [ -f ~/.git-completion.bash ]; then
# 	source ~/.git-completion.bash
# else
# 	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
# fi
#
# # For Git branch information in prompt
# if [ -f ~/.git-prompt.sh ]; then
#   source ~/.git-prompt.sh
# else
#   curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
# fi

# ==================================================================================================
#                                           OH-MY-BASH
# ==================================================================================================
if [ -d ~/.oh-my-bash ]; then
	:
else
	git clone git@github.com:ohmybash/oh-my-bash.git ~/.oh-my-bash
	cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.ombrc
fi

if [ -f ~/.ombrc ]; then
	source ~/.ombrc
fi

# ==================================================================================================
#                                           FZF
# ==================================================================================================

# If fuzzy finder installed, source
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='\\'
# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# ==================================================================================================
#                                           PATH EXPORTS
# ==================================================================================================

# Setting PATH for EPD-6.3-1
# The orginal version is saved in .bash_profile.pysave
export PATH="/Library/Frameworks/EPD64.framework/Versions/Current/bin:${PATH}"
export PATH="/usr/bin:${PATH}"

# Homebrew install path:
# •   macOS ARM: /opt/homebrew
# •   macOS Intel: /usr/local
# •   Linux: /home/linuxbrew/.linuxbrew

if [ $(uname -m) == "x86_64" ]; then
	export PATH="/usr/local/bin:$PATH"
	# Allows Coreutils package to be used without 'g' prefix before each command.
	export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
	export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
	export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
	if [ $(uname) == "Linux" ]; then
		# Export path variables for linuxbrew.
		export PATH="$HOME/.linuxbrew/bin:$PATH"
		export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
		export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	fi
else
	# Running on Apple silicon
	export PATH="/opt/homebrew/bin:$PATH"
	# Allows Coreutils package to be used without 'g' prefix before each command.
	export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
	export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
	export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
	export PATH="/opt/homebrew/grep/libexec/gnubin:$PATH"
fi

# HOMEBREW PREFIX
export BREW_PREFIX=$(brew --prefix)
export BREW_CELLAR=$(brew --cellar)
export BREW_CASKROOM=$(brew --caskroom)
export HOMEBREW_NO_AUTO_UPDATE=1 # Do not auto update everything
export HOMEBREW_AUTOREMOVE=1
# --appdir=/my/path changes the path where the symlinks to the applications
# (above) will be generated. This is commonly used to create the links in the
# root Applications directory instead of the home Applications directory by
# specifying --appdir=/Applications. Default is ~/Applications. See
# https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export HOMEBREW_MAKE_JOBS=8

# Why this line?
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Homemade scripts
export PATH="$HOME/github/tallamjr/origin/scripts:$PATH"
# Cronjobs
export PATH="$HOME/cronjobs:$PATH"
# TMUX Battery Status
export PATH="$HOME/Documents/tmux/bin:$PATH"
# MySQL
export PATH="$BREW_PREFIX/mysql/bin:$PATH"

# Ghidra SRE
export GHIDRA_HOME="$HOME/bin/ghidra_9.1.2_PUBLIC"
export PATH="$GHIDRA_HOME:$PATH"
alias ghd="cd $GHIDRA_HOME && ./ghidraRun"

export PATH="$HOME/bin:$PATH"

# gitlatex path:
export PATH=~/scratch/build:$PATH

# grpcio -- https://stackoverflow.com/a/68137855/4521950
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

# ==================================================================================================
#                                           PYTHON
# ==================================================================================================
# Python environment with uv
# uv is managed through shell integration

source $HOME/github/tallamjr/origin/scripts/uvup.sh

# https://github.com/conda/conda/issues/6018
export PYTHONNOUSERSITE=True
export PYTHONHASHSEED=0

# ==================================================================================================
#                                           PROMPT
# ==================================================================================================
# Shell prompt customisation with Grey time, exit code status, blue directory
# and git branch informations. Needs to be on one line
# export PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\e[01;34m\]\w\[\e[00m\] `[[ $(git status 2> /dev/null | head -n5 | tail -n1) == "nothing to commit, working tree clean" ]] && echo "\[\e[01;32m\]"$(__git_ps1 "(%s)") || echo "\[\e[01;31m\]"$(__git_ps1 "(%s)")` \[\e[00m\]:: '

# ==================================================================================================
#                                           COLOUR CUSTOMISATION
# ==================================================================================================

export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad # Blue directories
export GREP_OPTIONS="--color=auto"

# ==================================================================================================
#                                           JAVA
# ==================================================================================================
export JAVA_HOME="$(/usr/libexec/java_home --version 1.8)"

# ==================================================================================================
#                                           RUST
# ==================================================================================================

export PATH="$HOME/.cargo/bin:$PATH"
RUST_ANALYZER_VERSION=$(brew list --versions rust-analyzer | awk '{print }')
# rust-analyzer
export PATH="$BREW_PREFIX/Cellar/rust-analyzer/$RUST_ANALYZER_VERSION/bin:$PATH"
# debug
export RUST_BACKTRACE=1     # Backtrace on
# export RUST_BACKTRACE=full # Verbosity full

# ==================================================================================================
#                                           OPTION3
# ==================================================================================================

export OPTION3_HOME=$HOME/github/origin/option3

# ==================================================================================================
#                                           GOLANG
# ==================================================================================================

export PATH="$BREW_PREFIX/opt/bison/bin:$PATH"
export C_INCLUDE_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include"
# ==================================================================================================
#                                       KAGGKE
# ==================================================================================================

export KAGGLE_HOME="$HOME/github/origin/kaggle"
export KG_TITANIC_HOME="$KAGGLE_HOME/Titanic"

# ==================================================================================================
#                                       MISCELLANEOUS
# ==================================================================================================
export MKL_NUM_THREADS=1

# Global variable for date format YY-MM-DD
export DATE=$(date +'%A %b %d %Y')

# Command line cheat
export CHEATCOLORS=true

# Tensorflow
export TF_CPP_MIN_LOG_LEVEL=2

# Kaggle
export KAGGLE_CONFIG_DIR=$HOME/.kaggle/

# Apache Arrow Compilation
# export ARROW_HOME=$BREW_PREFIX/anaconda3/envs/pyarrow-dev
export PYARROW_WITH_FLIGHT=1
export PYARROW_WITH_GANDIVA=1
export PYARROW_WITH_ORC=1
export PYARROW_WITH_PARQUET=1
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# export CC=`which clang`
# export CXX=`which clang++`

GCC_VERSION=$(brew list --versions gcc | awk '{print $2}' | cut -d '.' -f1)
export PATH="/opt/homebrew/bin/gcc-$GCC_VERSION:$PATH"
alias gcc="gcc-$GCC_VERSION"

export CC=$(which gcc-$GCC_VERSION)
export CXX=$(which g++-$GCC_VERSION)
export LC_ALL="en_US.UTF-8"

# Scala
export SCALA_HOME="$BREW_PREFIX/opt/scala"
export PATH="$PATH:$SCALA_HOME/bin"

# GNU sed
export PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"

# 4B25-Cambridge-EB3
export ARMGCC_DIR="$BREW_PREFIX"

# If you need to have llvm first in your PATH run:
export PATH="$BREW_PREFIX/opt/llvm/bin:$PATH"

# For compilers to find llvm you may need to set:
export LDFLAGS="-L$BREW_PREFIX/opt/llvm/lib $LDFLAGS"
export CPPFLAGS="-I$BREW_PREFIX/opt/llvm/include $CPPFLAGS"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

alias db="export LOCAL_DEBUG=0"
alias ndb="unset LOCAL_DEBUG"

. "$HOME/.cargo/env"

export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

export PYTORCH_ENABLE_MPS_FALLBACK=1

export BUILDKIT_COLORS=run=green:warning=yellow:error=red:cancel=255,165,0

# export SHELL=/bin/bash

export TVM_HOME=/Users/tallam/github/tallamjr/forks/tvm
export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}

# Use a Python environment with PyTorch installed.
export LIBTORCH_USE_PYTORCH=1

# https://stackoverflow.com/a/67361161/4521950
# Fixes: docker: no matching manifest for linux/arm64/v8 in the manifest list entries.
export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
export PATH="/opt/homebrew/opt/socket_vmnet/bin:$PATH"
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

export BAT_THEME="1337"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# ==================================================================================================
#                                           ALIASES
# ==================================================================================================

alias audio-dl='youtube-dl -x --audio-format "wav" --audio-quality 0'
alias bashrc="vim ~/.bashrc"
alias blc="black . --check"
alias brewski='brew update && brew upgrade && brew doctor && brew cleanup --prune=all'
alias brewversion="$(brew config | grep 'HOMEBREW_VERSION' | awk '{print $2}')"
# alias ca="conda activate"
alias cargo="cargo +nightly"
# alias condasource="source $HOME/github/tallamjr/origin/scripts/condasource.sh"
alias chrome="open /Applications/Google\ Chrome.app/"
alias cl="clear"
alias cleanme="docker system prune -a --volumes && brew cleanup --prune=all && brew cask cleanup && rm -rf \"$(brew --cache)\""
alias crontabedit="env EDITOR=vim crontab -e" # Edit crontab with vim
alias docling="docling --pipeline vlm --vlm-model smoldocling --image-export-mode placeholder"
alias df="df -h"
alias dls="cd ~/Downloads/ && la -rt"
alias du="du -sh"
alias dus="du -sh * | sort -h"
alias echof='echo "`f`"'
alias f="history -a;history -n;history -r;fzf -i --color=hl:200,hl+:200"
alias gethash="git show | head -1 | cut -d' ' -f2 | cut -c1-7 | pbcopy"
alias gg="grep -i"
alias ghub="cd ~/github/"
alias gl="cd ~/gitlab/git.arg/"
alias gpu="watch sudo powermetrics --samplers gpu_power -i500 -n1"
alias grep="grep -E"
alias hashme="git show | head -1 | cut -d' ' -f2 | cut -c1-7"
alias ino="arduino-cli"
# alias jc="jupyter nbconvert --ClearOutputPreprocessor.enabled=True --ClearMetadataPreprocessor.enabled=True --clear-output --inplace"
alias jbb="jupyter-book build"
alias jc="jupyter nbconvert --ClearOutputPreprocessor.enabled=True --clear-output --inplace"
alias jn="jupyter notebook"
alias kali="dockerdaemon && docker run -t -i kali:latest /bin/bash" # Start Kalilinux via docker vm.
alias la="ls -lah"                                                  # Listing in human-readable format
alias lrt="ls -lahrt"
alias ls="ls --color"                  # Listing in colour
alias lsc="ls | wc | awk '{print $1}'" # Show the 'count' of files in a director.
alias lsg="ls | grep -i"               # Search a directory listing with grep case-insensitive.
alias matlab="matlab -nodesktop -nosplash"
# mkdocs serve, preferring the project's uv environment when one exists
mks() {
    # Find the first free TCP port starting from 8000
    local port=8000
    while lsof -iTCP:"$port" -sTCP:LISTEN -t >/dev/null 2>&1; do
        port=$((port + 1))
    done

    if [ "$port" -ne 8000 ]; then
        echo "Port 8000 in use, serving on $port instead" >&2
    fi

    if { [ -f uv.lock ] || [ -f pyproject.toml ]; } && command -v uv >/dev/null 2>&1; then
        uv run mkdocs serve -a "localhost:$port" --open "$@"
    else
        mkdocs serve -a "localhost:$port" --open "$@"
    fi
}
alias nq="networkQuality"
alias openf='open "`f`"'
alias pat="pygmentize -g" # Colourful 'cat' output
alias pdflatex="pdflatex -interaction nonstopmode -halt-on-error -file-line-error"
alias pingg="ping www.google.com"
alias pj="python -m json.tool"
alias pn="vim -O $HOME/PhD/wiki/index.markdown $HOME/PhD/wiki/diary/$(date +%Y-%m-%d).markdown"
alias pm="podman"
alias poker="open /Applications/PokerStarsUK.app/"
alias printhash="git show | head -1 | cut -d' ' -f2 | cut -c1-7"
alias pt='pytest --verbose --capture=no --showlocals --durations=0 --setup-show'
alias pylab="ipython -pylab" # Ipython
alias qq="exit"
alias resetusb='sudo launchctl stop com.apple.usbd; sudo launchctl start com.apple.usbd'
# alias rmbiber="rm -rf $(biber --cache)"
alias rr="R CMD BATCH "
alias rspace="rename \"s/ /-/g\" * && rename \"s/[\(\)]//g\" *"
alias rrs="rsync -avzh --progress --stats"
alias sb="source ~/.bashrc"
alias sleep="sudo shutdown -s now" # Put computer to sleep
alias speed="speedtest-cli"
alias tc="texcount -inc -total"
alias tmp="cd /tmp"
alias transcript="youtube_transcript_api --format text"
alias tree="tree -I '*__pycache__|*.pkl'"
alias triple="rustc -vV | sed -n 's/^host: \\(.*\\)$/\\1/p'"
alias tmux="tmux -2" # Force tmux to use 256 colours
alias todo="\vim +VimwikiUISelect"
alias ttop="top -o CPU"
# Check for Neovim
which nvim > /dev/null; exitCode=$?
if [[ ${exitCode} -eq 0 ]]; then
  alias vim="nvim"
  alias vi="nvim"
  alias nnvim="nvim ~/.config/nvim"
fi
alias vimf='vim `f`'
alias vimplugininstall="vim +PluginInstall +qall" # Vim pluin install from command line.
alias vimrc="vim ~/.vimrc"
alias vimn="vim +NERDTree"
alias watch="watch --differences"
alias wiki="vim +VimwikiIndex"
alias wpp="which pip && which python && python --version"
alias xx="chmod +x" # Make file executable

alias uvpi="uv pip install --python=$(which python)"

# ==================================================================================================
#                                           FUNCTIONS
# ==================================================================================================

function mcp-add-local() {

	"$@" --scope project

}

function ds() {
  docker ps -q --filter ancestor="$1" | xargs -r docker stop
}

function pip() {
  uv pip "$@"
  exitCode=$?
  if [[ ${exitCode} -ne 0 ]]; then
    # ref: https://github.com/astral-sh/uv/issues/3951
    echo "\t If error message reads: 'error: No Python interpreters found in virtual environments'\n"
    echo "\t Then you may need to run: \n"
    echo "\t\t $ uv pip install --python=$(which python) ..."
  fi
}

function cec() {

  ENV_NAME=$1
  echo "Use uv for Python environment management:"
  echo "  uv venv $ENV_NAME"
  echo "  source $ENV_NAME/bin/activate"
  echo "  uv pip install -e ."

}

function caff() {
  ENV_NAME=`cat environment.yml | sed -n 's/^name: \(.*\)$/\1/p'`
  # Use uv for Python environment management
  echo "Use 'uv venv' to create virtual environments"
  echo "Use 'uv pip install -e .' to install from pyproject.toml"
  if [[ ! -f requirements.txt ]]; then
    touch requirements.txt
  fi
}

function texdd() {

	OLD=$1
	NEW=$2
	FILE=$3

	latexdiff-vc \
		--config LATEX="pdflatex --interaction=nonstopmode" \
		--flatten \
		--pdf \
		--git \
		--revision $OLD --revision $NEW \
		$FILE

	open "${FILE%%.*}"-diff$old-$new.pdf

}

function cdd() {
	cd $(python -c "print($1 * '../')")
}

function lm() {
	# Refs: https://stackoverflow.com/a/965069/4521950
	FILE=$1

	pdflatex "${FILE#*.}"
	bibtex "${FILE%%.*}"
	pdflatex "${FILE#*.}"
	open "${FILE%%.*}".pdf

}

function lmm() {
	# Refs: https://stackoverflow.com/a/7820227/4521950
	FILE=$1
	BASENAME=$(basename $FILE .tex)

	pdflatex $BASENAME
	biber $BASENAME
	latexmk -pdf $FILE # https://tex.stackexchange.com/a/617203/84541
	pdflatex $FILE
	open $BASENAME.pdf

}

function mvn2sbt() {
	# Convert pom.xml --> build.sbt file
	# Adapted from https://stackoverflow.com/questions/2972195/migrating-from-maven-to-sbt
	if [ "$1" == "--java" ]; then

		echo 'name := "Tarek Allam Jr"' >>build.sbt
		echo 'version := "0.1"' >>build.sbt
		echo 'organization := "org.aar.tallamjr"' >>build.sbt

		echo 'javacOptions in (Compile, compile) ++= Seq("-source", "1.8", "-target", "1.8", "-g:lines")' >>build.sbt

		echo 'crossPaths := false // drop off Scala suffix from artifact names.' >>build.sbt
		echo 'autoScalaLibrary := false // exclude scala-library from dependencies' >>build.sbt

		mvn dependency:tree | grep "] +" | perl -pe 's/.*\s([\w\.\-]+):([\w\.\-]+):\w+:([\w\.\-]+):(\w+).*/libraryDependencies += "$1" % "$2" % "$3" % "$4"\n /' >>build.sbt
		sed -i '/^\[/ d' build.sbt

	else

		echo 'name := "Tarek Allam Jr"' >>build.sbt
		echo 'version := "0.1"' >>build.sbt
		echo 'organization := "org.aar.tallamjr"' >>build.sbt

		mvn dependency:tree | grep "] +" | perl -pe 's/.*\s([\w\.\-]+):([\w\.\-]+):\w+:([\w\.\-]+):(\w+).*/libraryDependencies += "$1" % "$2" % "$3" % "$4"\n /' >>build.sbt
		sed -i '/^\[/ d' build.sbt
	fi
}

function dockerrmi() {
	# Remove docker image by name

	if [ "$1" == "--force" ]; then

		DOCKER_IMAGE_NAME=$2
		docker rmi -f $(docker images --filter=reference="$DOCKER_IMAGE_NAME" --format "{{.ID}}")
	else
		DOCKER_IMAGE_NAME=$1
		docker rmi $(docker images --filter=reference="$DOCKER_IMAGE_NAME" --format "{{.ID}}")
	fi

}

function arxiv() {
	# Get source files from arxiv.org and create folder of them
	TAR=$1.tar.gz
	NEW_NAME="$2-$1"
	NEW_LOCATION=$HOME/Downloads/arxiv-downloads/$NEW_NAME

	mv $1 $TAR
	mkdir -p $NEW_LOCATION
	mv $TAR $NEW_LOCATION
	cd $NEW_LOCATION
	tar -zxvf "$TAR"
}

function sbtsubmit() {

	sbt "submit t.allam.jr@gmail.com $@"

}

function new() {

	if [ "$1" == "scala" ]; then

		mkdir -p src/{main,test}/{java,resources,scala}
		echo 'name := ""
version := "1.0"
scalaVersion := "2.13.1"

libraryDependencies ++= Seq(
    "org.scalactic" %% "scalactic" % "3.0.8",
    "org.scalatest" %% "scalatest" % "3.0.8" % "test"
)
' >build.sbt
	fi

}

function portal() {
	# Create local portal to Hypatia for use of notebooks on cluster
	PORTNUMBER=$1
	NODENUMBER=$2
	ssh -t -t tallam@hypatia -L $PORTNUMBER:localhost:$PORTNUMBER ssh compute-0-$NODENUMBER -L $PORTNUMBER:localhost:$PORTNUMBER
}

function mkcd() {
	# Make directory and cd into it straight away.
	mkdir $1 && cd $1
}

function cmdfu() {
	# Get random command line fact from commanlinefu.com
	curl "http://www.commandlinefu.com/commands/matching/$(echo "$@" | sed 's/ /-/g')/$(echo -n $@ | base64)/plaintext"
}

function calc() {
	# Python calculator
	python -ic "from __future__ import division; from math import *; from random import *"
}

function lag() {
	# List of files in a directory and grep for a certain one.
	ls -la | grep -i "$1" | awk '{print $9}'
}

function devlog() {
	# PhD Development Logbook
	vim ~/PhD/project/logs/logbook-$(date +%Y%W).md
}

function so() {
	# Size Of - folder, then sort in human readable form.
	du -s "$1" | sort -h
}

function ppwd() {
	# Get PWD variable and copy to system clipboard - OSX specific.
	echo $PWD | pbcopy
}

function jj() {
	# Compile and then run java code.
	javac $1 && java $(basename $1 .java)
}

function bdd() {

	ORG=$1
	TAG_VERSION=$(git describe --tags)
	REPO_NAME=${PWD##*/}
	docker build --tag=$REPO_NAME .
	for tag in {$TAG_VERSION,latest}; do
		docker tag $REPO_NAME $ORG/$REPO_NAME:${tag}
		docker push $ORG/$REPO_NAME:${tag}
	done
}

function extract() {
	# Extract any compressed file, courtsey https://efavdb.com/dotfiles/
	if [ -f "$1" ]; then
		case "$1" in
		*.tar.bz2) tar -jxvf "$1" ;;
		*.tar.gz) tar -zxvf "$1" ;;
		*.bz2) bunzip2 "$1" ;;
		*.dmg) hdiutil mount "$1" ;;
		*.gz) gunzip "$1" ;;
		*.tar) tar -xvf "$1" ;;
		*.tbz2) tar -jxvf "$1" ;;
		*.tgz) tar -zxvf "$1" ;;
		*.zip) unzip "$1" ;;
		*.ZIP) unzip "$1" ;;
		*.pax) cat "$1" | pax -r ;;
		*.pax.Z) uncompress "$1" --stdout | pax -r ;;
		*.Z) uncompress "$1" ;;
		*) echo "'$1' cannot be extracted/mounted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file to extract"
	fi
}

function ccmake() {
	# Don't invoke cmake from the top-of-tree
	if [ -e "CMakeLists.txt" ]; then
		echo "CMakeLists.txt file present, cowardly refusing to invoke cmake..."
	else
		ccmake_path=$(which ccmake)
		# /usr/bin/cmake $*
		$ccmake_path $*
	fi
}

function checkrunners() {
	gh api orgs/ati-arg/actions/runners \
  --jq '.runners[] | "\(.name): \(.status), busy=\(.busy)"'
}

function newp() {
	uv venv --python "$1"
	source .venv/bin/activate
	uv pip install pip
	wpp
}

function pythonversion() {
	# Check version of install Python package
	# python -c "import $1; print($1.__version__)"
	pip list | grep $1
}

function mid () {
  FILE=$1
  filename="${FILE%%.*}"
  if command -v markitdown >/dev/null; then
    markitdown "$1" > "${filename}.md"
  else
    pip install 'markitdown[all]'
    markitdown "$1" > "${filename}.md"
  fi
}

function frameworkpython {
	if [[ ! -z "$VIRTUAL_ENV" ]]; then
		PYTHONHOME=$VIRTUAL_ENV /usr/local/bin/python "$@"
	else
		/usr/local/bin/python "$@"
	fi
}

function fcc() {
	# Fix-command but without previous command
	fc -e "vim -c '1d' -c 'normal! ggOcodex' -c 'startinsert'"
}

function cx() {
	# Fix-command but without previous command
	fc -e "vim -c '1d' -c 'normal! ggOcodex  ' -c 'startinsert'"
}

function turl() {
	TINY_URL_BASE="http://tinyurl.com/api-create.php?url="
	LINK=$1
	curl -s $TINY_URL_BASE$LINK
}

function auto_activate_venv() {
    # Check if a .venv directory exists and is readable
    if [ -d ".venv" ] && [ -r ".venv/bin/activate" ]; then
        # Check if the activate script looks like a valid virtualenv script
        if grep -q "VIRTUAL_ENV" ".venv/bin/activate" && grep -q "deactivate" ".venv/bin/activate"; then
            # Source the virtual environment
            echo "Auto-activating virtualenv in $(pwd)"
            source .venv/bin/activate
        else
            echo "Warning: .venv/bin/activate script does not appear to be a valid virtualenv."
        fi
    fi
}

# Call the function each time you change directories
# export PROMPT_COMMAND="auto_activate_venv; $PROMPT_COMMAND"

. "/Users/tallam/.deno/env"

export PATH="$PATH:/opt/homebrew/opt/riscv-gnu-toolchain/bin"

export DYLD_LIBRARY_PATH=/Users/tallam/github/tallamjr/origin/pup/.venv/lib/python3.11/site-packages/onnxruntime/capi:$DYLD_LIBRARY_PATH

# macOS cross compiler toolchains
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-linux-gnu-gcc
export CC_x86_64_unknown_linux_gnu=x86_64-linux-gnu-gcc
export CXX_x86_64_unknown_linux_gnu=x86_64-linux-gnu-g++
export AR_x86_64_unknown_linux_gnu=x86_64-linux-gnu-ar

export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc
export CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
export CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
export AR_aarch64_unknown_linux_gnu=aarch64-linux-gnu-ar

export BAUDRATE="115200"

LDLIBS="-L/usr/local/lib -L/opt/local/lib -lftdi -lm"
CFLAGS="-MD -O0 -ggdb -Wall -std=c99 -I/usr/local/include -I/opt/local/include/"

# turn off daft telemetry
export DAFT_ANALYTICS_ENABLED=0
export SCARF_NO_ANALYTICS=true
export DO_NOT_TRACK=true

export TMPDIR=/tmp

export NODE_OPTIONS="--max-old-space-size=4096"

export QUARTO_PYTHON="$HOME/.venv/bin/python"

export CLICOLOR_FORCE=1
alias watch="fswatch"

# claude
export DISABLE_ERROR_REPORTING=1
export DISABLE_TELEMETRY=1
export DISABLE_BUG_COMMAND=1
alias yolo="claude --dangerously-skip-permissions"

alias cbp="cargo bump patch && cargo check && git add Cargo.toml && git add Cargo.lock && git commit --amend --no-edit"
alias cbm="cargo bump minor && cargo check && git add Cargo.toml && git add Cargo.lock && git commit --amend --no-edit"

export HOMEBREW_DEVELOPER=1
export HOMEBREW_FORCE_BREWED_CURL=1

alias pc="pre-commit run --all-files"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/tallam/.lmstudio/bin"
# End of LM Studio CLI section

export DYLD_ROOT_PATH="$(xcrun --sdk iphonesimulator --show-sdk-path)"

# Locate file containing passwords and global variables that will be sourced within other files.
if [ -f ~/.localrc ]; then
	source ~/.localrc
fi

export PATH="$PATH:/Applications/KiCad/KiCad.app/Contents/MacOS"

export RISCV_XHEEP="$HOME/tools/risc-v"

export RUSTUP_AUTO_INSTALL=0

export UV_NO_CACHE=1
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#                                               EOF
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# >>> chipmunk PATH (added by build) >>>
export PATH="/Users/tallam/github/tallamjr/forks/chipmunk/bin:$PATH"
# <<< chipmunk PATH (added by build) <<<
