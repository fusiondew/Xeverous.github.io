---
layout: article
---

## limitations

`static` functions can not be `virtual`. Since static functions do not use any class objects, they have no `this` and no access to member virtual table pointer.

Function templates can not be `virtual`. This would defeat the purpose of templates, be hard to implement and have confusing rules. Virtual functions as members of class templates are allowed.

Unlike `this`, there is no keyword designated for accessing global virtual table or the member virtual table pointer. This is both unneeded and gives more flexibility for compiler creators.

## rules

In order to bind dynamically a function it must satisfy few requirements

Base class:

- function must be marked `virtual`

Derived class(es):

- (obvious) the same name
- (obvious) the same parameters
- the same or **covariant** return type (covariant retun type - next lessons)
- the same cv-qualifiers (const-/volatile-qualified methods)
- the same ref-qualifiers
- the same or more strict **exception specification** (we don't throw exceptions yet so it's not a problem)

If any of these requirements is not satisifed, shadowing will occur instead.

Since C++11 a very good practice is to use `override` specifier. **If you mark a derived function `override`, but it does match any virtual function in it's parent classes it will be a compilation error.** In other words, bugs related to shadowing will be catched at compile time.

## override

<div class="note pro-tip">
For backwards compatibility reasons, `override` is not technically a keyword. It's allowed to use it eg for a variable name - the special meaning applies only in the context of function specifiers.

Still, better not use it for variable names. It's just for compatibility so that new "keyword" can not break old code.
</div>

Applying recommendations to the example from previous lesson:

```c++
class animal
{
public:
    animal() { std::cout << "animal::animal()\n"; }
    virtual ~animal() { std::cout << "animal::~animal()\n"; }

    virtual void sound() const
    {
        std::cout << "???\n";
    }
};

class cat : public animal
{
public:
    cat() { std::cout << "cat::cat()\n"; }
    ~cat() override { std::cout << "cat::~cat()\n"; }

    void sound() const override
    {
        std::cout << "meow\n";
    }
};

class dog : public animal
{
public:
    dog() { std::cout << "dog::dog()\n"; }
    ~dog() override { std::cout << "dog::~dog()\n"; }

    void sound() const override
    {
        std::cout << "whoof\n";
    }
};
```

<div class="note info">
`override` and `virtual` needs to be written only for function declarations. Outside-class definitions can not contain it.
</div>

**legacy convention**

Before C++11, it was recommended to always write `virtual` at any function that is dispatched dynamically. This was for informational purposes - someone that read the code would know that given function can be overriden. But it had a risk - instead of overriding, it could shadow base class function and form a different virtual function.

```c++
// assuming pre-C++11 standard

class animal
{
public:
    animal() { std::cout << "animal::animal()\n"; }
    virtual ~animal() { std::cout << "animal::~animal()\n"; }

    virtual void sound() const
    {
        std::cout << "???\n";
    }
};

class cat : public animal
{
public:
    cat() { std::cout << "cat::cat()\n"; }
    virtual ~cat() { std::cout << "cat::~cat()\n"; }
    //^^^^^ this will not help if base class dtor is not virtual

    // no const qualifier => functions do not match => shadowing occurs =>
    // classes derived from cat can override 2 functions (const and non-const overloads)
    virtual void sound() /* missing const */
    {
        std::cout << "meow\n";
    }
};
```

Such shadowing can be a bug hard to spot. Function exists but actually is never called. Since C++11 it became better - **use `virtual` (for first function) and `override` (for functions in every derived class)**.

## destructors

<div class="note pro-tip">
If a class is intended to be inherited from, provide (1) public virtual destructor OR (2) protected non-virtual destructor.
</div>

<div class="note info">
If base class destructor is virtual, derived class destructors are too.
</div>

<div class="note info">
If base class destructor is not virtual, an attempt to dynamically destroy object of derived type is undefined behaviour (even if both destructors are empty).
</div>

The first option is simple - virtual destructors are necessary for correct destruction of objects viewed as a base type. Constructors can not be virtual because at the moment of creation of any type we exactly know which type is created.

The second option is for "controlled inheritance" case - non-virtual destructor is unsafe (as it will not release resources) but making it protected removes the possibility to destroy and consequently the possibility to create (without intentional leaks) any object. This option is used for certain inheritance patters - the class with protected non-virtual destructor is only for further inheriting (not "derived enough" to be used). It's also [discussed in Core Guidelines](https://github.com/isocpp/CppCoreGuidelines/blob/master/CppCoreGuidelines.md#discussion-make-base-class-destructors-public-and-virtual-or-protected-and-nonvirtual).

## longer heriarchies

Overriding happens in 1 way: always down. Derived classes can either:

- not override (and use the same function as the parent class)
- override (and provide own implementation)

**Example:**

```c++
#include <iostream>

struct A
{
    virtual ~A() = default; // public virtual ddestructor

    virtual void func() const
    {
        std::cout << "A::func()\n";
    }
};

struct B : A
{
    // ... no override - will use the same function as A
};

struct C : B
{
    void func() const override // replaces A::func
    {
        std::cout << "C::func()\n";
    }
};
```

If for some reason, you would like to reuse some base class implementation, call it explicitly:

```c++
struct D : C
{
    void func() const override
    {
        B::func(); // explicit use of parent class function
        // because B has not overriden it's parent it will actually be A::func
    }
};

int main()
{
    D d;
    A& ref = d;
    ref.func(); // prints "A::func()"
}
```
