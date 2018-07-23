---
layout: article
---

## preface

<div class="note info">
This lesson is not important. It's one of these "obscure C++ features".
</div>

<div class="note info">
Multiple (non-<strong>interface</strong>) inheritance is rarely used in practice. It has some uses (mostly templates) but each is a very unique and narrow scenario.
</div>

Many programming languages do not allow multiple inheritance (only **interface** inheritance) because it allows the **diamond problem** to happen. C++ has a solution to it but it's another set of not-so-obvious rules.

## multiple parents

It's possible to inherit from multiple classes. Such class follows all ordinary rules regarding inheritance (you get memebrs from both and can call both parent constructors in member init list).

```c++
class mammal { /* ... */ };
class flying { /* ... */ };

// note that access specifier is applied per parent
class bat : public mammal, public flying { /* ... */ };
```

Such `bat` class would be accepted by any function that accepts `mammal` or `flying`.

## the diamond problem

A problem that can occur looks like following:

```c++
class animal { /* ... */ };

class mammal : public animal { /* ... */ };
class flying : public animal { /* ... */ };

// note that access specifier is applied per parent
class bat : public mammal, public flying { /* ... */ };
```

~~~
        animal
        /    \
       /      \
    mammal   flying
       \      /
        \    /
          bat
~~~

Classes `mammal` and `flying` inherit from `animal`. Objects of these 2 classes contain `animal`-inherited members.

If `bat` inherits from both of these classes, it will contain 2 copies of `animal` members - one copy from `mammal` and 1 copy from `flying`. It will be more like the following:

~~~
    animal   animal
      |        |
      |        |
    mammal   flying
       \      /
        \    /
          bat
~~~

This is almost always not desired behaviour - while bats are both mammals and flying creatures (and therefore should inherit all of their members) they should not contain doubled animal data.

**how does it look in the code**

The problem is just another shadowing:

```c++
// suppose class animal has member variable 'weight'

void bat::some_bat_func()
{
	if (weight == ...) // error: weight is ambiguous

	if (mammal::weight == ...) // ok, use animal data inherited from mammal

	if (flying::weight == ...) // ok, use animal data inherited from flying
}

// it works analogically for duplicated member functions etc
```

We can solve the ambiguity by prefixing names with parent classes, the code will compile but it does not solve the actual problem - we still have duplicated animal data.

## virtual inheritance

You can specify inheritance to be virtual. It's needed to be written explicitly because it significantly affects layout of data in memory and order of construction.

If a parent class appears multiple times in the hierarchy:

- there is 1 copy for each non-virtual inheritance
- there is exactly 1 copy if there is 1+ virtual inheritance

```c++
class N { /* ... */ };

class A : public N {};
class B : public N {};
class C : public N {};

class X : virtual public N {};
class Y : virtual public N {};
class Z : public virtual N {}; // also valid keyword order

class M : public A, public B, public C, public X, public Y, public Z {};
/*
 * class M will contain 4 Ns:
 * - 1 from A
 * - 1 from B
 * - 1 from C
 * - 1 shared by X, Y, Z
 */
```

**Construction**

Because `X`, `Y` and `Z` share the same parent virtually, they can not each call the parent constructor - it would recreate the parent 3 times.

**With virtual base classes, only the most derived type calls virtual parent class constructors.**

```c++
M::M()
: A(), B(), C(), N(), X(), Y(), Z()
{
}

/*
 * construction order:
 * A::N
 * A
 * B::N
 * B
 * C::N
 * C
 * N (virtual)
 * X (N ctor in member init list ignored)
 * Y (N ctor in member init list ignored)
 * Z (N ctor in member init list ignored)
 */
```

Destruction - in reverse order; citing Bjarne's "explanation":

> Destructors for virtual base classes are executed in the reverse order of their appearance in a depth-first left-to-right traversal of the directed acyclic graph of base classes.

## recommendation

TODO this lesson requires intrfaces

Don't use multiple non-**interface** inheritance. *Unless you are an expert of object-oriented code and know exactly what are consequences and applications of multiple inheritance.*
