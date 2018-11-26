---
layout: article
---

`final` has 2 uses

- blocking further overriding
- blocking further inheritance

Similarly to `override`, it is not technically a keyword (obviously using is for naming things is a bad idea) - it has it's special meaning only in function qualifiers context.

## blocking overriding

```c++
struct A
{
    virtual void func();
};

struct B : A
{
    void func() final; // final here also implies 'override'
};

struct C : B
{
    void func() override; // error: B::func is final
};
```

```c++
struct A
{
    void func() const;
};

struct B : A
{
    void func() const final; // error: not a virtual function
};
```

## blocking inheritance

```c++
struct A { /* ... */ };
struct B : A { /* ... */ };
struct C final : B { /* ... */ };
struct D : C { /* ... */ }; // error: C is final
```

## recommendation

Use `final` very sparingly, only in situations where you have a good reason to block further inheritance or overriding.

Example good arguments:

- (blocking overriding) derived classes should not change some invariant (eg `fish::can_fly()` returns `true` and all more specific fish types should not replace this behaviour) - this is mostly a consistency check
- (blocking inheritance) a class contains non-virtual destructor and should not be inherited from by it's purpose (the class is purely for composition)

In this regard `final` is mostly a sanity check to stop bugs caused by changes that break assumptions about the program or program consistency.

<div class="note pro-tip" markdown="block">
Virtual functions should specify exactly one of `virtual`, `override`, or `final`.

Reason: exactly 1 is self-documenting and prevents bugs at compile time. More is redundant. 

Also in [CPPCG C.128](http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rh-override)
</div>
