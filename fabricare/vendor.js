// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022-2023 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

messageAction("vendor");

Project.vendor = Project.name + "-" + Project.version;

Shell.mkdirRecursivelyIfNotExists("archive");

// Self
if (Shell.fileExists("archive/" + Project.vendor + ".7z")) {
	if (Shell.getFileSize("archive/" + Project.vendor + ".7z") > 16) {
		return;
	};
	Shell.removeFile("archive/" + Project.vendor + ".7z");
};

exitIf(Shell.system("curl --insecure --location https://github.com/g-stefan/vendor-" + Project.name + "/releases/download/v" + Project.version + "/" + Project.vendor + ".7z --output archive/" + Project.vendor + ".7z"));
if (Shell.getFileSize("archive/" + Project.vendor + ".7z") > 16) {
	return;
};
Shell.removeFile("archive/" + Project.vendor + ".7z");

// Source
runInPath("archive", function() {
	webLink = "https://github.com/llvm/llvm-project/releases/download/llvmorg-"+Project.version+"/llvm-project-"+Project.version+".src.tar.xz";
	if (!Shell.fileExists(Project.vendor + ".tar.xz")) {
		exitIf(Shell.system("curl --insecure --location " + webLink + " --output " + Project.vendor + ".tar.xz"));
	};
	Shell.system("7z x " + Project.vendor + ".tar.xz -so | 7z x -aoa -si -ttar -o.");
	Shell.removeFile(Project.vendor + ".tar.xz");
	Shell.removeFile(Project.vendor + ".7z");
	Shell.rename("llvm-project-"+Project.version+".src",Project.vendor);
	exitIf(Shell.system("7z a -mx9 -mmt4 -r- -sse -w. -y -t7z " + Project.vendor + ".7z " + Project.vendor));
	Shell.removeDirRecursively(Project.vendor);
});
