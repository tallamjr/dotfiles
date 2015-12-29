#!/bin/bash

# needs work around for additional arguments such as 'override system-vi'
FILE="./brewlist"
while read line; do
    if [ "$line" == "vim" ]; then
       echo "--override-system-vim is what I will put here"
       # brew install --override-system-vim
    else
       echo "$line"
       # brew install $line
    fi
done < $FILE
