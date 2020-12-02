@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> clean-local-release vendor-llvm

if exist release\ rmdir /Q /S release
