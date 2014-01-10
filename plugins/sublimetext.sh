#!/bin/bash


# OSX
if [ $(uname) == Darwin ] && [ -s /Applications/Sublime\ Text.app ]; then
    alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
fi
