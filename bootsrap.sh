#!/bin/bash


dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
today=$(date "+%Y_%m_%d")

# OSX specific
if [ $(uname) == Darwin ]; then
    # Check for Xcode
    echo '- checking for Xcode.app...'
    if [ ! -s /Applications/Xcode.app ]; then
        echo '++ [ERROR]  Xcode.app not installed'
        exit 1
    fi

    # Check for MacPorts
    echo '- checking for macports...'
    if [ ! $(which port) ]; then
        echo '++ [ERROR]  `port` command not in PATH'
        exit 1
    fi

    # Install vim, macvim, tmux, git-core and python stuff via MacPorts
    echo '- installing ports (uses sudo):'
    echo '-   macvim+huge+python27, tmux, tmux-pasteboard, git, curl, htop, tree'
    sudo port install \
        macvim +huge +python27 \
        tmux tmux-pasteboard \
        git \
        curl \
        htop \
        tree \

    echo '- setting default python to python27-apple... (uses sudo)'
    sudo port select --set python python27-apple

    # get and install pip
    echo '- checking for /usr/local/bin/pip'
    if [ ! -e /usr/local/bin/pip ]; then
        echo '++ downloading get-pip.py script'
        curl -Sso /var/tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
        echo '++ installing pip to system python... (uses sudo)'
        sleep 1
        sudo /usr/bin/python /var/tmp/get-pip.py
    else
        echo '++ exists. nothing to do'
    fi
fi

echo '- checking for flake8'
if [ ! -e /usr/local/bin/flake8 ]; then
    echo '++ installing /usr/local/bin/flake8'
    sudo pip install flake8==2.4.1
else
    echo '++ exists. nothing to do'
fi

echo '- checking for ipython'
if [ ! -e /usr/local/bin/ipython ]; then
    echo '++ installing /usr/local/bin/ipython'
    sudo pip install ipython
else
    echo '++exists. nothing to do'
fi

echo '- checking for virtualenv'
if [ ! -e /usr/local/bin/virtualenv ]; then
    echo '++ installing /usr/local/bin/virtualenv'
    sudo pip install virtualenv
else
    echo '++exists. nothing to do'
fi

echo '- checking for virtualenvwrapper.sh'
if [ ! -e /usr/local/bin/virtualenvwrapper.sh ]; then
    echo '++ installing /usr/local/bin/virtualenvwrapper.sh'
    sudo pip install virtualenvwrapper
else
    echo '++exists. nothing to do'
fi

echo '- checking for vim plugin directory structure'
if [ ! -d $dir/dot_vim ]; then
    echo '++ creating vim plugin directory structure'
    mkdir -p $dir/dot_vim/{autoload,colors}
else
    echo '++ exists. nothing to do...'
fi

echo '- checking for ~/.dotfiles directory'
if [ ! -d $HOME/.dotfiles ]; then
    echo '++ soft-linking repo to ~/.dotfiles'
    ln -sf $dir $HOME/.dotfiles
else
    echo '++ exists. nothing to do...'
fi

echo '- checking ~/.* files and symlink'
for file in $(ls $dir | grep '^dot_'); do
    dotfile=$(sed s'/^dot_/\./' <<< $file)
    if [ -a $HOME/$dotfile ]; then
        # mv $HOME/$dotfile $HOME/$dotfile.$today.bak
        rm $HOME/$dotfile
    fi
    echo "++ ln -sf $dir/$file to ~/$dotfile"
    ln -sf $dir/$file $HOME/$dotfile
    if [ -a ~/.dotfiles/dot_vim/.vim ]; then
        rm ~/.dotfiles/dot_vim/.vim
    fi
done

# Make directory for virtualenvs
echo '- checking ~/VirtualEnvs for py27-virtualenvwrapper'
if [ ! -d ~/VirtualEnvs ]; then
    echo '++ not found. creating...'
    mkdir -p ~/VirtualEnvs
else
    echo '++ exists. nothing to do...'
fi

# Download pathogen for vim
echo '- checking for pathogen.vim'
if [ ! -a ~/.vim/autoload/pathogen.vim ]; then
    [ ! -a ~/.vim/autoload ] && mkdir -p ~/.vim/autoload
    echo '++ downloading pathogen.vim'
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
else
    echo '++ exists. nothing to do...'
fi

# Download Submodules
git submodule init
git submodule update --recursive
# git submodule foreach git pull origin master

# Reload
source $HOME/.profile
