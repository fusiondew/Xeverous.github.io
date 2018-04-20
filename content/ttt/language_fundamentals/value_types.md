---
layout: article
---

## First glance - simple explanation

I will start with simplified explanation in regards to C to grasp the concept of value types. C has only lvalues and rvalues. Then I will move onto C++ and why it has more complex system.

Note: the formal terms are *lvalue expression*, *rvalue expression* and such.

#### lvalue (left value)

An **lvalue** is something that can appear **both** on the left and right side of an assignment.

Suppose we have integers `a`, `b` and `c`.

All of the following expressions are valid:

```c++
a = b;
b = a;
a = a + 1;
c = a + b;
int* p = &c;
```

Don't overthink it, it's that simple. `a`, `b` and `c` can be on both sides.

Thus, all of `a`, `b` and `c` are **lvalue expressions**.

#### rvalue (right value)

Am **rvalue** is something that can appear **only** on the right side of an assignment.

The following expressions are valid:

```c++
a = a + 1;
c = a + b;
int* p = &c;
```

But the following are not:

```c++
a + 1 = a;
a + b = c;
int* p = &(a + b);
```

Thus, `a + 1` and `a + b` are **rvalue expression**s. They can not be put on the left.

In other words, rvalues are temporary objects. You can not assign to temporaries and can not obtain their address.

`1` is also an rvalue expression:

```c++
// does not compile
1 = a;
int* p = &1;
```

#### Short summary

- **lvalue expressions** can appear on both left and right side of an assignment
- **rvalue expressions** can appear only on the right side of an assignment
- lvalues have well-defined scope and lifetime, as they are names of the variables
- rvalues are temporary objects, assigning to temporaries is both pointless and impossible, address of a temporary can not be taken

### operator ++

You might already came up with this question: Is `++a` and `a++` an lvalue or an rvalue?

The answer is crossing boundary between C and C++.

Compare what is happening for `a++`:

```c++
int postincrement(int x)
{
    int temp = x;
    x = x + 1;
    return temp;
}
```

and what for `++a`:

```c++
int& preincrement(int& x)
{
    x = x + 1;
    return x;
}
```

You might already know that the expression `a++` does not have it's results visible immediately. `a` is changed but the old value is returned. However, `++a` changes `a` in-place.

The answer is:

- `++a` is an lvalue expression
- `a++` is an rvalue expression

The following expressions are valid:

```c++
b = ++a; // lvalue = lvalue
b = a++; // lvalue = rvalue
++a = b; // lvalue = lvalue
```

but the following is not:

```c++
a++ = b; // rvalue = lvalue
```

and produces such error message for GCC:

```c++
main.cpp: In function 'int main()':
main.cpp:9:11: error: lvalue required as left operand of assignment
     a++ = b;
           ^
```

### functions

This drives to the question: How does function's return type impact valueness?

The answer for C is very simple: functions invokations are always an rvalue.

The answer for C++ (due to references) is more complex - function call expressions are:

- a **prvalue** if the function return type is `T`
- an **lvalue** if the function return type is `T&`
- an **xvalue** if the function return type is `T&&`

Expression `++a` in C is an lvalue, even though the language has no notion of references. In this situation C supports on-the-fly incerement operation but does not support defining such functions in the code.

## value types in C++

Before C++11, the standard had only notion of left and right values. But it was not consistent - multiple contexts used these terms but applied long exceptions, thus making each situation a unique set of rules. It was clear that new terms need to be made to avoid exceptions in rules and provide more consistent behaviour.

lvalue term was left as it was but rvalue has been renamed to prvalue. Most of C++ uses only lvalue and rvalue terms, as both are mutually exclusive. Sometimes rvalues will be split into prvalues and xvalues. glvalue term is rarely used.

![value types in C++](https://i.stack.imgur.com/GNhBF.png)

### the boring stuff

skip these 2 sections if they are too long or complex

SPOILER START

##### definitions

**glvalue expression** - either an lvalue or an xvalue

**rvalue expression** - either an xvalue or a prvalue


An **lvalue expression** is an expression that denotes an accessible object, bit field or a function. **Every name is an lvalue.**

lvalues (left values):

- name of a variable/constant/function: `a`, `func`, `std::cout`
- assignment expression: `a = b`, `a += 1`
- preincrement/predecrement operation: `++a`, `--b`
- function calls where the function return type is an lvalue reference (`T&`) - this rule also applies to overloaded operators
- pointer dereference: `*p`
- member of object: `a.m` if { `a` is an lvalue and `m` is not a member enum or a non-static member function } or { `a` is an rvalue and `m` is a non-static data member of non-reference type }
- member of pointer: `p->m` if `m` is not a member enum or a non-static member function
- pointer to member of object: `a.*mp` if `a` is an lvalue and `mp` is a pointer to data member
- pointer to member of pointer: `p->*mp` if `mp` is a pointer to data member
- array subscript: `a[n]` if `a` is an lvalue
- comma expression: `foo, bar` where `bar` is an lvalue (comma returs last thing)
- a string literal: `"hello world"`, `L"wide char hello"`
- casts to lvalue reference types: `static_cast<T&>(expr)`
- casts to rvalue reference to function type: `static_cast<void (&&)(int)>(x)`

A **prvalue expression** is an expression that denotes a temporary or initializes an object. Expressions returning `void` are also prvalues. prvalues represent middle-computation values that do not have any defined origin - prvalues live only to the end of expression and do not have any connection to where they came from.

prvalues (pure right values):

- non-string literals (so called "hardcoded values"): `1337`, `true`, `nullptr`, `3.14`
- funcion calls where the function returns by value (`T`) - this rule also applies to overloaded operators, built-in operators and comparisons: `a + b`, `a > b`, `a || b`, `a % b`, `a << b`, `!a`
- the address of expression: `&a` and the this pointer: `this` (we can say these return addresses by value)
- an enum
- member of object: `a.m` if { `m` is an enum or non-static member function } or { `a` in an rvalue and `m` is a non-static data member of non-reference type }
- member of pointer: `p->m` if `m` is a member enumerator or a non-static member function
- pointer to member of object: `a.*mp` if `mp` is a pointer to member function
- pointer to member of pointer: `p->*mp` if `mp` is a pointer to member function
- a cast to non-reference type: `static_cast<T>(expr)`
- a lambda expression
- (since C++20) a requires expression
- (since C++20) a specialization of a concept

An **xvalue expression** in an expression that denotes a unnamed temporary object that has connection to where it has came from. xvalues denote an object (which has some life scope) or bit field which resources can be reused.

xvalues (expiring values):

- casts to rvalue reference: `static_cast<T&&>(expr)`
- funcion calls where the function returns by rvalue reference (`T&&`) - this rule also applies to overloaded operators; the only such standard function is `std::move`
- array subscript: `a[n]` if `a` is an array rvalue
- member of object: `a.m` if `a` is an rvalue and `m` is a non-static data member of non-reference type
- pointer to member of object: `a.*mp` if `a` is an rvalue and `mp` is a pointer to data member
- (since C++17) all expressions designating temporary objects after temporary materialization: `X().n`

##### What about `a ? b : c` ?

Now, [this is complicated](http://en.cppreference.com/w/cpp/language/operator_other#Conditional_operator). Generally it will return lvalue if both `b` and `c` are lvalues and a prvalue if both `b` and `c` are prvalues. However, there are multiple possibilities for implicit convertions and the fact that you can do things like `str = x ? "ok" : throw std::logic_error()` where `"ok"` returns a literal and second expression returns `void` makes it even more complicated. Especailly when we combine it with bit fields. Convertions for both operands must be decided at compile time as the valueness is a language specification, not runtime decision.

Basically avoid this ternary operator in unclear contexts. It's a pile of C backwards compability layers and multiple implicit convertion rules. If you are going to conditionally use copy/move constructor better wrap everything in standard `if`s and use explicit casts.

SPOILER END

SPOILER START

##### properties

**glvalue** (general left value) (an object)

- can be polymorphic
- type can be incomplete (only declared) if the full definition is not needed in the expression
- may fall into implicit convertions (which result in prvalues, as the convertions copy-construct the object)

**rvalue** (right value) (a temporary)

- address of can not be taken
- can not be assigned to
- can be used to initialize an object, const lvalue reference or rvalue reference

**lvalue** (left value) (an object with owner)

- (inherited from glvalue)
- has well defined scope (lifetime)
- can be assigned to
- address of can be taken

**prvalue** (pure right value) (a pure temporary)

- (inherited from rvalue)
- has no scope - lifetime only enough to survive the expression
- has no connection to where it came from

**xvalue** (expiring value) (an object that just lost it's owner)

- (inherited from glvalue)
- (inherited from rvalue)


##### other notes

- things (functions, casts, hardcods, enums, operators, addresses) that return non-reference are **prvalues**
- every name (as a sole expression) is an **lvalue**, additionally expressions returning references to objets are also **lvalues**
- expressions returning rvalue reference are **xvalues**
- function name is an lvalue (`func`) but value type of function call expression (`func()`) depends on it's return type
- value type of comma expression `a, b` is the value type of `b`
- every named reference is an **lvalue**, since whatever has been bound to it has now a name and well-defined scope

SPOILER END

## tl;dr and what you need to remember

Shortest value types descriptions ("can be reused" == "can be moved from")

- **lvalue** - some identity with an associated resource, has a well-defined lifetime

- **prvalue** - just the pure resource (can be reused), has no lifetime

- **xvalue** - some identity with expired resource (can be reused)

Binding rules - form 1

- **lvalue**s can not be bound to rvalue references (`T&&`)
- **rvalue**s (prvalues + xvalues) can not be bound to non-const lvalure references (`T&`)
- all value types can be bound to const lvalue references (`const T&`)

Binding rules - form 2

- non-const lvalue references (`T&`) accept only **lvalue**s
- rvalue references (`T&&`)  accept only **rvalue**s
- const lvalue references (`const T&`) accept everything

In terms of the code, almost all expressions will be either **lvalue** (objects) or **prvalues** (pure temporaries). Rarely you will explicitly convert **lvalue** to **xvalue** to perform move operations.
