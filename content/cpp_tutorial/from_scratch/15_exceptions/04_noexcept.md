---
layout: article
---

## `noexcept` specification

Every function (member and non-member, also static functions) may be specified as `noexcept`. It informs the compiler with "This function will not throw. At least it should not.".

**the benefit**

- Users of the function can be sure that they do not have to catch any exception.
- Compiler can apply certain optimizations that normally would break exception handling (stack unwinding requires stack information).

**the consequence**

- Unline `const`, `noexcept` is not strictly enforced at compile time. You can call *potentially throwing* functions inside *non-throwing* functions. But be aware of the result if an exception does happen and it exits the scope of *non-throwing* function (this is not UB but still something you would like to avoid).

**other info**

- pointers to non-throwing functions can not be set to throwing functions
- if base virtual function is `noexcept`, overriders also have to
- just like return type, `noexcept`
    - is a part of function type
    - is not a part of function signature

**Remainder:** functions overload by different signatures, not types. You can not overload just by different return type or `noexcept`.

<div class="note pro-tip">
Everything that for obvious reasons can not throw is implicitly `noexcept` - for example all atomic operations and all functions from C standard library.
</div>

## `noexcept` operator

Returns compile-time constant of type `bool` depending **if the expression can not throw** (don't be mislead by negation) exceptions. Just like with `sizeof` operator, the expression is not evaluated.

```c++
#include <iostream>
#include <vector>

int main()
{
    std::cout << std::boolalpha; // print true/false instead of 1/0
    std::cout << "Can vector's operator[] throw? " << !noexcept(std::vector<int>()[0]) << '\n';
    std::cout << "Can vector's at() throw? " << !noexcept(std::vector<int>().at(0)) << '\n';
}
```

## `noexcept(bool)`

The keyword `noexcept` can accept a constant expression that is convertible to `bool`.

```c++
void foo1() noexcept;
void foo2() noexcept(true); // same as above
void bar1();
void bar2() noexcept(false); // same as above
```

This, together with `noexcept` operator is often used in function templates:

```c++
// function template will possibly throw only of construction of type T can throw
template <typename T>
void func() noexcept(noexcept(T()));
//          ^^^^^^^^ specifier
//                   ^^^^^^^^ operator
```

## standard library

Many functions/classes in the standard library expect certain operations to never throw. Otherwise they will use other, inefficient methods or generally be broken.

Standard library expectations:

- `noexcept` destructors (**note:** dtors are `noexcept` by default unless any member of the class has *potentially throwing* destructor)
- `noexcept` move constructors and assignments
- `noexcept` swap operations (these rely on moves) - eg user-defined specializations of `std::swap` template
- `noexcept` everything that does deallocation (user-defined overloads of `delete`, user-provided allocators etc)

<div class="note pro-tip">
Mark move and swap operations (including constructors and `operator=`) `noexcept`.
</div>

<div class="note pro-tip">
Mark destructor `noexcept` only if necessary - when destructors of members could throw. This will block propagation which anyway can not be dealt with.
</div>

## dynamic exception specification

<div class="note info" markdown="block">
This feature:

- has been deprecated since C++11
- has been removed in C++20
</div>

In the past standards it was possible to specify which exceptions exactly a function can throw.

```c++
void func() throw(std::exception, my_exception_class);
```

This was similar to the exception specification that the Java language offers. In both languages, the existence of the feature is/was disputed (read: controversial).

It has been deprecated and removed from C++ for multiple reasons:

- it does not enforce what it states (simply useless information)
- the information is not useful for humans; humans change code, do hidden mistakes and shot themselves in the foot by calling `std::unexpected` and then `std::terminate`
- the information is not useful for compilers (throws or not - optimizer doesn't care what) - **it has actually prevented certain optimizations** (optimizer had to care and place "hidden ifs")
- dynamic exception specification was not consistent with language type system - dynamic exception specification did not participate in function's type, except when it did
- dynamic exception specification could not be used in some contexts (eg in `typedef`s of function pointers), thus blocking some language features

For more detailed summary, read [this publication](http://www.gotw.ca/publications/mill22.htm).
