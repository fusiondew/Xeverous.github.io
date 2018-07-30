---
layout: article
---

At the level of machine instructions, processor views everything as bits. The same bits can mean different things depending how they are interpreted:

- as a number (the binary numerical system, each bits is a higher power of 2)
- as a character (each character has associated numeric value)
- as a color (specific bit patterns describe brightness of pixels)
- and much more...

C++ is a language which uses **strong typing**. This means that whenever there is a variable, constant, object etc it is always known how many bits that thing occupies and how it should be interpreted.

You will soon see in the code that every variable/constant name is first introduced with type name which describes how it will be used.

Not all programming languages use strong typing - these that do not (typically named to have **lose** or **dynamic typing**) do not require explicit writing of types - they perform hidden conversions between operations and generally hide some computations. The languages are typically run on virtual machines or by interpreters - they rarely are transformed into real machine code.

C++ is a language which does not do anything unless explicitly asked to. You have the full control what happens, when and how. This gives more power but also more responsibility - if you explicitly write some non-functional code, it will be accepted and the program will crash.

**Advantages of strong typing**

- no accidental mistakes - generally variables of different types are incompatible - `a = b` will not compile if types of both are different
- no unnecessary operations - types can be converted but you decide when
- no unnecesssary wasted memory - each data is stored on fixed amount of bits - with dynamic typing variables are often stored multiple times as different types
- clear code - you know what you work with
- better optimization - compilers can better utilize machine instructions knowing how memory is used

The first point might seem trivial but it can be a source of bugs in the software. By having multiple different types we give each variable specific purpose and prevent mistakes from wrong interpretation. This is known as **type safety**.

TODO important block

**The type system in C++ is considered as one of the most important aspects of the language.**