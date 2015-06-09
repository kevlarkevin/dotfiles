#!/bin/bash


# OS check
if [ $(uname) == Darwin ]; then
    # application shortcuts
    if [ -s /Applications/Sublime\ Text.app ]; then
        alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
    fi

    # MacPorts
    if [ -e /opt/local/bin/port ]; then
        export PATH=/opt/local/bin:/opt/local/sbin:$PATH
        export MANPATH=/opt/local/share/man:$MANPATH

        # bash completion
        # source /opt/local/etc/profile.d/bash_completion.sh

        # git-core extras
        source /opt/local/share/git/contrib/completion/git-completion.bash
        source /opt/local/share/git/contrib/completion/git-prompt.sh

        # virtualenv + virtualenvwrapper
        export WORKON_HOME=$HOME/VirtualEnvs
        export PROJECT_HOME=$HOME/Projects
        source /usr/local/bin/virtualenvwrapper.sh
    fi

    # Change directory to front Finder window's location
    function cdf() {
        target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
        if [ "$target" != "" ]; then
            cd "$target"
            pwd
        else
            echo 'No Finder window found' >&2
        fi
    }

    # Reveal Item(s) in Finder
    function revealf() {
        [ -z $1 ] && echo "Usage: '$FUNCNAME' [file]" >&2

        # define $n, gets +1 for each argument given
        # not sure if $n is needed, how to get index number of $1, $2, etc.?
        n=0

        # define $act, gets +1 for each argument that passes test
        act=0

        # step thru each argument one at a time
        for thearg in "$@"; do
            n=$(( n + 1 ))

            # if $thearg exists then
            if [ -e "$thearg" ]; then

                # get the absolute path to the argument
                thearg="`cd \`dirname \"$thearg\"\`; pwd`/`basename \"$thearg\"`"

                # create a applescript statement using $thearg for osascript to execute
                osatext='tell application "Finder" to reveal POSIX file "'"$thearg"'"'
                /usr/bin/osascript -e "$osatext" >/dev/null

                # $act activates Finder after processing the remaining arguments
                act=$(( act + 1 ))

            # else if $thearg does not exist then
            else
                # if $thearg is not the last argument given then
                if [ $n -lt $# ]; then
                    # ask to continue processing the remaining arguments
                    echo -n '"'"$thearg"'" does not exist and will be ignored. continue?  (y/n)? ' >&2
                    read ans
                    case $ans in
                        "n" ) exit 1 ;;
                        "y" ) continue ;;
                    esac
                # else if $thearg is the last arguement then
                else
                    # print the "does not exist" string and exit
                    echo '"'"$thearg"'" does not exist.' >&2

                    # exit status 1 indicates an error occurred
                    exit 1
                fi
            fi
        done

        # if $act is greater than 0 then activate the finder
        [ $act -gt 0 ] && /usr/bin/osascript -e 'tell application "Finder" to activate'

        # exit status 0 indicates all is ok
        return 0
    }

    # Finder 'Move to Trash'
    function trash() {
        for arg in "$@"; do
            if [ -e "$PWD/$arg" ]; then
                osascript -e "tell application \"Finder\" to delete POSIX file \"$PWD/$arg\"" &>/dev/null
            elif [ -e "$arg" ]; then
                osascript -e "tell application \"Finder\" to delete POSIX file \"$arg\"" &>/dev/null
            else
                echo File \'$arg\' not found
            fi
        done
    }

    # Finder 'Empty Trash'
    function emptytrash() { osascript -e "tell application \"Finder\" to empty trash"; }

    # Finder 'Empty Trash, with security'
    function emptytrashsecure() { osascript -e "tell application \"Finder\" to empty trash with security"; }

    # Fix Hostname
    function fixHostname() {
        local status=''
        local newHost=$1
        if [ $HOSTNAME == $newHost ]; then
            printf "hostname: $HOSTNAME\n"
        elif [ $HOSTNAME != $newHost ]; then
            local changeIt=''
            printf "\nchange local hostname to $newHost?\n"
            read -p "this action will prompt for password. (Y/n): " changeIt
            case $changeIt in
                y|Y|[yY][eE][sS] )
                    sudo scutil --set LocalHostName $newHost &&\
                        printf "hostname changed. log out or restart to take effect\n\n"
                    ;;
                [nN]|[nN][oO])
                    continue
                    ;;
                *)
                    echo "WRONG! \"$changeIt\" is not an acceptable response"
                    status=1
                    ;;
            esac
        fi
    }
fi

