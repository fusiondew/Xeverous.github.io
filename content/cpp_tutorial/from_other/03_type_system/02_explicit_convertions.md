---
layout: article
---

Practically no question regarding C++ has an easy answer and so it is with explicit convertions.

TODO mention `explicit`.

## C-style casts

The casts in the form of `(int)x` are prevalent in many languages but *discouraged* in C++.

*Discouraged* here means it is being kept for backwards compatibility. This cast is not good because there are situations in C++ where there is more than 1 possibile method of convertion - C casts can be ambiguous. Compilers also offer to set up a warning (GCC/Clang `-Wold-style-cast`).

The only widely accepted cast of this form is explicit discard of the result: `(void) expression`. It relies on the fact that the result of any expression can be converted to void type - this cast should be used purely to shut warnings about unused data.

## functional casts

First edition of C++-favoured casts were functional casts: `int(x)`. They have cleaner syntax: `int(x + y)` vs `(int) x + y`.

This cast when used with a class type, does not perform any special convertion - it is just a constructor call.

## modern casts

These are the casts that you should use in modern C++. C++11 introduced 4 cast keywords to solve these problems:

- ambiguous C-style casts (reinterpretation or actual convertion)
- problems related to old C that had no `const` keyword
- be explicit - new casts clarly describe intention

```c++
     static_cast<T>(expression)
    dynamic_cast<T>(expression)
      const_cast<T>(expression)
reinterpret_cast<T>(expression)
```

## static cast

There are 2 purposes:

- convertion between built-in types
- convertions across inheritance tree

**built-in types**

There is no need for explicit casts when doing a promotion (lossless convertion) but narrowing in many contexts will require it.

```c++
double x = 3.3;
double y = 1.6;

// floating-point division, result truncated to 2
int a = x / y;
// integer division: 3 / 1
int b = static_cast<int>(x) / static_cast<int>(y);
```

Static casts can not be used for int-to-string or string-to-int convertions since they involve a class type. Standard library offers multiple parsing functions instead.

**upcast**

Every derived type is also a base type. C++ allows to implicitly convert derived type pointers and references to base type.

```c++
struct base {};
struct derived : base {};

void func(const base&);

derived d;
func(d); // ok, implicit upcast
```

This can also happen for values, which causes **object slicing**. It is never wanted - see OOP chapter for explanation and recommendations.

**downcast**

Static casts can be used to perform downcasts on pointers and references. **No runtime check is performed.** This method has no overhead but invokes undefined behaviour if the object is not of derived type.

```c++
static_cast<derived&>(obj)
```

Such casts smell of bad code structure and/or risky optimization.

Notable exception: template design patters relying on recursive class template definitions.

**sidecast**

Welcome to the world of multiple inheritance. Same princiles as with downcasting apply.

```c++
struct A {};
struct B1 : A {};
struct B2 : A {};
struct C : B1, B2 {};

C c;
B1& b1 = c;
static_cast<B2&>(b1);
```

## dynamic cast

This cast is purely intended for safe downcasting and sidecasting. Performs runtime check (may incur overhead) - requires types to be polymorphic.

```c++
dynamic_cast<cat*>(&animal); // fail: returns null pointer
dynamic_cast<cat&>(animal);  // fail: throws std::bad_cast
```

## const cast

All types can have implicitly added constness. This cast allows to explicitly remove it.

```c++
const char* path = "/bin/bash";
int legacy_syscall(char*);

legacy_syscall(const_cast<char*>(path));
```

The cast allows to workaround C++ type system rules, but still invokes undefined behaviour if the const-casted objects are attempted to be modified.

This cast is purely for interacting with legacy code (mostly syscalls) that date back to times preceeding `const` keyword.

## reinterpretation

Allows to treat object's bytes as it was a different type.
