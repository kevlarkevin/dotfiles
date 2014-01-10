#!/bin/bash


delay=10
if [ ! -z $1 ]; then
    delay=$1
fi

printf "\n\nWENT OUT FOR A SMOKE\n\nBE BACK IN A $delay MINUTES\n\n"
printf "\n\nleft around\n$(date)\n\n"
