---
layout: article
---

Programs manipulate and create variables (objects). In most simple scenario these are numbers, but more generic abstractions are also possible (for example classes - user-defined types).

Objects can be stored in various places:

- processor registers
- processor stack
- processor cache (L1, L2, L3)
- main random access memory (RAM)

You don't have to worry about where to put things - compilers are generally much better at deciding which place will be the best for the given data. Only the type of the data is required to be specified - it defines how much memory is needed and how it will be used.

There is a distinction between statically allocated memory and dynamically allocated memory - the second one allows runtime allocations but requires communication with the operating system. For now, all programs will purely use statically allocated memory which do not require any additional instructions - everything is done automatically.

#### Question: Does it means the programs will not use any RAM?

Obviously the operating system will need to use some RAM to run the program and the standard library may ask for some too. But the code you will write will not do it.

## definition and assignment vs initialization

Before a variable can be used, it must be *defined*. The definition is fairly simple: `type identifier;` (identifier is the name of the variable).

```c++
int x; // define variable named "x" which is of type int
```

After the variable is *defined*, you can use its name to refer to its memory and perform operations:

```c++
x = 5; // assign value 5 to the variable identified by "x"
```

Obviously it is possible to define and give initial value at the same statement:

```c++
int x = 5;
```

which forms an **initialization**. **Initialization is a definition + inital value at the same statement.**

For now, it doesn't matter whether you do both in 1 initialization statement or split them to definition + assignment, but it will make a difference in the future. Assignment always uses `=` operator, but initialization may use (and often requires) a different syntax.

Other possible initializations:

```c++
int x(5);
int x{5};
```

Of course stay with `=` since it's much more intuitive for numbers. Different syntax will be used only when it has an impactful difference. Other initializations will be explained later.

<div class="note info">

**Initialization** can only happen at the moment of **definition**. If it's not done in the first statement, it's an **assignment**.
</div>

```c++
int a = 1; // initialization (value given at first statement)

int b;
b = 2; // assignment (value given after first statement)
```

## uninitialized variables

C and C++ does not require to set any initial value (unless we use some advanced features). If you do not set anything, the value stored in variable's memory will be unknown - typically some garbage bits which were left after previous program that used the same memory location.

```c++
int x;
std::cout << "x = " << x;
```

It is unknown what the program above will print. It might be 0 but also some huge number - it happens when we reuse other program's memory which had different purpose. Each program execution may print different value of `x`. There might be or not some pattern in the outputs of the program - depends on how your system manages memory.

<div class="note pro-tip">
Always initialize variables. Prefer direct initialization over definition + assignment.
</div>

A good compiler should give a warning when an uninitialized variable is used:

```c++
main.cpp: In function 'int main()':
main.cpp:6:18: warning: 'x' is used uninitialized in this function [-Wuninitialized]
     std::cout << x;
                  ^
```

## scope and lifetime

Each automatically-allocated variable has well-defined lifetime. There is a certain time period on which it's life spans. Prior to this, the variable does not exist and after this, it has been destroyed (it's memory has been reused for different purpose or given back to the operating system) and is no longer accessible.


The place at which variable lives is the **scope** of the variable.

```c++
// error: there is no "x"
x = 4;

{
    // error: there is no "x"
    x = 3;

    // define x as an integer, initialize it to 10
    int x = 10;

    {
        int y = 100; // define and initialize y
    } // y dies at this line

    // x is still accessible
    x = 5;
} // x dies at this line

// error: there is no "x"
x = 6;
```

The scope (lifetime) of a variable is simply the span of its scope in which it's defined. In other words, variables lifetime is limited by most enclosing `{}` block.

___

Example program - any of the commented lines produce an error because they try to use `x` before or after it's lifetime.

```c++
#include <iostream>
 
int main()
{
    // x = 5;
    {
        // x = 7;

        int x = 10;

        {
            int y = 20;
        }
        // y = 10;

        x = 6;

        std::cout << "x = " << x;
    }

    // std::cout << "x = " << x;
    return 0;
}
```

## overwriting

It's possible to reuse the value of the given variable to set its new value

```c++
int x = 5;
x = x * 2; // assign to x value equal to 2 times current value of x
std::cout << x; // prints "10", no doubt
```

This is normal and works as expected. Language defines that assignments are made from right to left so the right side expression is evaluated first before it's saved in `x`.

Obviously it has no sense when variable is defined:

```c++
int x = 2 * x; // nonsense
```

## exercise

Check errors generated by your compiler by uncommenting invalid lines in the example. It will help you in case you later encounter similar problems.

Experiment with variable definitions, initialization and printing them.
