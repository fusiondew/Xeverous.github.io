---
layout: article
---

Another type of preprocessor directive are "defines". They actually don't define any code (eg they can not specify what is `std::cout`) but some identifiers that can be used by other preprocessor directives.

**syntax**

```c++
#define identifier
#undef identifier
```

These alone do not offer any power, but there are directives which behave conditionally depending on the existence of such identifiers

```c++
#ifdef  identifier // does something only if identifier is defined
#ifndef identifier // does something only if identifier is not defined
#endif             // closes conditional block

// short versions - see examples
#if
#else
#elif
```

The designated use of these directivies is **conditional compilation**. Depending on some identifiers, different code may be used.

```c++
#ifdef __linux__
#include "linux_specific_code"
#elif defined ANDROID
#include "android_specific_code"
#else
#include "windows_specific_code"
#endif
```

This way C and C++ code can achieve independence from operating system - preprocessor can issue different code depending on some identifiers.

## predefined identifiers

There are some predefined identifiers which always exist. They are:

TODO paste some examples from macro dump

- identifiers mandated by C++ language
- identifiers issued by the compiler
    - version of the compiler
    - architecture-describing data
    - system-describing data (eg `_WIN32`, `__linux__`)
