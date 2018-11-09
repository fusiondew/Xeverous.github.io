---
layout: article
---

<div class="note warning">

`static` keyword has different meanings depending on the context.

- global static object
- static object inside function
- static struct / function
- static member function (C++ only) (related to classes)
- static member variable (C++ only) (related to classes)
</div>

This lesson will explain first two.

## storage duration

C++ specifies 4 types of object lifetime.

- **automatic storage duration** - basically everything you have used so far. Objects are limited by enclosing braces and die when they go out of scope. This is the default storage duration for everything unless declared with specific keywords.
- **static storage duration** - object is created when the program starts and destroyd when the program ends. This applies to:
    - global objects
    - objects declared with `static`
    - objects declared with `extern`
- **thread storage duration** - similarly to static, but with the difference that object is created when thread launches and destroyed when thread ends. Each thread will have own object. This applies to:
    - objects declared with `thread_local`
- **dynamic storage duration** - object is allocated (created) and deallocated (destroyed) per request in code. The core topic of this chapter.

<div class="note info">

`thread_local` overrides `static`/`extern` when both are used in one declaration.
</div>

## linkage

TODO def block

**Linkage** allows to refer to objects from other scopes and possibly from other **translation units**.

**Translation unit** - code which gets feed to the compiler. Essentially the code after being preprocessed (all includes and macros expanded) and tokenized: removed comments, concatenated string literals, character escapes etc.

There are 3 types of linkage:

- **no linkage** - name can be referred only from the scope it is declared. Applies to:
    - all variables declared without `extern`
    - everything else declared locally (inside a function)
- **internal linkage** - name can be referred from all scopes in **current translation unit**. Applies to:
    - variables and functions declared `static`
    - members of anonymous *unions*
    - members of anonymous namespaces
- **external linkage** - name can be referred from all scopes in **different translation units**. Applies to:
    - variables declared `extern`
    - basically everything else which is not `static`.

## the core point

- Linkage defines when object can be accessed (no "unknown identifier" errors).
- Storage duration defines when object is created/destroyed.

**Linkage and storage duration are independent.**

Now, what are the consequences of this?
- some objects may live but be inaccessible
- some objects may be accessible but do not live

In the case of **automatic storage duration** linkage and storage have the same bounds. You can only refer to the object from it's scope and as soon as object dies it's no longer accessible. Lifetime has the same range as visibility.

```c++
{
    int x = /* ... */; // typical object with automatic storage duration
} // x dies, and is no longer visible
```

In the case of other storage durations objects may live but be inaccessible. Global objects live entire program but `extern` has to be added to allow them to be visible from other files.

One such object has been already used - `std::cout`. It's a global object with **external linkage**. Given a C++ project which consists of multiple source files, `std::cout` will exist when at least 1 file includes `<iostream>`. Object will then exist in the entire program, but only files which include the I/O stream header will have it accessible.

## static objects

Applying `static` to a global object doesn't change much except assembly code at program startup and in which memory segment that object is placed. The only big difference is zero-initialization.

```c++
// globals, these will have unknown values
int x1;
int ptr1;

// globals which will be zero-initialized
static int x2; // this will be 0
static int* ptr2; // this will be a null pointer

// printing first two is undefined behaviour, printing second two will yield 0s
```

The thing gets interesting when used for local variables. **`static` objects live the entire program.**

```c++
#include <iostream>

void increase()
{
    static int x = 0;
    std::cout << "x is now " << ++x << "\n";
}

int main()
{
    for (int i = 0; i < 5; ++i)
        increase();
}
```

~~~
x is now 1
x is now 2
x is now 3
x is now 4
x is now 5
~~~

In the code above:
- `x` has static storage duration - it lives the entire program
- `x` has no linkage - it's only accessible inside the function

Essentially it's a globally living variable that can be accessed only from it's scope.

Remove `static` from example above and the function will print that `x` is always `1`.

## summary

- Linkage defines when object can be accessed (when it's visible). Modified by:
    - (default) - no linkage (only local scope)
    - `static` - internal linkage (only current translation unit)
    - `extern` - external linkage (all translation units)
- Storage duration defines object lifetime. Modified by:
    - (default) - automatic (just enclosing scope)
    - `thread_local` - whole thread
    - `static` - whole program
    - *allocation/deallocation functions* - you decide

**Linkage and storage duration are independent.** Consequences:
- some objects may live but be inaccessible (example program above)
- some objects may be accessible but do not live (dangling pointers)


Linkage has only sense for things that live long enough - whole thread or entire program. Automatic objects live very short and dynamically allocated objects are not possible to be linked.

You do not need to remember all of linkage and storage keywords. The point of this lesson is to make you just aware that these 2 are separate and do not always have exactly the same span - you might already see this with dangling references/pointers.
