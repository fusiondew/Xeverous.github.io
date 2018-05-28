---
layout: article
---

Every C++ program, according to the standard falls into one of these terms:

## well-defined behaviour

Everything goes as intended and the program works correctly. **Obviously this is what you always want to achieve.**

## ill-formed

The code is invalid. Compiler is required to emit errors. Some compilers may accept the code, if it's valid in terms of non-standard extensions but still have to emit a warning about it.

## ill-formed no diagnostic required

The code is invalid, but unfortunately it can not be detected by the compiler.

This is caused by problems which appear between program parts, where each part itself is valid but they can not cooperate. Most such ill-formed programs result in errors at the linking or later stages of the build.

Example problems

- 2+ definitions of the same entity across multiple source files. When the linker tries to merge object files into one program, it finds multiple definitions of the same thing (It's an error even if they are exactly the same).
- No definition for something that was claimed to be supplied externally. When the linker tries to merge object files into one program, it finds that something is missing. Commonly informed as "undefined reference to..."
- All code is valid but global variables usage does not adhere to language requirements about order of initialization (aka static initalization order fiasco). Results in uninitialized data, lost data or crashes at the program startup

## implementation-defined behaviour

Behaviour varies between implementations (mostly between used compilers) and the conforming implementation must document it.

This is mostly stuff which C++ standard itself can not standarize and usually is a result of the hardware specifics. Code is an abstraction, and obviously it may have subtle differences depending on which hardware it's being run.

Example: the size of integer in bytes, the amount of bits on the hardware byte, the message text of runtime memory allocation exception.

## unspecified behaviour

Behaviour varies between implementations (mostly between used compilers) but the conforming implementation is not required to document it.

This is mostly stuff where there is no "the only right one answer". There are multiple valid solutions, you just don't know which one is used by the given implementation (likely the most optimal one for the given program). 

Example:

- Order of evaluation - language doesn't specify this so you should not rely upon any solution that is dependent on it. If you want X to happen after Y, just do X in the next statement (do not combine X and Y in one instruction).
- An operation requires a buffer that needs *some* spare memory to be allocated. How much it is depends on the implementation.
- How string literals are stored in the program

## undefined behaviour

The code is valid but does something that has absolutely no guarantees. The entire program is rendered useless and **anything is allowed to happen**.

Example causes:

- reads of uninitialized memory
- reads/writes from/to memory which does not belong to the program
- data races between threads

Example results:

- instant, unpredictable random crashes
- crashes under certain scenarios
- program freezes
- the program works correctly
- the program works but does not behave as expected
- the program *seems to work correctly*

TODO summary? more layman writing?
