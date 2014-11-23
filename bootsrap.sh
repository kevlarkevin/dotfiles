#!/bin/bash


dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
today=$(date "+%Y_%m_%d")

# OSX specific
if [ $(uname) == Darwin ]; then
    # Check for Xcode
    if [ ! -s /Applications/Xcode.app ]; then
        echo '[ERROR]  Xcode - NOT INSTALLED'
        exit 1
    fi

    # Check for MacPorts
    if [ ! $(which port) ]; then
        echo '[ERROR]  `port` command not found in PATH'
        exit 1
    fi

    # Install vim, macvim, tmux, git-core and python stuff via MacPorts
    sudo port install \
        vim +huge +python27 \
        macvim +huge +python27 \
        tmux tmux-pasteboard \
        py27-ipython +scientific +notebook +parallel \
        py27-pip py27-virtualenv \
        py27-flake8
        git-core \
        curl \
        bash-completion \
        mongodb \
        nginx \


    sudo port select --set pep8 pep827
    sudo port select --set pyflakes py27-pyflakes
    sudo port select --set python python27
    sudo port select --set ipython ipython27
    sudo port select --set virtualenv virtualenv27
    sudo port select --set nosetests nosetests27
fi

# Make dot_vim directory
[ ! -d $dir/dot_vim ] && mkdir -p $dir/dot_vim/{autoload,colors}

# Make links
ln -sf $dir $HOME/.dotfiles
for file in $(ls $dir | grep '^dot_'); do
    dotfile=$(sed s'/^dot_/\./' <<< $file)
    mv $HOME/$dotfile $HOME/$dotfile.$today.bak
    ln -sf $dir/$file $HOME/$dotfile
done

# Make directory for virtualenvs
[ ! -d !/VirtualEnvs ] && mkdir -p ~/VirtualEnvs

# Download pathogen for vim
curl -LSso ~/.vim/autoload/pathogen.vim \
    https://tpo.pe/pathogen.vim

# Download zenburn colorscheme for vim
curl -Sso ~/.vim/colors/zenburn.vim \
    http://slinky.imukuppi.org/zenburn/zenburn.vim

# Download Submodules
git submodule init
git submodule update

# Reload
source $HOME/.profile
