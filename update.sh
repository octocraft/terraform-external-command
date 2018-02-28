#!/bin/bash
set -eu

# Clear bin
rm -rf bin

# Make tmp
mkdir -p tmp

pushd tmp > /dev/null

printf "Get package manager\n"
curl -fSL# https://raw.githubusercontent.com/octocraft/sbpl/master/sbpl.sh -o sbpl.sh
chmod +x sbpl.sh

printf "#!/bin/bash\nset -eu\n\n" > sbpl-pkg.sh
chmod +x sbpl-pkg.sh

function _get () {
    if [ "$#" -ge 7 ]; then _7="$7"; else _7=""; fi
    printf "%s\n" "OS=$1; ARCH=$2; sbpl_get '$3' '$4' '$5' '$6' '$_7';" >> sbpl-pkg.sh
}

function get () {
    if [ "$#" -ge 5 ]; then _5="$5"; else _5=""; fi
    _get "$1" "$2" "$3" "jq" "latest" "$4" "$_5"
}

# Package List
get "darwin"  "amd64" "file"    "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-osx-amd64"
get "freebsd" "amd64" "archive" "https://pkg.freebsd.org/FreeBSD:12:amd64/latest/All/jq-1.5_1.txz"                  "usr/local/bin/"
get "freebsd" "386"   "archive" "https://pkg.freebsd.org/FreeBSD:12:i386/latest/All/jq-1.5_1.txz"                   "usr/local/bin/"
get "freebsd" "arm"   "archive" "https://pkg.freebsd.org/FreeBSD:12:armv6/latest/All/jq-1.5_1.txz"                  "usr/local/bin/"
get "linux"   "amd64" "file"    "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64"
get "linux"   "386"   "file"    "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32"
get "openbsd" "amd64" "archive" "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/6.2/packages/amd64/jq-1.5p2.tgz"    "bin/"
get "openbsd" "386"   "archive" "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/6.2/packages/i386/jq-1.5p2.tgz"     "bin/"
get "solaris" "amd64" "file"    "https://github.com/stedolan/jq/releases/download/jq-1.4/jq-solaris11-64"
get "windows" "amd64" "file"    "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-win64.exe"
get "windows" "386"   "file"    "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-win32.exe"

_get "windows" "386" "archive" "bash" "latest" "https://sourceforge.net/projects/win-bash/files/shell-complete/latest/shell.w32-ix86.zip/download" "bash.exe"

# Get Packages
./sbpl.sh

# Copy Files to bin
if [ $? -eq 0 ]; then
    cp -rfL vendor/bin/ ../
    printf "\nUpdate succeeded\n"
else
    printf "\nUpdate failed\n"
    exit 1
fi

popd > /dev/null

# Clear tmp
rm -rf tmp
