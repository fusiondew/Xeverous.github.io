---
layout: article
---

## Dangling pointer

TODO def block

<div class="note success">

A dangling pointer is a pointer that holds memory address which is no longer valid.

Dereferencing such pointer is **undefined behaviour**.
</div>

### example

```c++
int main()
{
    int* ptr;

    {
        int x;
        ptr = &x;
    } // x dies here

    // ptr holds memory address which is no longer valid
    // should not read/write there
    *ptr = 10; // crash!
}
```

The program above invokes undefined behaviour. It is because `x` lifetime ended and whatever memory it occupied can now be owned by the system or given to another program. You can't read/write to memory which is not yours, hence the crash.

<div class="note warning">

The above program may work for you. It's possible because UNDEFINED BEHAVIOUR MEANS EVERYTHING CAN HAPPEN, including "seems to work". Do not rely on this, it's just a random accident where you got lucky.
</div>

### uninitialized pointer

```c++
int main()
{
    int* ptr;
    *ptr = 10; // where do we actually write 10?
}
```

Just like with uninitialized variables, it is unknown what pointers start with. It's usually the memory content which was left after previous program.

If we do not know what address `ptr` holds, we should not write there. At best, we get instant crash (because memory is not ours), at worst operation will succeed (pointer randomly holds address that's a part of our program) and we overwrite own memory creating very random, tough to find bug.

### initialization

With integers (and all other data types) it's heavily recommended to initialize them. What's the default is of course situation dependent - for example `0` if we represent sum, `1` if we want to multiply or some fixed positive/negative number (base character health or speed in a game).

## null pointer

There is a similar concept for pointers - a special value, which says "this pointer does not currently hold any valid address". Such pointer is a **null pointer**.

You may ask - but what's the value of null pointer? Some fixed `0xhexnumber`? It is actually system-specific, but so far for any hardware I have seen it was `0x00000000` which makes a lot of sense.

Since 2011 update of C++ it has a keyword for it - `nullptr`. It represents this system-specific value.

```c++
int* ptr = nullptr;
```

`nullptr` is defined as universal representation of unknown address of it's own type (notably `std:nullptr_t`) which is implicitly convertible to any other pointer type. Analogy: `bool` is a type capable of holding only 2 values: `true` and `false`. `std::nullptr_t` is a type capable of holding only 1 value: `nullptr`. Booleans are implicitly convertible to integers. Null pointer type is implicitly convertible to any other pointer type.

<div class="note warning">

In a lot of C or old C++ code, you will see `NULL`. It's a macro that is used in C to represent null pointers.

This macro (because it's macro) causes a lot of problems due to it's text replacement. In C, it is defined as `((void*)0)` which would not form valid C++ code. For backwards compability, `NULL` in C++ either is just `0` or something `__compiler_specific`.

`0` has a special rule that it can be used as a null pointer (not an integer). This rule is only for character `0`, no other numberic expressions can be assigned to pointers. It is a remnant of old times and kept for backwards compatibility.

The consequences of using `NULL` in C++ can be quite harsh. Mostly because of it being treated like integer, not pointer (broken type safety). Example bugs are different function calls than intended, different program behaviour on different compiler or weird compiler errors related to templates.
</div>

<div class="note pro-tip">

DO NOT EVER USE `NULL` MACRO OR `0`. Use the keyword `nullptr`.
</div>

## null pointer print

```c++
#include <iostream>

int main()
{
    // this actually does't compile because nullptr is not assigned to any type
    // and standard stream does not know how to print value of type std::nullptr_t
    // std::cout << nullptr;

    // so just use any specific pointers
    int* p1 = nullptr;
    double* p2 = nullptr;
    std::cout << "null pointer to int: " << p1 << "\n";
    std::cout << "null pointer to double: " << p2 << "\n";
}
```

```
null pointer to int: 0
null pointer to double: 0
```

Not really surprising. The number `0` is still in hex btw, `0` is just written the same way in both decimal and hexadecimal systems.

<div class="note info">
<h4>null pointer dereference</h4>

Dereferencing null pointer is the same as dereferencing uninitialized pointer or a dangling pointer - undefined behaviour - all of these hold invalid addresses. They just differ by how they crash your program (on most systems null pointers crash instantly, others may result in very weird memory corruption bugs).
</div>

## null pointer checks

Sometimes you may not know if the pointer you got (eg from a function) is valid. The advantage of null pointers is that we can just test it.

```c++
ptr = func();

if (ptr != nullptr)
{
    // we can do *ptr
}
```

<div class="note pro-tip">
Always make a pointer either a null pointer (indicating it does not hold any valid address) or a valid pointer. There is no way to test uninitialized pointers or dangling pointers - you should set them to null so other code doesn't accidentally dereference them.
</div>


## summary

Here is what you should remember:

- **uninitialized pointer** - holds unknown value
- **dangling pointer** - holds an address which no longer belongs to the program
- **null pointer** - holds system-specific address that is used to represent "no valid address here"
- dereferencing all of the above is undefined behaviour
- you can test if a pointer is a null pointer

## test yourself

What's the difference between `p1` and `p2`?

```c++
int x = 0;
int* p1 = &x;
int* p2 = nullptr;
```

<details>
<summary>answer</summary>
<p markdown="block">

`p1` holds a valid address of an integer which holds 0. `p2` holds invalid address.

In other words, `p1` points to a valid object which has a certain value, `p2` does not point to any object. Don't be fooled by the zero - it's a valid integer. Similarly, there is a big difference in no mark (null) and a failed test (score 0).

![0 vs null](http://i.imgur.com/7QMhUom.jpg)

</p>
</details>
