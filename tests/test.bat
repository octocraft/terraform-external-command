@echo off

:: Check if Terraform is present
terraform version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo error: terraform not found
    goto :EOF
)

:: Init Terraform
terraform init -input=false >nul
if %ERRORLEVEL% neq 0 (
    echo failed to init terraform
    goto :EOF
)

:: Check if value is queried correctly
terraform apply -auto-approve -var "color=cyan" | findstr /C:"value = #0ff" >nul
if %ERRORLEVEL% neq 0 (
    echo fail
) else (
    echo success
)
