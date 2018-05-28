---
layout: article
---

Before the code is given to the compiler, it is passed through a preprocessor. All lines that are intended for the preprocessor are started with `#`.

## syntax

```c++
#directive arguments...
// code...
```

Preprocessor directives extend only across a single line of code. As soon as a newline character is found, the preprocessor directive ends. No semicolon is expected at the end of a preprocessor directive. If you want to extend through more than one line preced the newline character at the end of the line by a backslash.

```c++
#directive arguments... \
arguments... \
arguments... \
arguments
// normal code on this line
```

## overview of preprocessor commands

There are not many commands, below is just a brief description what they do.

- `include` directive - informs that the code below needs the code in the included file to work; this is essentially a copy-paste of the included file into the place where the directive is

```c++
#include <iostream>

// the code below uses stuff from I/O stream library

// code...
```

- `define`, `undef` - text replacing macro

```c++
#define COMPANY_NAME "company foo bar"

// every code that uses COMPANY_NAME will get it replaced with the string
```

- `if`, `ifdef`, `ifndef`, `else`, `elif`, `endif` directives - conditional compilation

```c++
// code that works on any system...
#ifdef __linux__
// some linux specific code
#else
// code specific for other systems (usually Windows)
#endif
// code that works on any system...
```

- `error` directive - used to forcefully stop program build

```c++
#ifdef __support_foo
// code...
#elif __support_bar
// code...
#else
#error "at least one of foo or bar must be supported"
#endif
```

- `pragma`, `_Pragma` - compiler-specific command, ignored if not recognized

```c++
#pragma once // alternative header guard
```

- `line` - changes the value of `__LINE__` macro

```c++
#line 1
```

- ` ` - null directive (does nothing)

```c++
#
```

