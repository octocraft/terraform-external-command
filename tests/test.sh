#!/bin/bash

# Check if Terraform is present
if ! [ -x "$(command -v terraform 2>/dev/null)" ]; then
    
    if ! [ -f terraform ]; then
        echo 'error: terraform not found'
        exit 2
    else
        function terraform () {
            ./terraform $@
        }
    fi
fi

# Init Terraform
if ! terraform init -input=false > /dev/null; then
    echo "failed to init terraform" 
    exit 1
fi

# Check if value is queried correctly
if terraform apply -auto-approve -var 'color=cyan' | grep "value = #0ff" > /dev/null; then
    echo 'success'
else
    echo "fail"
    exit 1
fi

