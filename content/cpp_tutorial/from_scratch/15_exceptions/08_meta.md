---
layout: article
---

## implementation

Like with virtual table, I wanted to write a sample, manual implementation of exceptions. The problem here is that they are far more complicated and it's (probably) impossible to get them running manually without relying on "specific undefined/unspecified behaviour" or some compiler-specific features.

Still, there are 2 "functions" that behave similarly to exceptions - [`std::longjmp`](https://en.cppreference.com/w/cpp/utility/program/longjmp).

## performance

The existence of exceptions in C++ is disputed. About half of the high-effort projects are compiled with `-fno-exceptions` or equivalent. Compilers offer to remove exceptions language feature completely (thus making code non-standard C++) because people who write compilers are in close relation to people who create the language and people who write top big C++ projects. It is a known problem but currently language creators can't give everyone satisfying solution.

Exceptions are mostly disabled for these reasons:

- they can be very expensive
    - virtual table
    - dynamic allocation
- they do not give any predictable guuarantees on the time it takes to process them
- they require stack information which bloats the executable
- they prevent some optimizations (without them, everything is `noexcept`)
- they are that one feature which is against C++ philosophy "you don't pay for what you don't use" - the sole possibility of exceptions to happen requires more machine code

## the future
