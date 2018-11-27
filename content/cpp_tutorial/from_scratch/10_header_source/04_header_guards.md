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
