#!/bin/bash

tf_type="archive"
tf_name="terraform"
tf_ver="0.11.3"
tf_url='https://releases.hashicorp.com/terraform/${version}/${name}_${version}_${OS}_${ARCH}.zip'
tf_bin='./'

sbpl_get "$tf_type" "$tf_name" "$tf_ver" "$tf_url" "$tf_bin"

if command -v wine; then
    export OS="windows"
    export ARCH="386"
    sbpl_get "$tf_type" "$tf_name" "$tf_ver" "$tf_url" "$tf_bin"
fi
