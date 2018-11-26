---
layout: article
---

`static_cast`, apart from converting between primitive types also has another, different usage.

**`static_cast` can be used to cast across types in the given inheritance tree**

## directions

**Upward cast**

An upward cast is a convertion to (direct or indirect) base type of the given type.

**Downward cast**

A downward cast is a convertion to more derived type than the given type is.

**Sideward cast**

A sideward cast is a convertion to type sharing a parent type with given type.

TODO shouldn't these be mentioned earlier? Diagram + examples?

## rules

Upward casts can happen implicitly - if a function expects `const animal&`, we can safely input object `cat` because it's also an animal. There is no need to explicitly write the convertion because **upward casts are always safe** - derived types always also contain base type members.

Downward casts have to be explicitly written. Given an animal reference, we are not sure whether we got a `cat`, `dog`, `fish` or maybe something else.

## how it works

Upward casts don't require any rocket science. If we got object of derived type, it's subpart is also a base type.

However, if we got an object of base type, how can we guuarantee that there is something more - that object actually has potentially larger size and we would not end up reading forbidden memory area?

Since we start only with the base type, we need to draw that information from what base members offer. And actually there is a way to check it - the virtual table pointer.

Dynamic casts simply check virtual table pointer - either check the pointer value or read additional metadata stored in the virtual table. **This check can have negative result.**

## syntax

The same as for every explicit cast keyword:

```c++
dynamic_cast<new_type>(expression)
```

Casting along the inheritance tree is only allowed to be performed on pointer and reference types (remember object slicing, right?).

Obviously not all animals are cats so **dynamic cast can fail**.

## dynamic casting

If we cast on pointers:

- if the check succeeds, we get a valid (non-null) derived type pointer
- if the check fails, we get a null pointer

```c++
void func(animal& a)
{
    // we need to cast downwards because we want to do something specific for cats
    cat* cat_ptr = dynamic_cast<cat*>(&a);

    if (cat_ptr != nullptr)
    {
        // cast succeeded, passed object is a cat
        // ...
    }
}
```

If we cast on references:

- if the check succeeds, the code continues (references are always valid)
- if the check fails **an exception of type `std::bad_cast` is thrown**

References can never be null, so language creators had to do something special in this case. What exactly are exceptions and how to handle them - in later chapters. Now I will just note that exceptions can drastically change control flow and skip multiple execution paths.

```c++
void func(animal& a)
{
    try {
        cat& cat_ref = dynamic_cast<cat&>(a); // will instantly exit 'try' block on exception

        // if code reaches here cast succeeded
    }
    catch (const std::bad_cast& e) {
        // handle exception...
    }
}
```

This may look complicated. In fact, exceptions are intended for exceptional situations and using them for casting is considered an overcomplication.

<div class="note pro-tip">
When dynamic casting, use pointer approach.
</div>

## static casting

Static casting across inheritance tree performs no checks. It's just a plain decision to treat the given type like it was something different.

Obviously casting to base type is redundant, it can happen implicitly:

```c++
void func(const cat& c)
{
    animal& a = c; // implicit convertion
    animal& a = static_cast<animal&>(c); // explicit convertion (redundant)
}
```

Casting to derived type is dangerous:

```c++
void func(const animal& a)
{
    // cat& c = a; // error: implicit convertion can not downcast
    cat& c = static_cast<cat&>(a); // explicit convertion

    // if a is not a cat this is undefined behaviour
}
```

## other notes

Dynamic and static casting can not remove cv-qualifiers. For explicit removal of them, you will need `const_cast`.

Sideward casts work like downcasts (they are not guuaranteed to succeed).

## rationale

Too much casts signal a bad design.

```c++
void func(animal& a)
{
    cat* cat_ptr = dynamic_cast<cat*>(&a);

    if (cat_ptr != nullptr)
    {
        // ...
    }

    dog* dog_ptr = dynamic_cast<dog*>(&a);

    if (dog_ptr != nullptr)
    {
        // ...
    }

    fish* fish_ptr = dynamic_cast<fish*>(&a);

    if (fish_ptr != nullptr)
    {
        // ...
    }
}
```

If you see something like this it signals that the base `animal` class should offer more virtual functions. Many type checks are a code smell because they defeat the purpose and intended use of polymorphism.

## summary

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>direction and result</th>
                <th>implicit convertion</th>
                <th>static cast</th>
                <th>dynamic cast</th>
            </tr>
            <tr>
                <td>upwards (always success)</td>
                <td>allowed</td>
                <td>well-defined behaviour*</td>
                <td>well-defined behaviour*</td>
            </tr>
            <tr class="even">
                <td>downwards/sidewars (success)</td>
                <td rowspan="2">not allowed</td>
                <td>well-defined behaviour</td>
                <td>well-defined behaviour</td>
            </tr>
            <tr>
                <td>downwards/sidewars (fail)</td>
                <td>undefined behaviour</td>
                <td>well-defined behaviour</td>
            </tr>
        </tbody>
    </table>
</div>

**\*:** These casts are redundant. 

<div class="note pro-tip">
When casting downwards, use static cast only when you are absolutely sure that the object is of derived type.
</div>

#### Question: How can I be sure about the type before static downcast?

It depends on invariants and design of your program. Usually the type is proven by certain characteristics. If `animal.get_weight()` returns 1000 kg I would bet it's likely not a cat...

But honestly, I would recommend to use dynamic casts instead. Relying on invariants (which may change in program versions) is risky and you won't get huge performance improvements from avoiding one virtual table pointer check.
