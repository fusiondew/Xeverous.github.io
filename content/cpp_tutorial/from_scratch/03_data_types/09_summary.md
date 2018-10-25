---
layout: article
---

## Summary

Of course, you don't have to remember everything, here is the summary of crucial things:

- `void` represntes no data
- `bool` represents logic state, can only be `true` or `false`
- `int` represents whole numbers, can be `short` / `long` / `long long` and `signed` / `unsigned`
- `int` by default is signed
- `char` is an integer, but represents characters. There are no `long char`s - but types `char16_t`, `char32_t` and `wchar_t`
- `char` has no default signess, it's treated as distinct type at C++ language level even though in machine code it treated as `signed char` or `unsigned char`
- all 3 floating-point types (in accuracy order: `float`, `double`, `long double`) are signed and can support non-numeric values
- floating-point calculcations have limited accuracy and representation
- `const` doesn't let to modify the value and forces initialization
- `constexpr` doesn't let to modify the value and forces initialization from compile-time data

All of information from this lesson is available on [reference page](https://en.cppreference.com/w/cpp/language/types).

Note that in practice, for integers `int` is usually enough. $\pm2147483647$ range is fairly enough for most computations.

## custom types

- enumerations (named integer constants)
- structs (types consisting of built-in types or other structures)
- classes (yet to be explained)

## other types

Compilers may also support other non-standard architecture-specific types, for exaple `__float128` and `__int128` available in GCC and Clang.

#### Question: How big-number computations are done?

They use various custom encodings which span across multiple bytes. Numbers are stored in arrays which can have large lengths, although each cell does not necessarily represent each digit (it's more complicated).

Tools like WolframAlpha do not use floating-point types but complex data structures that store all mathematical data (eg roots, powers, fractions, integrals) and perform operations similar to humans (consecutive steps that attempt to simplify notation). This allows to achieve infinite precision but symbolic math calculations are several orders of magnitude slower.
