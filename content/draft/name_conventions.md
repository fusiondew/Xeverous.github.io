---
layout: article
---

legend:

- **very strong** - used practically always
- **strong** - used most of the time
- **weak** - used when there is no better alternative (usually there is one)

## main function

- (very strong) `argc` - argument count variable name
- (very strong) `argv` - argument values variable name

## generic names

When we want to express that any object of the given type is allowed.

- `str` - string
- `ptr` - pointer
- `n`, `len` - integer, usually array length
- `bufsz` - integer, buffer size
- (very strong) `i`, `j`, `k`, ... - loop control variables - probably originated from `i` as a shortcut for *iteration* - this convention applies to many programming languages
- (very strong) `it` - iterator-based loop or algorithm iterator argument
- (weak) `lhs`, `rhs` (left/right hand side) - used for operator overloading and comparisons

## templates

- (very strong) `T`, `U`, `V` and so on - similarly to loops, likely originated from `T` as a shortcut for *type* or *template*
- (very strong) `Iterator`, `UnaryPredicate`, `TriviallyCopyable` - concept names for types that are expected to satisfy certain requirements (since C++20 actual language feature, no longer a convention)
- (very strong) `Args` for variadic templates

## standard library

- `basic_*` for any class template that is expected to be instantiated with different parameters; used by strings and streams
- `*_type` - member type aliases, found in containers and iterators
- `*_t` - type aliases found in type traits
- `*_v` - values found in type traits
- there is no pattern for exception class names like `E*` or `*Exception` in other languages
- there is no pattern for interface class names like `I*` or `*Interface` in other languages
