---
layout: article
---

Binary bitwise operators are rarely overloaded, examples only for reference.

**Note:** `&` has 2 arity variants:

- binary (`a & b`) which by default performs bitwise AND
- unary (`&a`) which is the address-of operator

Here we overload the binary one.

```c++
// inside class definition
friend integer operator&(const integer& lhs, const integer& rhs);
friend integer operator|(const integer& lhs, const integer& rhs);
friend integer operator^(const integer& lhs, const integer& rhs);
integer& operator&=(const integer& rhs);
integer& operator|=(const integer& rhs);
integer& operator^=(const integer& rhs);

// outside
friend integer operator&(const integer& lhs, const integer& rhs)
{
    return integer(lhs.x & rhs.x);
}

friend integer operator|(const integer& lhs, const integer& rhs)
{
    return integer(lhs.x | rhs.x);
}

friend integer operator^(const integer& lhs, const integer& rhs)
{
    return integer(lhs.x ^ rhs.x);
}

integer& integer::operator&=(const integer& rhs)
{
    x &= rhs.x;
    return *this;
}

integer& integer::operator|=(const integer& rhs)
{
    x |= rhs.x;
    return *this;
}

integer& integer::operator^=(const integer& rhs)
{
    x ^= rhs.x;
    return *this;
}
```

In some cases, the operator implementation itself is long - eg when performing operations on matrices. It would be bad to reimplement matrix multiplication for both `*` and `*=`. To solve this, non-member operators are often written to reuse member operators:

```c++
friend integer operator&(const integer& lhs, const integer& rhs)
{
    integer temp = lhs;
    temp &= rhs;
    return temp;
}

// shorter version (uses copy of parameter)
friend integer operator&(integer lhs, const integer& rhs)
{
    lhs &= rhs;
    return lhs;
}
```
