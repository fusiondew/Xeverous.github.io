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

#### Question: Why does the number contain letters?

Technically, they are not letters.

- decimal system uses 10 digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
- binary system uses 2 digits: 0, 1
- hexadecimal system uses 16 digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, a, b, c, d, e, f

First letters of the alphabet were choosen to represent missing 6 digits. You might see uppercase A-F too. By convention, hex numbers are prepended with `0x` or `#` to not mistake them with other data (C++ streams use `0x`).

You don't need to understand how manipulate hexadecimal numbers - they will be printed mostly to check if they are the same.

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
    int arr[3] = { };
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

Append `*` to the type to indicate that it's the address.

```c++
int x = 10;  // variable "x" of type int (integer) set to the value 10
int* p = &x; // variable "p" of type int* (pointer to integer) set to the address of x
```

### C heritage

The example presented above showcases modern C++ syntax. In C, you will mostly see the asterisk sticked to the pointer name:

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
int* p1, *p2; // 2 pointers, but a bit inconsistent writing
```

This "feature", by many (including me) is considered as one of the worst design decisions during the forming of C language syntax. It creates an opportunity for misleading variable definitions and - just like with array size - decouples the type information by splitting part of it (`int`) before the name and part of it (`*` or `[]`) after the name.

The "feature" of splitted type tokens can be abused heavily:

```c
int x, *p, *func()[3], arr[10]; // define (in order): an integer, integer pointer, function returning pointer to array of 3 integers, array of 10 integers

//^        ^       ^ these are 3 parts of one type
```

This is not really a feature but a consequence of complicated parsing rules. Modern C++ puts strong effort to form expressive, easy to read intuitive syntax - splitting parts of the type out of order hurts readability and creates a place for mistakes.

It is recommended to avoid this feature completely and use easier to read statements which do one thing per line:

```c++
int x;
int* p;
int arr[10];

using array = int[3];
array* func(); // clear - we get a pointer to int[3]
```

There is a long going battle (mostly C programmers vs modern C++ programmers) how pointers should be written. It's recommended to stick `*` to the type, as that is the intuitive - `p` is named `p`, not `*p`. This also solves the problem of newcomers questioning the dereference operator - the asterisk used in `int* p` is the syntax to declare a pointer - it is not "operator* applied to p".

Programming languages which appeared later, use the `int[] arr` and `int* p` form. The left asterisk form is also used on [C++ Core Guidelines](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) (see [rule NL.18](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#nl18-use-c-style-declarator-layout)) which are written by core C++ creators.

And so it is used across the entire website. All asterisks that are part of the type definitions are on the left.

**Note:** the problem above is not only about `*`, it applies to other type modifiers too. This includes `&`, `&&`, `const`, `volatile` and `...`.

<div class="note pro-tip">
#### asterisk alignment

Stick asterisks and other type modifiers to the type name.

```c++
// bad, misleading
int &p; // p is of type "reference to int" which should be int&
int *f1(); // function is not named "*f1" but "f1", and it returns int*, not int
int f2()[3]; // int and [3] should be together - this is one type!

// good - all type modifiers are sticked together
int& p;    // clear: p is an integer reference
int* f1(); // clear: function returns integer pointer
auto f2() -> int[3]; // int[3] together (using C++11 new trailing syntax)
```
</div>

## example with pointers

```c++
#include <iostream>
 
int main()
{
    int x = 10;
    int* ptr = &x; // initialize ptr with the address of x
 
    std::cout << &x << "\n"; // print the address of x
    std::cout << ptr << "\n"; // print the contents of the pointer

    std::cout << x << "\n"; // print the value of x
    std::cout << *ptr << "\n"; // print the value which is localed at memory address stored in the pointer
}
```

```
0x7ffd4e6c179c
0x7ffd4e6c179c
10
10
```

Thit should not be surprising - the contents of the pointer are equal to the address of the variable.

```
                    the variable x
--+---+---+---+---+---+---+---+---+---+---+---+---+---+--
  |   |   |   |   |      10       |   |   |   |   |   |
--+---+---+---+---+---+---+---+---+---+---+---+---+---+--
^ 0x7ffd4e6c1797    ^ 0x7ffd4e6c179c    ^ 0x7ffd4e6c17a1

                     pointer to x
--+---+---+---+---+---+---+---+---+---+---+---+---+---+--
  |   |   |   |   | 0x7ffd4e6c179c|   |   |   |   |   |
--+---+---+---+---+---+---+---+---+---+---+---+---+---+--
```

The variable `x` is of type `int` and holds `10` (a numeric value).

The variable `ptr` is of type `int*` and holds `0x7ffd4e6c179c` (an address)

## pointer types

All pointers (at the hardware level) are the same. On 32-bit systems they occupy 4 bytes (32 bits) and on 64 bit systems they occupy 8 bytes (64 bits).

Still, at the language level they differ by the type they point to. All `int*`, `double*`, `long*` etc are the same in the machine instructions but they are differentiated at the language level for type safety purposes. If it was not the case, if we had a pointer we would not know to interpret that data (and how many memory cells that data spans).

## RAM limit

You may have heard that 32-bit computers can not have more than 4 GB of RAM. This is because 32-bit pointer can only represent $2^{32}$ different addresses, which is $4294967296$ bytes which is $4194304$ kilobytes which is $4096$ megabytes which is $4$ gigabytes.

Disks can be larger because they have [CHS](https://en.wikipedia.org/wiki/Cylinder-head-sector) (actually had, current disks are even more complicated) system which uses multiple integers to represent memory cells.

The same problem happenned for pendrives though. This is not due to how USB port works, but due to how systems handled it - they usually mapped the entire drive to the memory, having the same problem as with RAM. You can not stick a pendrive with more than 4GB memory to old (32-bit) Windows XP.

There were some possible workarounds for 32-bit systems, similar to using multiple integers but all of them had costs (lower performance, possibly required specific BIOS, required processor supporting PAE).

The limit for 64-bit computers is far larger, namely $2^{64}$ which is ${2^{32}}^2$ which is $4294967296^2$ bytes which is $18446744073709551616$ bytes which is $16$ exabytes. So far enough.

Fun fact: current computers have actually 48-bit address bus. No one currently needs more than 256 terabytes on one computer so hardware manufacturers just save money on transistors which would always only store 0s; [more info](https://stackoverflow.com/questions/6716946/why-do-64-bit-systems-have-only-a-48-bit-address-space).

## pointer usage - example 1

A pointer can be used to modify other variables by their address:

```c++
#include <iostream>

int main()
{
    int x = 10;
    int* ptr = &x;

    std::cout << "x = " << x << "\n";
    *ptr = 250; // access memory address stored in ptr and write there 250
    std::cout << "x = " << x << "\n";
    *ptr = 2 * *ptr; // multiply *ptr by 2
    std::cout << "x = " << x << "\n";
}
```

```
x = 10
x = 250
x = 500
```

Understand what happens at `2 * *ptr` - the first asterisk is multiplication, the second asterisk is a dereference.

## pointer usage - example 2

2 variables are modified through one pointer

```c++
#include <iostream>

int main()
{
    int x = 10;
    int y = -10;

    std::cout << "x = " << x << "\n";
    std::cout << "y = " << x << "\n";
    std::cout << "\n";

    int* ptr = &x;
    *ptr = *ptr * 10;

    std::cout << "x = " << x << "\n";
    std::cout << "y = " << x << "\n";
    std::cout << "\n";

    ptr = &y;
    *ptr = *ptr * 10;

    std::cout << "x = " << x << "\n";
    std::cout << "y = " << x << "\n";
    std::cout << "\n";
}
```

Can you deduce the output before you run the program? If so, you understood the lesson well.

TODO fix formatting

<div><details>
<summary>
output
</summary>
<p markdown="block">

~~~
x = 10
y = -10

x = 100
y = -10

x = 100
y = -100
~~~

</p>
</details></div>

## exercise

If you have any doubts about the syntax - read carefully again, write own examples or search the internet for more explanations/examples.

If you have any questions regarding why pointers are needed - move to the next lesson.

## test yourself

Find all the mistakes in this code:

```c++
int x = 100;
int y = 3;
int* ptr = &x;
ptr = &y;
*ptr = 2 * ptr;
*ptr = &y;
```

<details>
<summary>
mistakes
</summary>
<p markdown="block">

~~~ c++
int x = 100;
int y = 3;
int* ptr = &x;
ptr = y; // missing address-of operator - can't set ptr to y, should be &y
*ptr = 2 * ptr; // pointer value is multipled, not the value under it's address - should be 2 * *ptr
*ptr = &y; // can't set the memory pointed by ptr (which is of type int) to the address of y (which is of type int*) - either do ptr = &y OR *ptr = y
~~~

</p>
</details>

Explain the difference between these 2 lines:

```c++
ptr = &y;
*ptr = y;
```

TODO solution
