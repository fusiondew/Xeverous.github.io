---
layout: article
---

`ABC` - abstract base class. ABCs have at least 1 unimplemented virtual function and can not be instantiated.

[`Boost`](https://en.wikipedia.org/wiki/Boost_(C%2B%2B_libraries)) - a collection of over 80 high-quality C++ libraries for various purposes. Many have been incorporated into C++ standard, with also many proposed for inclusion in future standards. Boost is sometimes referred to as "the second standard".

`build` (as a noun) - a ready to use (compiled and linked) program made from source code with certain configuration.

`CMake` - meta build tool, commonly used by various C and C++ projects to generate project files and makefiles

`CRTP` - curiously recurring template pattern allowing a unique form of static polymorphism. Explained in relevant TTT chapter.

`GCC` - originally "GNU C Compiler", now "GNU Compilers Collecion". The de facto standard compiler toolchain for most GNU/Linux distributions.

`IDE` - integrated development environment. Usually an advanced code editor with autocomplete and rich refactor features integrated with build system, compiler and debugger.

`interface` - a type (class) that has no member variables and constants and only pure (unimplemented) virtual functions. There is no special notion of interfaces in C++ because there are no restrictions on members and inheritance.

`LEWG`, `LWG` - library (evolution) working group. Parts of the [C++ Committee](https://isocpp.org/std/the-committee).

`makefile` - a file with incrementl build directives used by GNU make command line program. Various IDEs and other tools create makefiles and then call make which will call compiler and linker with appropriate arguments.

`MinGW` - Minimalist GNU for Windows, the most commonly used GCC port for Windows. Builds native Windows 32 and 64 bit executables.

`MI` - multiple inheritance.

`MSVC` - Microsoft Visual C/C++ compiler.

`MSYS2` (minimal system) - package manager for GNU toolchains for Windows. [Used by Qt](https://wiki.qt.io/MSYS2).

`null`, `NULL`, `nullptr`, `nil` - the lack of object, a null (empty, invalid) memory address. On x86 equivalent to <pre>0x00000000</pre>. Using (dereferencing) a null pointer is undefined behaviour.

`pointer` - a variable that does not store ordinary data, but holds the address of another variable. Pointers to pointers are possible.

`reference` - an alias to a variable or constant. Does not offer all possibilities of pointers, but it safer and easier to optimize. References to references do not exist (C++ implements reference collapsing).

`segfault` - [Segmentation Fault]((https://en.wikipedia.org/wiki/Segmentation_fault)). Error caused by dereferencing an invalid poitner (not necessarily a null pointer) or violating virtual memory access.

`SFINAE` - Substitution Failure Is Not An Error. Template instantiation mechanism used to disable certain implementations based on the type or value properties. Explained in relevant TTT chapter.

`SIGSEGV` - [Signal](https://en.wikipedia.org/wiki/Signal_(IPC)) thown to the program after encountering segentation fault or similar error.

[`singleton`](https://en.wikipedia.org/wiki/Singleton_pattern) - A type that is supposed to be only instantiated once. Often regarded as an anti-pattern.

`smart pointer` - a pointer that <del>is smart</del> automatically manages underlying resource (not necessarily memory). Standard library offers classes for unique ownership model (`std::unique_ptr`) and shared ownership model (`std::shared_ptr`, `std::weak_ptr`). Additional and legacy smart pointers are offered by Boost. [SO question](https://stackoverflow.com/questions/106508/what-is-a-smart-pointer-and-when-should-i-use-one).

`std` - the standard library namespace. Every identifier except macros is inside this namespace.

`STL` - standard template library. More than 95% of standard C++ library. Templates are found in various headers - this term is simply covering them all.

`this` - a pointer to the object itself, available in any non-static member function. Necessary in some contexts. `this` (if available) is never null.

`toolchain` - a set of tools (programs, scripts) used to build a project. The typical minimal toolchain would invole a text editor, compiler and debugger. Bigger projects additionally use documentation tools, static analyzers, continuous integration tools and more.

`Qt` (cute) - The biggest C++ GUI framework and set of GUI-related libraries, also probably the only one having WYSIWYG UI editor.

`Qt Creator` - IDE from Qt company. Has integrated support for Qt libraries.

`vtable` - [virtual method table](https://en.wikipedia.org/wiki/Virtual_method_table). In typical runtime dispatch implementation, each class that has at least 1 virtual function has embedded vtable pointer as it's first member.
