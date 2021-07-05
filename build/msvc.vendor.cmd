@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> vendor vendor-llvm

goto getSizeDefined
:getSize
set FILE_SIZE=%~z1
goto:eof
:getSizeDefined

if not exist archive\ mkdir archive

rem Self
if exist archive\%PROJECT%-%VERSION%.7z goto:eof
curl --insecure --location https://github.com/g-stefan/vendor-%PROJECT%/releases/download/v%VERSION%/%PROJECT%-%VERSION%.7z --output archive\%PROJECT%-%VERSION%.7z
call :getSize "archive\%PROJECT%-%VERSION%.7z"
if %FILE_SIZE% GTR 16 goto:eof
del /F /Q archive\%PROJECT%-%VERSION%.7z goto:eof

rem Source
pushd archive
set VENDOR=%PROJECT%-%VERSION%
if exist %VENDOR%.7z popd && goto:eof
set WEB_LINK=https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz
if not exist llvm-project-11.0.0.tar.xz curl --insecure --location %WEB_LINK% --output llvm-project-11.0.0.tar.xz
7z x llvm-project-11.0.0.tar.xz -so | 7z x -aoa -si -ttar -o.
del /F /Q llvm-project-11.0.0.tar.xz
move /Y llvm-project-11.0.0 %VENDOR%
7zr a -mx9 -mmt4 -r- -sse -w. -y -t7z %VENDOR%.7z %VENDOR%
rmdir /Q /S %VENDOR%
popd
