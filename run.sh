#!/bin/bash

echo "0: $0"

script_dir_realtive=${0%/*}
script_dir=$(pwd)$([ ! -z "$script_dir_realtive" ] && printf "%s" "/$script_dir_realtive")

echo "script_dir: $script_dir"
echo "OSTYPE: $OSTYPE"

case "$OSTYPE" in
    darwin*)  OS="darwin";  ;;
    freebsd*) OS="freebsd"; ;;
    linux*)   OS="linux";   ;;
    openbsd*) OS="openbsd"; ;;
    solaris*) OS="solaris"; ;;  
    windows*) OS="windows"; ;;
esac;  

# Add module binaries to PATH
PATH="$PATH:$script_dir/bin/$OS"

echo "PATH: $PATH"

# Check if jq is present
if ! [ -x "$(command -v jq 2>/dev/null)" ]; then
    echo 'Error: unsupported platform' 1>&2
    exit 2
fi

# Read query from stdin
eval "$(jq -r '@sh "command=\(.command) module_path=\(.module_path)"')"

# Run command
eval "$command"
