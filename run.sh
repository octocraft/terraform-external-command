#!/bin/bash

BASEDIR="$1"

case "$OSTYPE" in
    darwin*)  OS="darwin";  ;;
    freebsd*) OS="freebsd"; ;;
    linux*)   OS="linux";   ;;
    openbsd*) OS="openbsd"; ;;
    solaris*) OS="solaris"; ;;  
    windows*) OS="windows"; ;;
esac;  

case "$HOSTTYPE" in
    arm*)       ARCH="arm"          ;;
    i386*)      ARCH="368"          ;;
    x86_64*)    ARCH="amd64"        ;;
esac;

# Add module binaries to PATH
PATH="$PATH:$BASEDIR/bin/$OS/$ARCH"

# Check if jq is present
if ! [ -x "$(command -v jq 2>/dev/null)" ]; then
    echo 'Error: unsupported platform' 1>&2
    exit 2
fi

# Read query from stdin
eval "$(jq -r '@sh "command=\(.command) module_path=\(.module_path)"')"

# Run command
output="$(eval "$command")"
result=$?

if [ -z "$output" ]; then
    printf "{}\n"
else
    printf "%s\n" "$output"
fi
