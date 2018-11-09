---
layout: article
---

## preface

The following tutorial is aimed at people who already know programming principles (best suited for people who have experience with other C-family languages, especially Java and C#) and would like to learn another language without the need to go through all the basic stuff while at the same time not being afraid they accidentally skipped something important.

Thus, this tutorial does not expain and assumes you understand:

- basic control flow keywords
- in general, how strongly typed languages work
- in general, how pointers work and why they have to exist
- function overloading
- OOP concepts (abstraction, inheritance, polymorphism)
- exceptions
- in general, the purpose of lambdas
- how IDEs work in general and the command line

I will still show a lot of basic stuff just to make you familiar with the syntax - while most languages have for-each loop each has a different syntax for it.

I will also point out many common mistakes that people coming from other languages may commit.

## "C/C++"

You may very often encounter this phrase. It has as much meaning as "Java/JavaScript" (and btw this pair does share some history too) or "Ham/Hamster".

C++ is much different from C not only by the amount of language features but also by conventions. A good C code may often be terrible C++ code. Having over 35 years of backwards compatibility does not mean we should write C-ish C++ today.

C++ is not "C with classes". C++ is not just object-oriented language. It is a multi-paradigm language that allows multiple styles of programming to be mixed, including but not limited to OOP. In fact, vast majority of C++ standard library does not rely on runtime polymorphism but generic programming. You would need to dig quite deep to even find a virtual function. A large part of standard library are free (not belonging to any class) function templates.

## low level access

C++ gives access to low-level stuff which manifests as:

- ability to directly call underlying system interface
- ability to run in kernel space (compared to user space) (in other words being excluded from memory protection)
- ability to be the system itself (freestanding executable, running "on bare metal")
- ability to use pointers and perform pointer arithmetics
- ability to perform manual resource management
- ability to explicitly violate type system
- ability to write inline assembly code that co-operates with high-level code

Which can have following consequences:

- high performance
- **undefined behaviour**

Despite being able to do all of this, it does not mean it should be done. Actually, C++ strives to provide type-safe high-level zero-overhead abstractions and discourages low-level code that is not necessary. During this tutorial, you will learn what abstractions C++ has put on C and how to use them correctly.

## ~~memory~~  resource management

C++ discourages manual resource management which is done in C on a daily basis. C++ does not rely on garbage collection either - instead it relies on RAII idiom which so far only 2 languages support (C++ and Rust).

RAII is a completely different concept: it is a **deterministic resource management mechanism that is enforced at compile time**. RAII has different variations, some are completely overhead free, some have but still less than garbage collectors. RAII in C++ relies heavy on **destructors**.

The tutorial will focus strongly on RAII as it is one of fundamental language pillars. There will be also lots of examples of bad code that is very easy to find on the internet - mostly C code that had minimal edits just to compile as C++.

## inheritance and polymorphism

C++ offers typical dynamic dispatch mechanism (more known as the use of virtual functions or simply polymorphism). Apart from virtual destructors, there is no difference and same OOP principles apply.

What C++ does differently are inheritance rules:

- There are no *interfaces*. A class in C++ can be said to be an interface if it consists only of body-less virtual functions.
- There are no restrictions on inheritance itself:
  - You can inherit multiple times from the same class
  - You can have multiple parent classes that have member variables
  - Parent classes may share a parent (inheritance graph does not have to be a tree)
  - A class can be abstract despite all of its parents not being abstract
  - Class templates can perform recursive inheritance and recursive class definitions
