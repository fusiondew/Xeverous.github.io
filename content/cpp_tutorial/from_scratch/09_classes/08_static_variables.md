---
layout: article
---

## static members

`static` members are not tied to any specific instance. Each object of the same type shares exactly the same variable.

**Do not confuse static class members with variables declared static inside functions. These 2 are very different uses of the keyword `static`.**

TODO static explanation precondition: header/source separation

*I used public access (struct instead of class) to avoid writing too much code for this example.*

```c++
// header (foo.hpp)
struct foo
{
    int x;
    static int s; // declaration of static member

    foo(int x);
};

// source (foo.cpp)
foo::foo(int x)
: x(x)
{
}

int foo::s = 5; // definition + initialization of static member

// main.cpp
#include <iostream>

int main()
{
    foo f1(10);
    std::cout << "f1.x: " << f1.x << "\n";
    std::cout << "f1.s: " << f1.s << "\n";
    foo f2(20);
    std::cout << "f2.x: " << f2.x << "\n";
    std::cout << "f2.s: " << f2.s << "\n";

    // let's change s
    std::cout << "\n";
    ++f1.s;
    std::cout << "f1.s: " << f1.s << "\n";
    std::cout << "f2.s: " << f2.s << "\n";
}
```

~~~
f1.x: 10
f1.s: 5
f2.x: 20
f2.s: 5

f1.s: 6
f2.s: 6
~~~

**The change of `f1.s` also affected `f2.s`.** It's the same variable.

You can even add this:

```c++
    std::cout << &f1.s << "\n";
    std::cout << &f2.s << "\n";
```

which for me resulted in:

~~~
0x6012a0
0x6012a0
~~~

This proves that both `f1.s` and `f2.s` refer to exactly the same address.

Static variables can be thought as global variables with the difference that they are inside class scope.

Static variables do not contribute to memory layout of the object - you can check that `sizeof(foo) == sizeof(int)`, nothing more (only the `x` member is inside `foo` objects). The static variable exists separately (like global variables).

## no instance required

Static variables live independently from objects. You don't even need an object to use them!

```c++
#include <iostream>

struct bar
{
    static int s;
};

int bar::s = 10;

int main()
{
    std::cout << bar::s << "\n"; // no object of type bar, using :: instead of .
}
```

You can edit the first example: replace `f1.s` and `f2.s` with `foo::s`. Everything should work the same.

<div class="note pro-tip">
When using static members, prefer to call them through class name scope (`::`).
</div>

It's allowed to use static members through instances for code compatibility reasons. If you refactor a program by adding `static` to some members (eg because you realize some variable is not needed for every object) you don't have to rewrite all the code from `f.s` to `foo::s`. *You don't have to but you should.*

Obviously it's better to use the designated way to access static variables - using them through instances is misleading.

## static variable initialization

Like with all objects, static objects should be initialized before they are used. The line inside class which declares static object does not define it - it only provides the name. That's why you need to put `int bar::s = ...` in source file.

If you put static variable initialization outside the class (but still in header file) it will likely cause linker problems - headers might be included multiple times (each time by different source file) and therefore result in multiple definition linker errors.

<div class="note pro-tip">
Headers should provide <b>declarations</b>. If you want to <b>define</b> something, make it `inline`.

Exception: classes are defined within headers. It's like they are always inline.
</div>

TODO implicit inline and more - this lesson really requires header/source separation

### since C++11

- If the static member is `const`, you can actually declare, define and initialize it in the class.

```c++
struct bar
{
    static const int x = 11;
};

// nothing outside the class
```

- If the static member is `constexpr` it has to be initialized (this is true for all `constexpr` variables) TODO constexpr when?

```c++
struct bar
{
    static constexpr int x = 11;
};

// nothing outside the class
```

### since C++17

- non-const static members may be declared + defined + initialized inside a class if they are `inline` TODO inline when? header/source separation?

```c++
struct bar
{
    inline static int x = 17;
};

// nothing outside the class
```

#### Question: What if the static member variable is private? Can I initialize it outside the class?

Yes.

## static variables purpose

There are few useful patterns how you can utilize static variables. One of them is providing unique IDs for each object.

```c++
#include <iostream>

class user
{
private:
    const int id;
    // other variables (eg name, password, etc)
    // ...

    inline static int next_id = 0; // (this code snippet uses C++17 initialization)

public:
    user(/* things ... */);
    int get_id() const;

    // other member functions ...
};

user::user(/* things ... */)
: id(++next_id)
{
}

int user::get_id() const
{
    return id;
}

int main()
{
    user u1; // gets id = 1
    user u2; // gets id = 2

    {
        user u3; // gets id = 3
    } // u3 dies but id = 3 will not be reused

    user u4; // gets id = 4
    std::cout << u4.get_id() << "\n";
}
```

## static initialization order fiasco

This is the conventional name for the problem where you have multiple static variables:

```c++
struct foo
{
    static int x;
};

struct bar
{
    static int x;
};
```

and initialization of one depends on another:

```c++
// these 2 lines might be in different files
int foo::x = 100;
int bar::x = foo::x;
```

The problem is that C++ does not guarantee any order of initialization of globally accessible objects. The standard only guarantees that:

- all globally accessible objects from standard library (eg `std::cout`) are initialized first
- all other globally accessible objects are initialized before main function is run
- after the main function returns, reverse process is taking place

There is a simple solution to force certain order of initialization - **static functions**!

## concurrency

Static member variables may be declared `thread_local`. Then, instead of one for the entire program there is one for each thread.

*This is only for informational purposes. The actual concurrency tutorial is a very different thing.*

## other corner cases

Local classes (1) (classes defined inside functions) and unnamed classes (2), including member classes of unnamed classes (3), cannot have static data members.

```c++
void func()
{
    class foo { /* can not have static members */ }; // (1)
}

class // (2)
{
    class bar { /* can not have static members */ }; // (3)

    /* can not have static members */
} object;
```

But really - who defines a class inside a function?

## summary

- Static members are affected by access specifiers (except initialization statement).
- Static members are not associated with any object. They exist even if no objects of the class have been created.
- Static member variables can not be `mutable`.
- Static member variables are initialized before main function is run and destroyed after main function returns.
