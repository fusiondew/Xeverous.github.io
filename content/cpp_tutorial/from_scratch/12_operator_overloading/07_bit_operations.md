---
layout: article
---

TODO rewrite this article to showcase std::byte-like type, not integer

Binary bitwise operators are rarely overloaded, examples only for reference.

**Note:** `&` has 2 arity variants:

- binary (`a & b`) which by default performs bitwise operations
- unary (`&a`) which is the address-of operator

Here we overload the binary one.

```c++
// inside class definition
friend integer operator&(integer lhs, integer rhs);
friend integer operator|(integer lhs, integer rhs);
friend integer operator^(integer lhs, integer rhs);
integer& operator&=(integer rhs);
integer& operator|=(integer rhs);
integer& operator^=(integer rhs);

// outside, in a source file

// for symmetric operators we return a new object
integer operator&(integer lhs, integer rhs)
{
    return integer(lhs.x & rhs.x);
}

integer operator|(integer lhs, integer rhs)
{
    return integer(lhs.x | rhs.x);
}

integer operator^(integer lhs, integer rhs)
{
    return integer(lhs.x ^ rhs.x);
}

// for asymmetric operators we implement them as members and return back left operand
integer& integer::operator&=(integer rhs)
{
    x &= rhs.x;
    return *this;
}

integer& integer::operator|=(integer rhs)
{
    x |= rhs.x;
    return *this;
}

integer& integer::operator^=(integer rhs)
{
    x ^= rhs.x;
    return *this;
}
```

In some cases, the operator implementation itself is long - eg when performing operations on matrices. It would be bad to reimplement matrix multiplication for both `*` and `*=`. To solve this, non-member operators are often written to reuse member operators:

```c++
integer operator&(integer lhs, integer rhs)
{
    integer temp = lhs; // make a copy
    temp &= rhs;        // reuse implementation of &= on the copy
    return temp;
}

// shorter version (uses the fact that function parameter itself is a copy)
integer operator&(integer lhs, integer rhs)
{
    lhs &= rhs; // will not work if lhs is taken by const reference
    return lhs;
}

// even shorter version - uses the fact that expression (lhs &= rhs) returns reference
integer operator&(integer lhs, integer rhs)
{
    return lhs &= rhs;
}

// in case type is expensive to copy
integer operator&(integer lhs, const integer& rhs)
// lhs not taken by const reference because we need it's copy
{
    return lhs &= rhs; // modify lhs and return it
}
```

## unary `~`

It's unary but worth to mention here because it's usually overloaded together with other bit-related operators. `~` itself has no strong convention and therefore it's recommended to use it only for types that represent some bit operations.

```c++
// inside class definition
integer& operator~();

// outside
integer& integer::operator~()
{
    x = ~x;
    return *this;
}
```
