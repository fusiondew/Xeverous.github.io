---
layout: article
---

This chapter is a bit different. Instead of learning language features I will more closely explain C++ build system and how to split code into multiple files. Soon the presented programs will become significantly longer and it would be good to learn how to organize code.

## ODR

TODO paste remainder on ODR

ODR is crucial when building a project from multiple source files because:

- you need to provide information for the compiler (eg function declarations)
- you don't want to duplicate code

This leads us to splitting code in certain way: **header** and **source** files.

## build

Each source file is built separately, without the knowledge of any other source files. Each source file includes necessary headers to fullfill it's declaration requirements.

Each source file is compiled with included headers as one **translation unit**.

Example:

TODO example + dependency graph.

## inclusion syntax

TODO paste remainder on "" vs <> from first chapter.

## naming convention

C originally used `.h` for header and `.c` for source files.

`.cpp` is universally recognized as C++ source file, but many projects use `.h` for C++ headers. I would not recommend this extension as it does not clearly indicate it's a C++ file. Various tools and humans can confuse this extension as C code and we have a lot of projects that mix C and C++ code.

Therefore I recommend `.hpp` and `.cpp` for C++ files. This convention is self-consistent and clearly indicates that both types of files contain C++ code. Some projects use `.hh` and `.cc` but this convention is less popular.

Other benefit of not using `.h` extension is that some libraries offer both C and C++ interfaces. `library.h` and `library.hpp` can then be put into 1 directory and there is no confusion or name conflicts.
