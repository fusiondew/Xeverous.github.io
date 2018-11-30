---
layout: article
---

Operator overloading lets you define behaviour of operators for custom types. This is a really good feature because it allows to make the code very intuitive.

```c++
matrix2x2 m1{1, 2, 3, 4};
matrix2x2 m2{4, 3, 2, 1};

// ordinary method - member functions
matrix2x2 m3 = m1.add(m2);

// using overloaded operator
matrix2x2 m3 = m1 + m2; // isn't this much better?
```

Multiple classes in the C++ standard library have overloaded operators:

- `<<` and `>>` for streams (text I/O)
- `+` for strings
- `*` and `->` for smart pointers
- `[]` for multiple containers

Overloaded operators are also used by some external libraries, like in the example above - we can have `*` that performs matrix multiplication.

## how it works

Operators are nothing more than functions with special call syntax. We can think of built-in meaning of `+` for integers as:

```c++
int operator+(int lhs, int rhs);
// lhs = left hand side
// rhs = right hand side
```

The exactly the same syntax is used to define them for custom types.

There is a cheatsheet about operator overloading - handy reference after completing this chapter. TODO link

## rules

- some operators can not be overloaded: `::`, `.`, `.*`, `?:`
- some operators have restrictions for their return type
- some operators can not be non-member
- you can not create new operators - eg `%%` or `<-`
- you can not change arity of operators - if `/` takes 2 arguments normally, it must be a 2-argument function 
- some operators lose *short-circuit evaluation*
- at least one of operands must be a user-defined type - you can't redefine behaviour for built-in types
- `new`/`delete` operators can be overloaded to modify how objects are allocated
- you can overload *operator type* which creates a user-defined convertion
- you can overload *operator""* which creates a user-defined literal suffix

## recommendation

This chapter is mostly for informational purposes. Note that in practice, very few classes have overloaded operators. While the feature can be useful, reading code that uses a lot of overloaded operators can be hard - unlike functions, operators don't have names.

For this reason, the general recommendation is to not overload operators unless it's very clear what they do.
