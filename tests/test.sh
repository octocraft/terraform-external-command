#!/bin/bash
set -eu

# Include Packages
export PATH="$PWD/vendor:$PWD/vendor/bin/current:$PATH"

# Check command
function has_command () {
    command -v "$1" &> /dev/null
}

# Get Package Manager
if ! has_command "sbpl"; then
    echo "Get Package Manager"

    if has_command "curl"; then
        function fetch () { curl -fSL# "$1" -o "$2"; }
    elif has_command "wget"; then
        function fetch () { wget --progress=bar -O "$2" "$1"; }
    else
        printf "Neither 'curl' nor 'wget' found\n" 1>&2; exit 2
    fi

    url="https://raw.githubusercontent.com/octocraft/sbpl/master/sbpl.sh"
    mkdir -p vendor; fetch "$url" "vendor/sbpl"; chmod +x vendor/sbpl
fi

# Get Packages
sbpl update

# Run Tests
sbpl test . tftest

