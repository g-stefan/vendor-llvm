// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022-2024 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

messageAction("make");

if (Shell.fileExists("temp/build.done.flag")) {
	return;
};

if (!Shell.directoryExists("source")) {
	exitIf(Shell.system("7z x -aoa archive/" + Project.vendor + ".7z"));
	Shell.rename(Project.vendor, "source");
};

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("output/bin");
Shell.mkdirRecursivelyIfNotExists("output/include");
Shell.mkdirRecursivelyIfNotExists("output/lib");
Shell.mkdirRecursivelyIfNotExists("temp");

Shell.mkdirRecursivelyIfNotExists("temp/cmake");

if (!Shell.fileExists("temp/build.config.flag")) {
	Shell.copyFile("fabricare/CMakeLists.txt","source/CMakeLists.txt");

	Shell.setenv("CC","cl.exe");
	Shell.setenv("CXX","cl.exe");

	cmdConfig="cmake";
	cmdConfig+=" ../../source/llvm";
	cmdConfig+=" -G \"Ninja\"";
	cmdConfig+=" -DCMAKE_BUILD_TYPE=Release";
	cmdConfig+=" -DCMAKE_INSTALL_PREFIX="+Shell.realPath(Shell.getcwd())+"\\output";

	cmdConfig+=" -DLLVM_ENABLE_PROJECTS=\"clang;compiler-rt;libc;libclc;lld;lldb;mlir;polly;openmp;pstl;bolt;clang-tools-extra\"";
	cmdConfig+=" -DLLVM_ENABLE_RUNTIMES=\"libcxx\"";
	cmdConfig+=" -DLLVM_TARGETS_TO_BUILD=\"host;WebAssembly\"";
	cmdConfig+=" -DBUILD_SHARED_LIBS=OFF";
	cmdConfig+=" -DLLVM_ENABLE_RTTI=ON";
	cmdConfig+=" -DLLVM_ENABLE_EH=ON";
	cmdConfig+=" -DCMAKE_CXX_STANDARD=17";	

	runInPath("temp/cmake",function(){
		exitIf(Shell.system(cmdConfig));
	});

	Shell.filePutContents("temp/build.config.flag", "done");
};

runInPath("temp/cmake",function(){
	exitIf(Shell.system("ninja"));
	exitIf(Shell.system("ninja install"));
});

Shell.filePutContents("temp/build.done.flag", "done");
