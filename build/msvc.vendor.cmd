@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo - %BUILD_PROJECT% ^> vendor

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
set WEB_LINK=https://github.com/llvm/llvm-project/releases/download/llvmorg-%VERSION%/llvm-project-%VERSION%.src.tar.xz
if not exist llvm-project-%VERSION%.src.tar.xz curl --insecure --location %WEB_LINK% --output llvm-project-%VERSION%.src.tar.xz
7z x llvm-project-%VERSION%.src.tar.xz -so | 7z x -aoa -si -ttar -o.
del /F /Q llvm-project-%VERSION%.src.tar.xz
move /Y llvm-project-%VERSION%.src %VENDOR%
7z a -mx9 -mmt4 -r- -sse -w. -y -t7z %VENDOR%.7z %VENDOR%
rmdir /Q /S %VENDOR%
del /F /Q pax_global_header
popd
