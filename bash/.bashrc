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
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTCONTROL=ignoredups
export HISTIGNORE="pwd:ls:la:cl"
# Ref: https://unix.stackexchange.com/a/131507
export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a; history -n"

export PAGER=less
export EDITOR=vim

export GIT_EDITOR=vim
export GIT_PAGER=less

# Locate file containing passwords and global variables that will be sourced within other files.
if [ -f ~/.localrc ]; then
	source ~/.localrc
fi
# For Git completion
if [ -f ~/.git-completion.bash ]; then
	source ~/.git-completion.bash
else
	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
fi
# For Git branch information in prompt
if [ -f ~/.git-prompt.sh ]; then
	source ~/.git-prompt.sh
else
	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi
# If fuzzy finder installed, source
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Temporay directory
export TMP=/tmp
# ==================================================================================================
#                                           PATH EXPORTS
# ==================================================================================================
# Setting PATH for EPD-6.3-1
# The orginal version is saved in .bash_profile.pysave
export PATH="/Library/Frameworks/EPD64.framework/Versions/Current/bin:${PATH}"
export PATH="/usr/bin:${PATH}"

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
	export PATH="/opt/homebrew/bin/gcc-11:$PATH"
	# Allows Coreutils package to be used without 'g' prefix before each command.
	export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
	export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
	export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
	export PATH="/opt/homebrew/grep/libexec/gnubin:$PATH"
fi

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
# Mongodb PATH
export PATH="$HOME/mongodb/bin:$PATH"

# MATLAB command line.
export MATLAB_EXECUTABLE=/Applications/MATLAB_R2017a.app/bin/matlab
export PATH="/Applications/MATLAB_R2017a.app/bin:$PATH"
# MacTex binaries
# export PATH="$(dirname `which latex`):$PATH"
# Github cli fork
# export PATH="$HOME/github/tallamjr/forks/cli/bin:$PATH"
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
#                                           PYTHON/CONDA
# ==================================================================================================
# Main env miniforge
export PATH="$PATH:${BREW_CASKROOM}/miniforge/base/envs/main/bin"

# source $HOME/github/tallamjr/origin/scripts/condasource.sh

# https://github.com/conda/conda/issues/6018
export PYTHONNOUSERSITE=True
export PYTHONHASHSEED=0
# ==================================================================================================
#                                           PROMPT
# ==================================================================================================
# Shell prompt customisation with Grey time, exit code status, blue directory
# and git branch informations. Needs to be on one line
export PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\e[01;34m\]\w\[\e[00m\] `[[ $(git status 2> /dev/null | head -n5 | tail -n1) == "nothing to commit, working tree clean" ]] && echo "\[\e[01;32m\]"$(__git_ps1 "(%s)") || echo "\[\e[01;31m\]"$(__git_ps1 "(%s)")` \[\e[00m\]:: '
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
#                                           SPARK
# ==================================================================================================
SPARK_VERSION_BREW=$(brew list --versions apache-spark | awk '{print $2}')
export SPARK_HOME=$BREW_PREFIX/Cellar/apache-spark/$SPARK_VERSION_BREW/libexec

export SPARKLIB=${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip
export PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"

# With explicit path to 'hadoop' binary
export SPARK_DIST_CLASSPATH=$($(which hadoop) classpath)

# PySpark
export PYSPARK_SUBMIT_ARGS="--master local[*] pyspark-shell"
# export PYSPARK_DRIVER_PYTHON="jupyter"
# export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
alias ss="spark-submit"
# ==================================================================================================
#                                           HADOOP
# ==================================================================================================
# Hadoop home directory configuration
export HADOOP_VERSION_BREW=$(brew list --versions hadoop | awk '{print $2}')
export HADOOP_HOME=$(brew --cellar)/hadoop/${HADOOP_VERSION_BREW}
export HADOOP_INSTALL=$HADOOP_HOME
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
# export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true -Djava.security.krb5.realm= -Djava.security.krb5.kdc="
export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar

export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native:$JAVA_LIBRARY_PATH

alias hstart="$HADOOP_HOME/sbin/start-all.sh"
alias hstop="$HADOOP_HOME/sbin/stop-dfs.sh;$HADOOP_HOME/sbin/stop-yarn.sh;$HADOOP_HOME/sbin/stop-all.sh"

# Hide NativeCodeLoader Warning
export HADOOP_HOME_WARN_SUPPRESS=1
export HADOOP_ROOT_LOGGER="WARN,DRFA"

alias uh="unset HADOOP_CONF_DIR"
# ==================================================================================================
#                                           KAFKA
# ==================================================================================================
KAFKA_VERSION_BREW=$(brew list --versions kafka | awk '{print $2}')
export KAFKA_HOME=$BREW_PREFIX/Cellar/kafka/$KAFKA_VERSION_BREW/libexec
export PATH=$PATH:$KAFKA_HOME/bin
export KAFKA_CONF_DIR=$KAFKA_HOME/config
# ==================================================================================================
#                                           HIVE
# ==================================================================================================
HIVE_VERSION_BREW=$(brew list --versions hive | awk '{print $2}')
export HIVE_HOME=$BREW_PREFIX/Cellar/hive/$HIVE_VERSION_BREW
export PATH=$PATH:$HIVE_HOME/bin
# ==================================================================================================
#                                           HBASE
# ==================================================================================================
HBASE_VERSION_BREW=$(brew list --versions hbase | awk '{print $2}')
export HBASE_HOME=$BREW_PREFIX/Cellar/hbase/$HBASE_VERSION_BREW/libexec
export PATH=$PATH:$HBASE_HOME/bin
export HBASE_CONF_DIR=$HBASE_HOME/conf
# ==================================================================================================
#                                           ZOOKEEPER
# ==================================================================================================
ZOOKEEPER_VERSION_BREW=$(brew list --versions zookeeper | awk '{print $2}')
export ZOOKEEPER_HOME=$BREW_PREFIX/Cellar/zookeeper/$ZOOKEEPER_VERSION_BREW/libexec
export PATH=$PATH:$ZOOKEEPER_HOME/bin

export ZK=$BREW_PREFIX/Cellar/zookeeper/$ZOOKEEPER_VERSION_BREW/libexec
export PATH=$PATH:$ZK/bin

export ZOOKEEPER_CONF_DIR=$ZOOKEEPER_HOME/conf
# ==================================================================================================
#                                           RUBY
# ==================================================================================================
# Ruby version
RUBY_VERSION_BREW=$(brew list --versions ruby | awk '{print $2}')
export PATH="$BREW_PREFIX/opt/ruby/bin:$PATH"
# Gems
export PATH="$BREW_PREFIX/lib/ruby/gems/$RUBY_VERSION_BREW/gems/html-proofer-3.11.1/bin:$PATH"

export PATH="/usr/local/lib/ruby/gems/3.3.0/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"

export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
# ==================================================================================================
#                                           RUST
# ==================================================================================================
export PATH="$HOME/.cargo/bin:$PATH"
RUST_ANALYZER_VERSION=$(brew list --versions rust-analyzer | awk '{print }')
# rust-analyzer
export PATH="$BREW_PREFIX/Cellar/rust-analyzer/$RUST_ANALYZER_VERSION/bin:$PATH"
# debug
# export RUST_BACKTRACE=1     # Backtrace on
export RUST_BACKTRACE=full # Verbosity full
# ==================================================================================================
#                                           OPTION3
# ==================================================================================================
export OPTION3_HOME=$HOME/github/origin/option3
# ==================================================================================================
#                                           GOLANG
# ==================================================================================================
# bison is keg-only, which means it was not symlinked into $BREW_PREFIX,
# because some formulae require a newer version of bison.

# If you need to have bison first in your PATH run:
#   echo 'export PATH="$BREW_PREFIX/opt/bison/bin:$PATH"' >> ~/.bash_profile

# For compilers to find bison you may need to set:
#   export LDFLAGS="-L$BREW_PREFIX/opt/bison/lib"

export PATH="$BREW_PREFIX/opt/bison/bin:$PATH"
# export LDFLAGS="-L$BREW_PREFIX/opt/bison/lib"
# export LD_LIBRARY_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include"
export C_INCLUDE_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include"
export PATH="/usr/bin/clang:$PATH"
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

# For awscli completion
complete -C aws_completer aws
# source /usr/local/etc/bash_completion.d/password-store
export INCLUDE=""
export LIBRARY_PATH=""

# Tensorflow
export TF_CPP_MIN_LOG_LEVEL=2

# Kaggle
export KAGGLE_CONFIG_DIR=$HOME/.kaggle/

# Added by travis gem
[ -f /Users/tallamjr/.travis/travis.sh ] && source /Users/tallamjr/.travis/travis.sh

# Apache Arrow Compilation
export ARROW_HOME=$BREW_PREFIX/anaconda3/envs/pyarrow-dev
export PYARROW_WITH_FLIGHT=1
export PYARROW_WITH_GANDIVA=1
export PYARROW_WITH_ORC=1
export PYARROW_WITH_PARQUET=1
# export CC=`which clang`
# export CXX=`which clang++`
export CC=$(which gcc-$GCC_VERSION)
export CXX=$(which g++-$GCC_VERSION)
export LC_ALL="en_US.UTF-8"

# Scala
export SCALA_HOME="$BREW_PREFIX/opt/scala"
export PATH="$PATH:$SCALA_HOME/bin"

# GNU sed
export PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"

# # If you need to have bison first in your PATH run:
# export PATH="$BREW_PREFIX/opt/bison/bin:$PATH"

# # For compilers to find bison you may need to set:
# export LDFLAGS="-L$BREW_PREFIX/opt/bison/lib"

# 4B25-Cambridge-EB3
export ARMGCC_DIR="$BREW_PREFIX"

# # astronet
# export ASNWD="$HOME/github/tallamjr/origin/astronet"
# export PYTHONPATH="${PYTHONPATH}:$ASNWD"

# # matlab2python
# export PYTHONPATH="${PYTHONPATH}:$HOME/scratch/matlab2python/"
# ==================================================================================================
#                                           ALIASES
# ==================================================================================================
alias asn="cd $HOME/github/tallamjr/origin/astronet"
alias audio-dl='youtube-dl -x --audio-format "wav" --audio-quality 0'
alias bashrc="vim ~/.bashrc"
alias blc="black . --check"
alias brewski='brew update && brew upgrade && brew cleanup --prune=7; brew doctor'
alias brewversion="$(brew list --versions $1 | awk '{print $2}')"
alias ca="conda activate"
alias caa="conda activate astronet"
alias condasource="source $HOME/github/tallamjr/origin/scripts/condasource.sh"
alias chrome="open /Applications/Google\ Chrome.app/"
alias cl="clear"
alias crontabedit="env EDITOR=vim crontab -e" # Edit crontab with vim
alias df="df -h"
alias dls="cd ~/Downloads/ && la -rt"
alias du="du -sh"
alias dus="du -sh * | sort -h"
alias echof='echo "`f`"'
alias f="fzf -i --color=hl:200,hl+:200"
alias ff="gfortran"
alias f8="flake8"
alias fire="open /Applications/Firefox.app/"
alias gethash="git show | head -1 | cut -d' ' -f2 | cut -c1-7 | pbcopy"
alias gg="grep -i"
alias ghub="cd ~/github/"
alias gl="cd ~/gitlab/git.arg/"
alias gpu="watch sudo powermetrics --samplers gpu_power -i500 -n1"
alias grep="grep -E"
alias hashme="git show | head -1 | cut -d' ' -f2 | cut -c1-7"
alias hp="ssh hypatia"
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
alias matlab="matlab -nodesktop"
alias mp="cd ~/UCL_2016/major-project/"
alias myp="echo $MYRIAD | pbcopy && ssh myriad"
alias neo=" pip install neovim && pip install black"
alias nq="networkQuality"
alias openf='open "`f`"'
alias p2="ssh plus2"
alias pat="pygmentize -g" # Colourful 'cat' output
alias pdflatex="pdflatex -interaction nonstopmode -halt-on-error -file-line-error"
alias pingg="ping www.google.com"
alias pj="python -m json.tool"
alias pn="vim -O $HOME/PhD/wiki/index.markdown $HOME/PhD/wiki/diary/$(date +%Y-%m-%d).markdown"
alias poker="open /Applications/PokerStarsUK.app/"
alias printhash="git show | head -1 | cut -d' ' -f2 | cut -c1-7"
alias pt='pytest --verbose --capture=no --showlocals --durations=0 --setup-show'
alias pylab="ipython -pylab" # Ipython
alias qq="exit"
alias resetusb='sudo launchctl stop com.apple.usbd; sudo launchctl start com.apple.usbd'
alias rmbiber="rm -rf $(biber --cache)"
alias rr="R CMD BATCH "
alias rspace="rename \"s/ /-/g\" * && rename \"s/[\(\)]//g\" *"
alias rrs="rsync -avzh --progress --stats"
alias sa="source activate"
alias sb="source ~/.bashrc"
alias sleep="sudo shutdown -s now" # Put computer to sleep
alias speed="speedtest-cli"
alias tc="texcount -inc -total"
alias tmp="cd /tmp"
alias til="vim ~/github/origin/til/README.md"
alias tree="tree -I '*__pycache__|*.pkl'"
alias tmux="tmux -2" # Force tmux to use 256 colours
alias todo="vim +VimwikiUISelect"
alias ttop="top -o CPU"
# Use Neovim as "preferred editor"
export VISUAL="vim"
# Use Neovim instead of Vim or Vi
# alias vim="nvim"
# alias vi="nvim"
alias vimf='vim `f`'
alias vimplugininstall="vim +PluginInstall +qall" # Vim pluin install from command line.
alias vimrc="vim ~/.vimrc"
alias vimn="vim +NERDTree"
alias watch="watch --differences"
alias wiki="vim +VimwikiIndex"
alias wpp="which pip && which python && python --version"
alias xx="chmod +x" # Make file executable

GCC_VERSION=$(brew list --versions gcc | awk '{print $2}' | cut -d '.' -f1)
alias gcc="gcc-$GCC_VERSION"
# ==================================================================================================
#                                           FUNCTIONS
# ==================================================================================================
function ldd() {

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

function pythonversion() {
	# Check version of install Python package
	# python -c "import $1; print($1.__version__)"
	pip list | grep $1
}

function frameworkpython {
	if [[ ! -z "$VIRTUAL_ENV" ]]; then
		PYTHONHOME=$VIRTUAL_ENV /usr/local/bin/python "$@"
	else
		/usr/local/bin/python "$@"
	fi
}

# If you need to have llvm first in your PATH run:
export PATH="$BREW_PREFIX/opt/llvm/bin:$PATH"

# For compilers to find llvm you may need to set:
# export LDFLAGS="-L$BREW_PREFIX/opt/llvm/lib"
# export CPPFLAGS="-I$BREW_PREFIX/opt/llvm/include"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

alias db="export LOCAL_DEBUG=0"
alias ndb="unset LOCAL_DEBUG"

. "$HOME/.cargo/env"

export HOMEBREW_AUTOREMOVE=1

export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#                                               EOF
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
