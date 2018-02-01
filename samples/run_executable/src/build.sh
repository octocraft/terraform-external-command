#!/bin/bash

# Check if jq is present
if ! [ -x "$(command -v go 2>/dev/null)" ]; then
    echo 'error: go is requiered.' 1>&2
    exit 2
fi

function build {
    # 1:source_name 2:binary_name 3:os 4:arch
    env GOOS=$3 GOARCH=$4 go build -o "../bin/$3/$2" "$1"
}

source=foo.go
name=foo
arch=amd64

build $source $name darwin $arch
build $source $name freebsd $arch
build $source $name linux $arch
build $source $name openbsd $arch
build $source $name solaris $arch
build $source $name.exe windows $arch
