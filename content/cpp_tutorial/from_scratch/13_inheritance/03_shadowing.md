---
layout: article
---

## shadowing fields

Inheritance has shadowing rules, similar to the rules describing shadowing in nested scopes.

```c++
struct base
{
    int x;
};

struct derived : base
{
    int x; // new variable, it just has the same name

    void print() const;
};

void derived::print() const
{
    // how to print both 'x'?
}
```

If 2 names are the same - as with nested scopes the one that is the deepest shadows other. This means that in the function above `x` would refer to `derived`'s member.

You can still use both, just need to explicitly prepend base class name for it's `x`:

```c++
#include <iostream>

struct base
{
    int x = 1;
};

struct derived : base
{
    int x = 2; // new variable, it just has the same name

    void print() const;
};

void derived::print() const
{
    std::cout << "my x: " << x << "\n";
    std::cout << "base class x: " << base::x << "\n"; // base:: to access parent member
}

int main()
{
    derived d;
    d.print();
}
```

But honestly:

<div class="note pro-tip">
Don't use the same name for member variables in derived types.
</div>

There is really no point in it, it only complicates code. Some compilers may emit a warning.

## shadowing functions

The same happens for member functions - adding a function with the same name in derived class hides the one from base.

```c++
#include <iostream>

struct base
{
    void func(int x)
    {
        std::cout << "integer: " << x << "\n";
    }
};

struct derived : base
{
    // using base::func;

    void func(double x)
    {
        std::cout << "double: " << x << "\n";
    }
};

int main()
{
    derived d;
    d.func(5);
}
```

Run this example 2 times: with and without commented line.

**Commented**

Derived overload is called even though the one from base would be a better match (argument `5` is integer). Because names from derived types shadow names from parent types compiler stops searching possible overloads once it finds something valid in derived type.

**Uncommented**

Base class overload is called. The using explicitly tells the compiler that it also wants to use base class function overlods.

Note how using is written - there is no `()`. It doesn't call the function, only re-introduces it's name to the same scope.

<div class="note pro-tip">
When adding overloads to base type methods in derived types, don't forget to put a using in derived type (for each additionally overloaded method).

Do not write code that relies on shadowing - if you do not want base overloads to be considered, choose a different name for method in derived type.
</div>

Rules above apply per method, not per class. If you add overloads to multiple different methods, you need to place `using base_type::method_1`, `using base_type::method_2`, etc for each method that gets additional overloads.

## method shadowing - longer hierarchy

Rules apply recursively. This time we have 3 functions and each of child types should re-introduce it's parent names to it's own scope.

```c++
#include <iostream>

struct base
{
    void func(int x) // overload 1
    {
        std::cout << "integer: " << x << "\n";
    }
};

struct derived : base
{
    using base::func; // adds overload 1
    
    void func(double x) // overload 2
    {
        std::cout << "double: " << x << "\n";
    }
};

struct more_derived : derived
{
    using derived::func; // adds overloads 1 and 2
    
    void func(long double x) // overload 3
    {
        std::cout << "long double: " << x << "\n";
    }
};

int main()
{
    more_derived md;
    md.func(5);
}
```
