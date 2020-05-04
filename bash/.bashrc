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

# ==================================================================================================
#                                           PATH EXPORTS
# ==================================================================================================
# Allows Coreutils package to be used without 'g' prefix before each command.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
#
export PATH="/usr/local/bin:$PATH"

export PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
#
# Setting PATH for EPD-6.3-1
# The orginal version is saved in .bash_profile.pysave
export PATH="/Library/Frameworks/EPD64.framework/Versions/Current/bin:${PATH}"

if [ `uname` == "Linux" ]; then
    # Export path variables for linuxbrew.
    export PATH="$HOME/.linuxbrew/bin:$PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi
# Why this line?
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Homemade scripts
export PATH="$HOME/scripts:$PATH"
# Cronjobs
export PATH="$HOME/cronjobs:$PATH"
# TMUX Battery Status
export PATH="$HOME/Documents/tmux/bin:$PATH"
# MySQL
export PATH="/usr/local/mysql/bin:$PATH"
# Mongodb PATH
export PATH="$HOME/mongodb/bin:$PATH"
# Why?
export PATH="/usr/local/sbin:$PATH"
# MATLAB command line.
export MATLAB_EXECUTABLE=/Applications/MATLAB_R2017a.app/bin/matlab
export PATH="/Applications/MATLAB_R2017a.app/bin:$PATH"
# MacTex binaries
# export PATH="$(dirname `which latex`):$PATH"
export PATH="$HOME/Github/forks/cli/bin:$PATH"
# ==================================================================================================
#                                           PYTHON/ANACONDA
# ==================================================================================================
# Base env anaconda
export PATH="/usr/local/anaconda3/bin:$PATH"
# Main env anaconda
export PATH="/usr/local/anaconda3/envs/main/bin:$PATH"

source /usr/local/anaconda3/etc/profile.d/conda.sh
source activate main

source $HOME/scripts/condasource.sh

# https://github.com/conda/conda/issues/6018
export PYTHONNOUSERSITE=True
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
#                                           FINK
# ==================================================================================================
# Fink-Broker
export FINK_HOME=$HOME/Github/fink-broker
export PYTHONPATH=$FINK_HOME/python:$PYTHONPATH

# Fink-Client
export FINK_CLIENT_HOME=$HOME/Github/fink-client
export PYTHONPATH=${FINK_CLIENT_HOME}:$PYTHONPATH
export PATH=${FINK_CLIENT_HOME}/bin:$PATH
# ==================================================================================================
#                                           SPARK
# ==================================================================================================
SPARK_VERSION_BREW=$(brew list --versions apache-spark | awk '{print $2}')
export SPARK_HOME=/usr/local/Cellar/apache-spark/$SPARK_VERSION_BREW/libexec
export PATH=$FINK_HOME/bin:$PATH

export SPARKLIB=${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip
export PYTHONPATH="${SPARKLIB}:${FINK_HOME}:${FINK_HOME}/python:$PYTHONPATH"
export PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"

# PySpark
export PYSPARK_SUBMIT_ARGS="--master local[*] pyspark-shell"
# ==================================================================================================
#                                           HADOOP
# ==================================================================================================
# Hadoop home directory configuration
HADOOP_VERSION_BREW=$(brew list --versions hadoop | awk '{print $2}')
export HADOOP_HOME=$HOME/bin/hadoop-$HADOOP_VERSION_BREW
export HADOOP_INSTALL=$HADOOP_HOME
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
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
# ==================================================================================================
#                                           HIVE
# ==================================================================================================
HIVE_VERSION_BREW=$(brew list --versions hive | awk '{print $2}')
export HIVE_HOME=/usr/local/Cellar/hive/$HIVE_VERSION_BREW
export PATH=$PATH:$HIVE_HOME/bin

HBASE_VERSION_BREW=$(brew list --versions hbase | awk '{print $2}')
export HBASE_HOME=/usr/local/Cellar/hbase/$HBASE_VERSION_BREW/libexec
export PATH=$PATH:$HBASE_HOME/bin
export HBASE_CONF_DIR=$HBASE_HOME/conf

export FINK_ALERT_SIMULATOR=$HOME/Github/fink-alert-simulator
export PYTHONPATH=$FINK_ALERT_SIMULATOR:$PYTHONPATH
export PATH=$FINK_ALERT_SIMULATOR/bin:$PATH
# ==================================================================================================
#                                           RUBY
# ==================================================================================================
export PATH="/usr/local/opt/ruby/bin:$PATH"

# ==================================================================================================
#                                       MISCELLANEOUS
# ==================================================================================================
export MKL_NUM_THREADS=1

# Global variable for date format YY-MM-DD
export DATE=`date +'%A %b %d %Y'`

# Command line cheat
export CHEATCOLORS=true

# --appdir=/my/path changes the path where the symlinks to the applications
# (above) will be generated. This is commonly used to create the links in the
# root Applications directory instead of the home Applications directory by
# specifying --appdir=/Applications. Default is ~/Applications. See
# https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

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
export ARROW_HOME=/usr/local/anaconda3/envs/pyarrow-dev
export PYARROW_WITH_FLIGHT=1
export PYARROW_WITH_GANDIVA=1
export PYARROW_WITH_ORC=1
export PYARROW_WITH_PARQUET=1
export CC=`which clang`
export CXX=`which clang++`
# export CC=`which gcc-$GCC_VERSION`
# export CXX=`which g++-$GCC_VERSION`
export LC_ALL="en_US.UTF-8"

# Scala
export SCALA_HOME="/usr/local/opt/scala"
export PATH="$PATH:$SCALA_HOME/bin"

# GNU sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# If you need to have bison first in your PATH run:
export PATH="/usr/local/opt/bison/bin:$PATH"

# For compilers to find bison you may need to set:
export LDFLAGS="-L/usr/local/opt/bison/lib"
# ==================================================================================================
#                                           ALIASES
# ==================================================================================================
alias pylab="ipython -pylab"                                            # Ipython
alias tmux="tmux -2"                                                    # Force tmux to use 256 colours
alias ls="ls --color"                                                   # Listing in colour
alias cl="clear"
alias la="ls -lah"                                                      # Listing in human-readable format
alias qq="exit"
alias grep="grep -E"
alias gg="grep -i"
alias sleep="sudo shutdown -s now"                                      # Put computer to sleep
alias pat="pygmentize -g"                                               # Colourful 'cat' output
alias rr="R CMD BATCH "
alias xx="chmod +x"                                                     # Make file executable
alias todo="vim +VimwikiUISelect"
alias wiki="vim +VimwikiIndex"
alias pn="vim -O $HOME/PhD/wiki/index.markdown $HOME/PhD/wiki/diary/`date +%Y-%m-%d`.markdown"
alias lsg="ls | grep -i"                                                # Search a directory listing with grep case-insensitive.
alias crontabedit="env EDITOR=vim crontab -e"                           # Edit crontab with vim
alias ff="gfortran"
alias pingg="ping www.google.com"
alias kali="dockerdaemon && docker run -t -i kali:latest /bin/bash"     # Start Kalilinux via docker vm.
alias vimplugininstall="vim +PluginInstall +qall"                       # Vim pluin install from command line.
alias lsc="ls | wc | awk '{print $1}'"                                  # Show the 'count' of files in a director.
alias sa="source activate"
alias f="fzf -i --color=hl:200,hl+:200"
alias sb="source ~/.bashrc"
alias bashrc="vim ~/.bashrc"
alias speed="speedtest-cli"
alias dls="cd ~/Downloads/ && la -rt"
alias vimrc="vim ~/.vimrc"
alias ttop="top -o CPU"
alias mp="cd ~/UCL_2016/major-project/"
alias matlab="matlab -nodesktop"
alias lrt="ls -lart"
alias df="df -h"
alias du="du -sh"
alias jn="jupyter notebook"
alias audio-dl='youtube-dl -x --audio-format "wav" --audio-quality 0'
alias vimf='vim `f`'
alias openf='open "`f`"'
alias echof='echo "`f`"'
alias printhash="git show | head -1 | cut -d' ' -f2 | cut -c1-7"
alias gethash="git show | head -1 | cut -d' ' -f2 | cut -c1-7 | pbcopy"
alias brewski='brew update && brew upgrade && brew cleanup; brew doctor'
alias hp="ssh hypatia"
alias p2="ssh plus2"
GCC_VERSION=`brew list --versions gcc | awk '{print $2}' | cut -d '.' -f1`
alias gcc="gcc-$GCC_VERSION"
# Application shortcuts
alias chrome="open /Applications/Google\ Chrome.app/"
alias poker="open /Applications/PokerStarsUK.app/"
alias fire="open /Applications/Firefox.app/"
alias matlab="matlab -nodesktop -nosplash"
alias wpp="which pip && which python && python --version"
alias ca="conda activate"
# ==================================================================================================
#                                           FUNCTIONS
# ==================================================================================================
function arxiv() {
# Get source files from arxiv.org and create folder of them
TAR=$1.tar.gz

mv $1 $TAR
mkdir $1
mv $TAR $1
cd $1
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
' > build.sbt
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
vim ~/PhD/project/logs/logbook-`date +%Y%W`.md
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
javac $1 && java `basename $1 .java`
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
# Extract any compressed file, courtsey http://efavdb.com/dotfiles/
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar -jxvf "$1"                        ;;
            *.tar.gz)   tar -zxvf "$1"                        ;;
            *.bz2)      bunzip2 "$1"                          ;;
            *.dmg)      hdiutil mount "$1"                    ;;
            *.gz)       gunzip "$1"                           ;;
            *.tar)      tar -xvf "$1"                         ;;
            *.tbz2)     tar -jxvf "$1"                        ;;
            *.tgz)      tar -zxvf "$1"                        ;;
            *.zip)      unzip "$1"                            ;;
            *.ZIP)      unzip "$1"                            ;;
            *.pax)      cat "$1" | pax -r                     ;;
            *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
            *.Z)        uncompress "$1"                       ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file to extract"
    fi
}

function ccmake() {
  # Don't invoke cmake from the top-of-tree
  if [ -e "CMakeLists.txt" ]
  then
    echo "CMakeLists.txt file present, cowardly refusing to invoke cmake..."
  else
    ccmake_path=`which ccmake`
    # /usr/bin/cmake $*
    $ccmake_path $*
  fi
}

function pythonversion() {
# Check version of install Python package
    python -c "import $1; print($1.__version__)"
}

function frameworkpython {
if [[ ! -z "$VIRTUAL_ENV" ]]; then
    PYTHONHOME=$VIRTUAL_ENV /usr/local/bin/python "$@"
else
    /usr/local/bin/python "$@"
fi
}
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#                                               EOF
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
