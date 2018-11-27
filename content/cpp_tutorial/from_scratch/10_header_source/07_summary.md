---
layout: article
---

## history

The current C++ build system is a remnant of first C build systems which required to split the code into multiple files because hardware at that time did not have enough memory for compilers to parse large files.

First editions of C did not have headers at all. They just blindly compiled each source trusting that arguments in each function call matches expected signature.

To get rid of undefined behaviour coming from misused function calls, header files have been introduced. Later editions of C made requirements for function declarations before they are used.

C++ has had hard declaration requirements since the beginning.

## today

In the past, we split code to multiple files to reduce memory requirements. Today, we do it to make working on code easier and more modular.

Still, compiling each source file in C++ separately is considered a bad and slow solution. There are build tools that perform *unity build* hack - they paste each header + each source file content in correct order into one giant source file and then compile it with one command. Such build system requires full rebuild of the entire program for any code change, but it is much faster when compared to the sum of separate single source file compilations.

Most IDEs automatically add commands for precompiled headers (if compiler supports them) to speed up incremental build process.

## the future

When modules come into C++ the build system will drastically change and header files will no longer be needed - they will be replaced by `import`, `export` and `module` keywords. Files will no longer be parsed in separate translation units. This will speed up the build, provide better error messages and make macro-based solutions obsolete.

## chapter summary

You can read [this article](https://github.com/green7ea/cpp-compilation/blob/master/README.md) which summarizes knowledge presented in this chapter. It also adds some historical background.
