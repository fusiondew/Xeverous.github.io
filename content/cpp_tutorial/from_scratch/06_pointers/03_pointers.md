---
layout: article
---

<div class="note success">
This lesson is very important. **Understanding pointers is crucial in understanding tons of other language features**. Focus on the topic and do not leave a spot for any doubt.

Pointers are commonly listed as one of the most complicated C (and C++) language features. There are many explanations on the internet available. If something in this lesson is unclear - find a different article on the internet but also don't forget to message me and inform what needs more examples/better explanation.
</div>

## theory

Every variable you use in a program, has to be placed in the memory. Memory, like houses and roads is divided into smaller pieces (cells), each having a unique address. Pointers are essentially for this: **they do not represent variables, but the addresses of variables**.

TODO def block

<div class="note success">
A pointer is a variable which holds the memory address of another variable.
</div>

## the address-of operator

... is written as `&`. It is an unary operator (takes only 1 argument). So for a variable named `x` it's address is `&x`. Read the expression `&x` as "address of x".

```c++
#include <iostream>

int main()
{
    int x = 10;
    std::cout << "value of x: " << x << "\n";
    std::cout << "address of x: " << &x << "\n";
}
```

Example output:

```
value of x: 10
address of x: 0x7ffc1d12da4c
```

The address can be different each time you run the program -  `x` can be placed in different memory location each time (sometimes the same if you are lucky).

The format of the output is a hexadecimal number representing index of the first memory cell occupied by `x` (`x` may span multiple cells - you already know integers occupy 4 bytes on most systems). By the convention, hexadecimal numbers are prepended with `0x` to not mistake them with integers or something that could look like a password. Don't worry if you don't understand what `0x7ffc1d12da4c` means - it's just a number, but written in a different system.

#### Question: why does the number contain letters?

Technically, they are not letters.

- decimal system uses 10 digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
- binary system uses 2 digits: 0, 1
- hexadecimal system uses 16 digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, a, b, c, d, e, f

First letters of the alphabet were choosen to represent missing 6 digits. You might see uppercase A-F too.

You don't need to understand how to read hexadecimal numbers - they may be used in the code but since memory is different every time no one can use them in any meaningful way besides having a way to write binary numbers in less characters (there is an easy way to convert binary and hexadecimal numbers between each other).

## addresses of multiple elements

If you have a code like this:

```c++
int x;
int y;
```

If you print `&x` and `&y` - they can be very different. Due to compiler optimizations they can be placed in a quite distant places even if you define them one after another.

However, if you have an array - all elements are in the same memory block (this is required by the language).

```c++
#include <iostream>

int main()
{
    int arr[3] = { 1, 2, 3 };
    for (int i = 0; i < 3; ++i)
        std::cout << &arr[i] << "\n";
}
```

prints

```
0x7ffd8ddc0534
0x7ffd8ddc0538
0x7ffd8ddc053c
```

Do you see that addresses are very similar? Elements of the array are placed one after another in the memory. Also, the address value grows by 4 (`0x...4` + `4` = `0x...8` and `0x...8` + `4` = `0x...c`) - this means that `int`s occupy 4 bytes on the system on which the code was run.

Visualization:

```
                                v 0x7ffd8ddc053b                v 0x7ffd8ddc0543
                            v 0x7ffd8ddc053a                v 0x7ffd8ddc0542
                        v 0x7ffd8ddc0539                v 0x7ffd8ddc0541
                    v 0x7ffd8ddc0538                v 0x7ffd8ddc0540
--+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+--
  |     arr[0]    |     arr[1]    |     arr[2]    |   |   |   |   |   |   |    
--+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+--
    ^ 0x7ffd8ddc0534                ^ 0x7ffd8ddc053c
        ^ 0x7ffd8ddc0535                ^ 0x7ffd8ddc053d
            ^ 0x7ffd8ddc0536                ^ 0x7ffd8ddc053e
                ^ 0x7ffd8ddc0537                ^ 0x7ffd8ddc053f
```

## the dereference operator

... is written as `*`. Like address-of operator, it is unary.

It is the opposite of address-of operator. It reads the value stored in the given address.

<div class="note info">
#### same symbol for different operators

Unary `*` is the dereference operator: `*x`.

Binary `*` is the multiplication operator: `x * y`.

Do not mistake them - they are written using the same character but they are doing completely different things.
</div>

```c++
#include <iostream>

int main()
{
    int x = 10;
    std::cout << "value of x: " << x << "\n";
    std::cout << "address of x: " << &x << "\n";
    std::cout << "value under the address of x: " << *&x << "\n";
}
```

```
value of x: 10
address of x: 0x7ffd0b14246c
value under the address of x: 10
```

In the example above `&x` was used to get the address of `x` and later, a value was read from this address by `*`. This essentially brought `x` back.

What if we could store that address somewhere?

## pointers - syntax

```c++
int x = 10;  // variable "x" of type int (integer) set to the value 10
int* p = &x; // variable "p" of type int* (pointer to integer) set to the address of x
```

### C heritage

The example presented above showcases modern C++ recommended syntax. In C, you will almost always see the asterisk sticked to the pointer name:

```c++
// very common in C
int *p;
// recommended for C++
int* p;
```

It is because of this "feature" (which exists since the beginning of C):

```c
int *p1, p2; // p2 is an integer, not integer pointer!
int* p1, p2; // the same problem as above
```

To correctly define 2 pointers, the asterisk must be prepended to both names:

```c
int *p1, *p2; // 2 pointers
int* p1, *p2; // 2 pointers, but a bit weird writing
```

This "feature", by many (including me) is considered as one of the worst decisions during the forming of C language syntax. It creates an opportunity for misleading variable definitions and - just like with array size - decouples the type information splitting part of it (`int`) before the name and part of it (`*` or `[]`) after the name.

Programming languages which appeared later, use the `int[] arr` and `int* p` form. The asterisk-left-side form is also used on [C++ Core Guidelines](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) which are written by core C++ creators.

There is a long going battle (mostly C programmers + old C++ programmers vs modern C++ programmers) how pointers should be written. It's recommended to stick `*` to the type, as that is the intuitive - `p` is named `p`, not `*p`. This also solved the problem of newcomers questioning the dereference operator - the asterisk used in `int* p` is the syntax to declare a pointer - it is not "operator* applied to p".

The "feature" of splitted type names can be abused heavily:

```c
int x, *p, func(), arr[10]; // define (in order): an integer, integer pointer, function returning integer, array of 10 integers
```

For modern C++ is adviced to abandon this feature completely and use easier to read syntax:

```c++
int x;
int* p;
int func();
int arr[10];
```

And so it is used across the entire website. All asterisks that are part of the type definitions are on the left.

**Note:** the problem above applies to other type modifiers too. This includes `&`, `&&` and `...` operators. Just don't define multiple variables in the same statement.
