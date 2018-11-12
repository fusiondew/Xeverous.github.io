---
layout: article
---

This is the start of accelerated tutorial. It is aimed to go faster and not bother you with boring things such as functions, scoping, basic OO which you know already from other language.

Before going further, make sure you know these terms:

- compiler
- linker
- IDE
- debugger
- source code, machine code
- compiled vs interpreted language

If you don't, you have ommited core stuff (which is much more important in compiled languages) or used so sophisticated tools that only the code was your problem. I advice you to go to from scratch tutorial instead as this is important knowledge which without you may pretty fast end up in frustrations of not understanding tools or configuration errors.

## Some facts

C++ is:

- statically typed, NOT dynamically like in JavaScript or Python
- compiled, NOT interpreted
- having own (almost unique) memory management system, NO garbage collection
- different than C (code which works in both may often be a good C but bad C++)
- ISO standardized, NOT owned by any company

## I have experience in .... How much will it help me?

The most close language is C# (actually there are closer ones, but I do not want to talk about non-standard C++ forks which do not have any wide use) with 2nd place being Java. They both share very similar syntax and language rules. Up to certain point, most features will be identical or have only minor syntax differences.

Most basic stuff will be shortened as I assume you know these fundamental things. I will not explain them but there will be syntax examples for everything.

- control flow (ifs, loops, etc)
- functions
- basics about OOP and polymorphism
- basics about C-based syntax (`{}, (), []` etc, scoping and similar)

Features you are likely to know, but have important differences in C++:

- OOP (eg multiple inheritance, virtual inheritance, no interfaces)
- `const`/`final`/`readonly` (`const` has much bigger power in C++)
- `var`/`let`
- operator overloading (C++ offers much more than C#)
- exceptions

Features that are very different in C++:

- Memory management: if you previously worked only with garbage-collected languages, this will be a whole new thing. It's not that hard as you may expect. Surprise fact: `new` in C++ is not used for what you may think it is.
- Multithreading (reason: look point above).
- Templates. It's a very different thing from dynamically typed languages and from generics in C# and Java. Functions or classes accepting `T` are only the beginning of metaprogramming, not the feature itself.
- Build system: header + source files (reason: C compability, but this is changing, Modules in 2020)

Features that are not (yet) in C++

- advanced RTTI
- reflection
- pattern matching