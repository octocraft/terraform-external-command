#!/bin/bash

mkdir -p tmp
pushd tmp > /dev/null

printf "Get package manager\n"
curl -fSL# https://raw.githubusercontent.com/octocraft/sbpl/master/sbpl.sh -o sbpl.sh
chmod +x sbpl.sh

printf "#!/bin/bash\nset -eu\n\n" > sbpl-pkg.sh
chmod +x sbpl-pkg.sh

function get () {
    printf "%s\n" "OS=$1; ARCH=$2; sbpl_get '$3' 'jq' 'latest' '$4' '${5}';" >> sbpl-pkg.sh
}

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

./sbpl.sh
if [ $? -eq 0 ]; then
    cp -rfL vendor/bin/ ../
    printf "\nUpdate succeeded\n"
else
    printf "\nUpdate failed\n"
    exit 1
fi

popd > /dev/null
rm -rf tmp
