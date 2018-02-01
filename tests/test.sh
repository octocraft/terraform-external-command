#!/bin/bash

# Check if Terraform is present
if ! [ -x "$(command -v terraform 2>/dev/null)" ]; then
    echo 'error: terraform not found in $PATH.'
    exit
fi

# Init Terraform
if ! terraform init -input=false > /dev/null; then
    echo "failed to init terraform" 
    exit
fi

# Check if value is queried correctly
if terraform apply -var 'color=cyan' | grep "value = #0ff" > /dev/null; then
    echo 'success'
else
    echo "fail"
fi
