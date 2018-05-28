---
layout: article
---

`define` are text replacing macros. The macro is substituted to it's text (if any). The macro must be matched exactly (if the text matches only part of the macro name it is not considered a match).

## text replacement

define a macro

```c++
#define MACRO_NAME text
```

undefine a macro (has no replacement, works like it was written code)

```c++
#undef MACRO_NAME
```

## example

```c++
#include <iostream>
#define MY_MACRO "my text from a macro"

int main()
{
    std::cout << MY_MACRO << "\n";
#undef MY_MACRO
    // std::cout << MY_MACRO << "\n"; // will not compile - MY_MACRO is unknown identifier
}
```

## text replacement with parameters

```c++
#include <iostream>
#define PRINT(arg1, arg2, arg3) std::cout << arg1 << arg2 << arg3

int main()
{
    int x = 10;
    double d = 3.14;
    PRINT(x, " ", d); // equivalent to std::cout << x << " " << d;
}
```

## \# operator

Expands the parameter into a quoted text

```c++
#include <iostream>
#define TO_STRING(x) #x

int main()
{
    // same as std::cout << "abc" << "xyz" << "\n";
    std::cout << TO_STRING(abc) << TO_STRING(xyz) << "\n";
}
```

## \#\# operator

Merges two (or more) arguments without any space between

```c++
#include <iostream>
#define TOGETHER(a, b, c) a ## b ## c // you can also write a##b##c 

int main()
{
    int my_variable = 100;
    std::cout << TOGETHER(my_, var, iable) << "\n";
}
```

## nesting macros

```c++
#include <iostream>
#define TO_STRING(x) #x
#define TOGETHER(a, b, c) TO_STRING(a ## b ## c)
#define PRINT(arg1, arg2, arg3) \
    std::cout << arg1 << arg2 << arg3
#define MY_MACRO "a macro"

int main()
{
    PRINT(TO_STRING(a string), TOGETHER(that, comes, from), MY_MACRO);
}
```

## recommendations

TODO formatting

<div class="note error">
<h4>macros are bad</h4>
Do not use text replacing macros - they can be easily abused. Macroed code is hardly readable. The preprocesor knows nothing about C++ syntax, so you can even do `#define MACRO a $ b %%% (}` and it will not complain until such macro is used where it would form invalid syntax.
</div>

**legitimate uses for macros**

- testing, logging - these usually require boilerplate code and macros reduce copy-paste and mistakes

- empty defines (just for `#ifdef` and similar directives) - to trigger specific parts of conditional compilation

- Technically, the macro name can be any identifier, but note that `YOU_SHOULD_ALWAYS_USE_UPPERCASE_NAMES_FOR_MACROS`. Such style prevents any name clashes with ordinary code. This is a very respected convention.

TODO descriptions, examples?
