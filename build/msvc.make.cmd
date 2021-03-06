@echo off
rem Public domain
rem http://unlicense.org/
rem Created by Grigore Stefan <g_stefan@yahoo.com>

set ACTION=%1
if "%1" == "" set ACTION=make

echo -^> %ACTION% vendor-llvm

goto cmdXDefined
:cmdX
%*
if errorlevel 1 goto cmdXError
goto :eof
:cmdXError
echo "Error: %ACTION%"
exit 1
:cmdXDefined

if not "%ACTION%" == "make" goto :eof

call :cmdX xyo-cc --mode=%ACTION% --source-has-archive llvm

if not exist temp\ mkdir temp
if not exist temp\cmake mkdir temp\cmake

pushd temp
set WORKSPACE_PATH_BUILD=%CD%
popd temp

if exist %WORKSPACE_PATH_BUILD%\build.done.flag goto :eof

pushd temp\cmake

SET CMD_CONFIG=cmake
SET CMD_CONFIG=%CMD_CONFIG% ../../source/llvm
SET CMD_CONFIG=%CMD_CONFIG% -G "Ninja"
SET CMD_CONFIG=%CMD_CONFIG% -DCMAKE_BUILD_TYPE=Release
SET CMD_CONFIG=%CMD_CONFIG% -DCMAKE_INSTALL_PREFIX=%WORKSPACE_PATH_BUILD%\llvm
SET CMD_CONFIG=%CMD_CONFIG% -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libc;libclc;libcxx;libcxxabi;libunwind;lld;lldb;mlir;openmp;parallel-libs;polly;pstl;"
SET CMD_CONFIG=%CMD_CONFIG% -DLLVM_TARGETS_TO_BUILD="host;WebAssembly"
SET CMD_CONFIG=%CMD_CONFIG% -DLLVM_ENABLE_RTTI=ON

if not exist %WORKSPACE_PATH_BUILD%\build.configured.flag %CMD_CONFIG%
if errorlevel 1 goto makeError
if not exist %WORKSPACE_PATH_BUILD%\build.configured.flag echo configured > %WORKSPACE_PATH_BUILD%\build.configured.flag

ninja
if errorlevel 1 goto makeError
ninja install
if errorlevel 1 goto makeError

goto buildDone

:makeError
popd
echo "Error: make"
exit 1

:buildDone
popd
echo done > %WORKSPACE_PATH_BUILD%\build.done.flag
