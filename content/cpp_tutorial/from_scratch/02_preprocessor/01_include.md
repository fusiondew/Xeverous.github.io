---
layout: article
---

## preface

Preprocessor is a program which performs text-related tasks before the actual code is given to the compiler.

From other languages point of view, C++ build system is pretty primitive and needs some manually written information but at the same time it offers things that are not possible outside C/C++ world.

Modules are being worked on as a complete overhaul of C++ build system that will change how projects are build and significantly reduce preprocessor usage. Some compilers/IDEs are already providing experimental support.

## the need for metadata

Every language has sort of system which informs about *dependencies*.

In the case of C++ hello world program, the dependency is `std::cout`. Input/output streams are a part of C++ standard library. Before they are used, compiler must be informed what it is and where it does come from. Otherwise it will be like "hey, you use that `std::cout` thing but I do not know what this name represents".

In other words, we need to provide definitions for stuff before it is used - otherwise we are spilling unknown terms without prior explanation.

## how it works

Preprocessor is run before the actual code is parsed. This means it does not "read" the code, it only cares about "text". Preprocessor operations are just text insertion and replacement.

## syntax

All lines for the preprocessor start with `#`.

```c++
#directive arguments...
// code...
```

Preprocessor directives extend only across a single line. As soon as a newline character is found, the preprocessor directive ends. No semicolon is expected at the end of a preprocessor directive. If you want to extend through more than one line precede the newline character at the end of the line by a backslash.

```c++
#directive arguments... \
arguments... \
arguments... \
arguments
// normal code on this line
```

## includes

The most trivial preprocessor directive is include. It simply tells the preprocessor "in place of this line, paste contents of mentioned file".

```c++
#include <iostream>
```

What's exactly inside iostream depends on the compiler. What can be sure though, that inside this file `std::cout`, `std::cin` and other stuff from I/O stream library is declared or defined.

**syntax**

There are 2 ways a file can be included:

```c++
#include <file>
#include "file"
```

The difference is that files mentioned by the first are searched in:

- compiler installation directory
- explicitly added paths

and the second are searched in:

- the same directory as the originating file
- explicitly added paths

The `<>` form is intended for C++ standard library and is also used for external libraries.

The `""` form is intended for your own files - since they are expected to be together (in the same or very close directories) files are searched starting from the same directory as the file which mentions them (paths are relative).

<div class="note info">
In any case, if included file can not be found program compilation fails.
</div>

**Includes are recursive**

Assume file **a** includes file **b** because it uses b's stuff in it's code. But **b** also uses **c** so it includes **c** aswell.

```c++
// ---- file a ----
#include "b"
// code uses some b...
// code defines a

// ---- file b ----
#include "c"
// code uses some c...
// code defines b

// ---- file c ----
// code defines c
```

In such scenario, including **a** also provides **b** and **c**. Thanks to such system, we do not need to think what are the dependencies of dependencies.

`<iostream>` may also include other files. These are usually system-specific headers which are necessary to communicate with the operating system to output text on the screen.

#### Question: What will happen if there is a loop in includes? Eg file **a** includes **b** and **b** includes **a**?

I'm not sure what error message you will get but for sure the program will not build.

There can not be any circular dependencies in includes. It should more look like a tree where each file includes files from lower levels.

Sometimes circular dependencies may happen in the code - for example, both code **a** and code **b** needs to refer each other. You will later learn about mechanisms which solve this problem - namely *header files* and *source files*.

## other notes

Preprocessor is a process that happens transparently - you don't see the generated files with pasted/replaced content. Most of the build process, which consists of many more steps than just preprocessor is done completely in memory.

This is not a strict technical requirement, but it's a big optimization to avoid unnecessary disk operations. That's one of the reasons documentation uses the term *translation unit* instead of *file* when describing compilation process.
