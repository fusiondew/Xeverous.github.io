---
layout: article
---

A problem you might run into when building complex projects are multiple definition errors caused by multiple inclusion of the same header.

Imagine such project:

**bar.hpp**

```c++
// (no includes)

// ...
```

**foo.hpp**

```c++
#include "bar.hpp" // (2)

// bar stuff is used ...
```

**foo.cpp**

```c++
#include "foo.hpp" // (1)
#include "bar.hpp" // (3)

// foo stuff is used ...
// bar stuff is used ...
```

TODO remainder block

Included files are scanned from top to bottom, with depth-first search.

Here, when compiling **foo.cpp** the following happens:

- (1) **foo.hpp** is required - enter this file
  - (2) **bar.hpp** is required - enter this file
    - bar stuff is parsed
    - go back to continue with **foo.hpp**
  - foo stuff is parsed (it can depend on bar)
  - go back to continue with **foo.cpp**
- (3) **bar.hpp** is required - enter this file
  - bar stuff is parsed again
  - go back to continue with **foo.cpp**

The file **bar.hpp** is read twice.

## ODR vs headers

At first, it does not seem it could cause any trouble. ODR allows multiple declarations as long as every is the same.

But what if headers contain definitions? `inline` does not solve the problem here because it allows multiple definitions at linking stage, not at compilation.

What's more, some C++ features will require us to put definitions into headers: classes, templates, compile-time functions etc.

## the problem

- We need to provide necessary declarations for each source file.
- Some headers need other headers to provide their own declarations.
- Some source files can end up including the same header multiple times through other, different headers.

Ideally, we would like to provide each required header for each header/source file but do it exactly once.

## the solution

**Header guards** are a set of specific preprocessor directives that block reading included files once they have already been parsed.

The mechanism is simple - test for a unique macro and define it only if it has not already been defined.

Fixing the example project:

**bar.hpp**

```c++
#ifndef BAR_HPP
#define BAR_HPP

// original entire file content ...

#endif // BAR_HPP
```

**foo.hpp**

```c++
#ifndef FOO_HPP
#define FOO_HPP
#include "bar.hpp" (2)

// original entire file content ...

#endif // FOO_HPP
```

**foo.cpp**

```c++
// (there is no need for include guards in source files)
#include "foo.hpp" (1)
#include "bar.hpp" (3)

//  ...
```

Now, the compilation of **foo.cpp** looks as follows:

- (1) **foo.hpp** is required - enter this file
  - `FOO_HPP` has not yet been defined, parse content until `#endif`
  - `FOO_HPP` is defined on the next line
  - (2) **bar.hpp** is required - enter this file
    - `BAR_HPP` has not yet been defined, parse content until `#endif`
    - `BAR_HPP` is defined on the next line
    - bar stuff is parsed
    - `#endif` is encountered at the end of file
    - go back to continue with **foo.hpp**
  - foo stuff is parsed (it can depend on bar)
  - `#endif` is encountered at the end of file
  - go back to continue with **foo.cpp**
- (3) **bar.hpp** is required - enter this file
  - `BAR_HPP` is already defined, skip reading untill `#endif`
  - `#endif` is encountered at the end of file
  - go back to continue with **foo.cpp**

The second time **bar.hpp** was read the macro was already defined which caused preprocessor to skip file content.

<div class="note pro-tip">
Always add header guards to any header you create.
</div>

<div class="note info">
There is no need for header guards in source files since they are never included.
</div>

### convention

Various IDEs automatically generate header guards. There is no definitive convention here but header guards work as long as each file has a unique macro across entire project.

For this reason, header guard macro names are usually generated from file paths and names. Some IDEs add date and/or random strings for extra safety. Some libraries also encode version number.

## alternative solution

There is an alternative preprocessor directive which simply tells the preprocessor to parse the file once:

```c++
#pragma once

// file content...
```

This is not an officially standarized solution (pragmas are compiler extensions) but all major (and some less popular) compilers support it with no problems.

If your IDE does not automatically generate macro definition based include guards you can use this solution instead.

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
