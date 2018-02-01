#!/bin/bash

jq -n --arg v "$(echo bar)" '{"foo": $v}'
