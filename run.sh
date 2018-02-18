#!/bin/bash

case "$OSTYPE" in
    darwin*)  OS="darwin";  ;;
    freebsd*) OS="freebsd"; ;;
    linux*)   OS="linux";   ;;
    openbsd*) OS="openbsd"; ;;
    solaris*) OS="solaris"; ;;  
    windows*) OS="windows"; ;;
esac;  

# Add module binaries to PATH
PATH="$PATH:$1/bin/$OS"

# Check if jq is present
if ! [ -x "$(command -v jq 2>/dev/null)" ]; then
    echo 'Error: unsupported platform' 1>&2
    exit 2
fi

# Read query from stdin
eval "$(jq -r '@sh "command=\(.command) module_path=\(.module_path)"')"

# Run command
eval "$command"
