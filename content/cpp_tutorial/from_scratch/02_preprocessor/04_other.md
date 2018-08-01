---
layout: article
---

There are few other preprocessor directives

## null directive

```c++
#
```

Does nothing.

## error

```c++
#error "quoted text"
```

Used to forcefully stop program build.

```c++
#ifdef SUPPORT_FOO
#include "foo_implementation"
#elif SUPPORT_BAR
#include "bar_implementation"
#else
#error "at least one of foo or bar must be supported"
#endif
```

GCC does this when you `#include` a file from C++ standard library which is not available in the given standard. Build stops upon something like `#error "to use this file you need to enable newer C++ standard"`.

## warning

```c++
#warning "quoted text"
```

This directive is a language extension. C++ standard does not mention such thing, but from user point of view it's purpose and usage is rather obvious.

By using this directive you will often get double warning: first, the text that this directive is used with; second, the information that this is a language extension.

## line

```c++
#line number
```

This directive changes value of `__LINE__` macro. Subsequent lines will have increasing numbers, starting from `number + 1`.

## pragmas

Compiler-specific command. Standard requires that unknown pragmas should be ignored (major compilers emit a warning in such case).

```c++
#pragma command
#_Pragma command
```

There is 1 very popular pragma:

```c++
#pragma once
```

Which is an alternative form of *header guards*. It's very broadly supported - there have been even attepts to standarize it.
