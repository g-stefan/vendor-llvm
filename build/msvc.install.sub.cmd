@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

rem --- make

cmd.exe /C build\msvc.make.cmd
if errorlevel 1 exit 1

rem ---

if not exist "%INSTALL_PATH%\" mkdir "%INSTALL_PATH%"

xcopy /Y /S /E "output\*" "%INSTALL_PATH%\"


