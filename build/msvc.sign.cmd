@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

echo -^> sign vendor-llvm

pushd temp\llvm\bin
for /r %%i in (*.dll) do call grigore-stefan.sign "llvm" "%%i"
for /r %%i in (*.exe) do call grigore-stefan.sign "llvm" "%%i"
popd
