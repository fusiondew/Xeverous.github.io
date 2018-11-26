---
layout: article
---

## inline

We can workaround the problem of multiple reference linker error by adding `inline` to function definitions in **func.cpp** and **func2.cpp**. TODO confirm it

```c++
inline
int func(int a, int b)
{
    return a + b;
}
```

`inline` keyword informs the linker that a definition can repeat. Still, every definition must be identical.

Of course it's not a good solution to the problem. Additionally, a lot of inline definitions can slow the build because we essentially compile the same definition multiple times only to discard duplicates at the linking stage.

So what is the purpose of this keyword? It's needed for some code generation mechanisms that are hard to predict what definitions they produce. Almost all templates are inline by default - in most contexts `template` and `constexpr` imply `inline` (there is no need to write it).

`inline` itself is rarely written explicitly, it's more common as a hidden implication of other keywords.

The actual use of explicitly written `inline` is defining a function inside a header file. Each source file that includes such header will duplicate it's definition.

## in-header definitions

Why would you want to define a function inside a header?

#### build simplification

C++ has rather complex build system and sometimes it's easier to distrubute a small library as a single header file that only needs to be included instead of splitting code to source files and then supporting various build systems or requiring dirty solutions such as copy-pasting file to project repository. This issue still holds but hopefully modules and already ongoing works on unifying C++ build system interface will solve the problem in the future. Some libraries already support package managers.

#### definition requirements

Templates and compile-time functions need to provide their full definition before they are used. They are not executable code themselves but participate in code generation mechanisms that require complete information.

A compiler can not compile a call to function template because it does not provide all type and memory layout information. Upon calling, the template definition is parsed again and generic code is instantiated with specific template parameters that form actual function definition.

For this reason, template definitions are put into header files to make them visible for any source file. Each source file will then use them with potentially different template parameters. At linking stage, any duplicate instantiations will be discarded.

#### optimization

A different motivation was related to additional, historical usage of `inline`: they keyword told the compiler to optimize code through *function inlining*.

Inlined funcions were copied in-place instead of forming a separate assembly routine for them (this required definition visible from headers). For example, instead of calling a function in the example above compiler could inline it to put `2 + 3` directly into main function (and then optimize it even further). Inlined functions work faster (no stack operations and less jumps in machine code) but make executable programs larger (copy-pasted function bodies instead of jumps to subroutines). Too heavy inlining can negatively impact performance - functions very often call other functions so too much inlining creates strains on cache.

For more information about inlining, see [inline expansion](https://en.wikipedia.org/wiki/Inline_expansion). TODO add favicon to link
 
As time progressed, it tured out that compilers are significantly better than humans at deciding whether it's worth to inline a specific function call and the keyword began to be ignored - modern compilers perform inlining where the keyword is not used and not perform this double-edged optimization where the keyword is used.
