#!/bin/bash


cells=18
if [ ! -z $1 ]; then
    cells=$1
fi

# for fgbg in 38 48 ; do #Foreground/Background
for fgbg in 48;  do #background ONLY
    for color in {0..15}; do
        printf "\e[${fgbg};5;${color}m %3s\e[0m" "$color"
    done
    echo
    for color in {16..256}; do #Colors
        #Display the color
            printf "\e[${fgbg};5;${color}m %3s\e[0m" "$color"
        #Display 10 colors per lines
        if [ $((($color + 1 -16) % $cells)) == 0 ] ; then
            echo #New line
        fi
    done
    echo
    echo 'for ex: echo -en "\e[48;5;164m\e[38;5;25mdur\e[0m"'
    printf "produces \e[48;5;164m\e[38;5;25mdur\e[0m\n"
    echo "\e[48;5...m sets background"
    echo "\e[38;5...m sets foreground"
    echo "\e[48;5...m clears the foreground"
    echo "\e[38;5...m clears the background"
    echo "\e[0m should clear escape sequence styling"
done
