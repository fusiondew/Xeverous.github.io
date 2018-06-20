---
layout: article
---

Sometimes you may want to pass a variable number of arguments. There is a such possibility by using an ellipsis in argument declaration.

The most well-known function to do such thing is `printf` from C standard library.

```c
int printf(const char* fmt, ...);
```

Function takes the string representing the format and a variable amount of arguments that will be used to perform the print.

```c
int x = 10;
int y = 100;
printf("%d %d", x, y); // %d %f %s are various formatting options
```

## accessing variadic arguments

Since the number of arguments is not known at compile-time, obtaining them is not so straightforward. **Macros** are used to access arguments, they all start with `va_` (**v**ariadic **a**rguments).

```c++
typedef /* unspecified */ va_list; // use to create a named object of va_list type
void va_start(va_list ap, parm_n); // read arguments into ap after parameter name parm_n
T va_arg(va_list ap, T); // get next value interpreted as type T from ap
void va_copy(va_list dest, va_list src); // copy variadic arguments
void va_end(va_list ap); // clean up variadic argument list (always required)
```

Short example:

```c++
#include <iostream>
#include <cstdarg>

int add_nums(int count, ...)
{
    int result = 0;
    va_list args;
    va_start(args, count);

    for (int i = 0; i < count; ++i)
        result += va_arg(args, int);

    va_end(args);
    return result;
}

int main()
{
    std::cout << add_nums(4, 25, 25, 50, 50) << '\n';
}
```

## why variadic functions are bad

The purpose of this lesson is not to teach you how to use variadic arguments - they are not a good style. The entire feature is over 30 years old (1987) and at the time of it's creation it's problems were not as apparent as today. Now it's clear that it's a terrible feature and should not ever be used.

Concrete reasons:

- obscure **lowercase** macros
- bug-prone access to arguments (`va_` macros need to be in certain order)
- bug-prone calls - if more than needed arguments are specified, they are ignored; if less than needed - undefined behaviour
- variadic arguments have the same or worse performance than their alternatives
- variadic arguments undergo implicit convertions
- variadic arguments can violate type system - this can lead to undefined behaviour
- variadic argument types are restricted (only certain types can be used)
- the behavior of the `va_start` macro is undefined if the last parameter before the ellipsis has reference type, or has type that is not compatible with the type that results from default argument promotions

### better alternatives

- `std::initializer_list` - lightweight object holding multiple arguments of common type - explained later
- variadic templates - achieve compile-time well-defined behaviour with strict type safety, they are free of all variadic argument flaws - explained in template tutorial. This is basically the same feature but done the modern C++ way with full type safety

## summary

Scream when you see someone using variadic function arguments. They should better learn templates.

```c++
void print(const char* fmt, ...); // error-prone, types unchecked

template <typename... Ts>
void print(Ts&&... ts); // everything well-defined, types checked
```
