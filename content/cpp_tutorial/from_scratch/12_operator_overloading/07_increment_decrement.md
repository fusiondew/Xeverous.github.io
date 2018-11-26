---
layout: article
---

<div class="note info">
This lesson requires understanding of prefix and postfix operator differences. TODO link?
</div>

Prefix and postfix operators have to be implemented as members.

## prefix

```c++
// inside class
integer& operator++();
integer& operator--();

// outside
integer& integer::operator++()
{
    ++x;
    return *this;
}

integer& integer::operator--()
{
    --x;
    return *this;
}
```

Reference is returned to allow reuse of the object. Otherwise expressions like `std::cout << ++x` would complain that `++x` returns `void` and there is no object to print.

Note: the code above is for **prefix** operators. It might seem intuitive to expect language to have `operator++()` and `++operator()` but it's not how it works.

## postfix

**postfix** operators have to take a dummy argument. It's an `int` which is always zero. I don't know why it is that but I guess requiring dummy argument is much cleaner (in terms of language specification) than inventing special reversed `++operator()` syntax (syntax rules are a big pain).

Because the dummy argument is guaranteed to be always zero, it doesn't serve any purpose (behind making a difference from prefix operators) so it's name is ommited to signal that it's not used.

```c++
// inside class
integer operator++(int);
integer operator--(int);

// outside
integer integer::operator++(int)
{
    integer temp = *this;
    ++(*this);
    return *temp;
}

integer integer::operator--(int)
{
    integer temp = *this;
    --(*this);
    return temp;
}
```

Postfix operators are expected to return a copy of the old value - that's why they save the current object into temporary before `*this` gets changed.

`++(*this);` reuses prefix operator. It can also be written `operator++();`.

## notable exception

`std::atomic` prefix operators return by value. It would be pointless to return references to objects that are intended to be modified only atomically (more information in concurrency tutorial). Atomics overload most operators to provide the same syntax as for plain types but due to various aspects of concurrency they have good reasons not to stick to all conventions.
