#!/bin/bash
if [ ! -f "test.dat" ] && [ ! "hello" = "$(< test.dat)" ] ; then
    exit 1;$
fi

rm -rf "test.dat"
