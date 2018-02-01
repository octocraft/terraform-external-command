@echo off

set OSTYPE=windows

:: Convert back- ot forward slashes and remove trailing slash (bash will break if backslashes are not escaped)
set script_dir=%~dp0
set script_dir=%script_dir:~0,-1%
set script_dir=%script_dir:\=/%

%script_dir%\bin\windows\bash.exe %script_dir%/run.sh %*
