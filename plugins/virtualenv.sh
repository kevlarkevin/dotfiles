#!/bin/bash


export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects

if [ $(which virtualenvwrapper.sh-2.7) ]; then
    source virtualenvwrapper.sh-2.7
elif [ $(which virtualenvwrapper.sh) ]; then
    source virtualenvwrapper.sh
fi
