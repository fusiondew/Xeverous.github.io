---
layout: article
---

## implementation

Like with virtual table, I wanted to write a sample, manual implementation of exceptions. The problem here is that they are far more complicated and it's (probably) impossible to get them running manually without relying on "specific undefined/unspecified behaviour" or some compiler-specific features.

Still, there are "functions" that behave similarly to exceptions - [look at `std::longjmp`](https://en.cppreference.com/w/cpp/utility/program/longjmp).

TODO sjlj, seh, dw2 descriptions

## performance

The existence of exceptions in C++ is disputed. About half of the largest projects are compiled with `-fno-exceptions` or equivalent. Removing language feature completely makes the code non-standard C++ because standard library has somewhat changed behaviour.

It is a known problem but currently language creators can't give everyone satisfying solution. People who form the committee are often the same people who write top projects or write the compilers - they perfectly understand the problem. Currently the compromise are compiler options which let everyone have their project running however they like.

Exceptions are mostly disabled for these reasons:

- they can be very expensive (the cost of throwing exception is approximately 10-100 times higher than checking return codes)
    - virtual table
    - dynamic allocation
- they do not give any predictable guuarantees on the time it takes to process them
- they are weakly supported on rarer architectures
- they require stack information which bloats the executable
- they prevent some optimizations (without them, everything is `noexcept`)
- they are that one feature which is against C++ philosophy "you don't pay for what you don't use" - the sole possibility of exceptions to happen requires more machine code
- standard library can throw `std::bad_alloc` in every place of dynamic allocation - disabling exceptions removes possible overhead of checking pointers

## recommendation

I still encourage you to use exceptions because:

- exceptions are the best error handling mechanism (from feature capability point of view)
- it's better to write in ISO standard C++
- the size of programs you will write during learning is far below points in which you will be lacking top performance
- currently used exception mechanisms do not incur overhead unless an exception is actually thrown

## the future

The committee is aware of the problem. What looks very promising is [Herb Sutter's proposal](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p0709r0.pdf) which completely overhauls exceptions giving complete refactor of the feature - in both how exceptions work and what they can offer.

The committee also wants to remove `std::bad_alloc` and possible other unnecessary exceptions in the standard library - they would be replaced by *contracts* which are new, **configurable** language feature introduced in C++20. Such change would make significant part of the standard library `noexcept` and allow to write standard-compliant code while having choices how errors such as failed dynamic allocation are handled.
