---
layout : article
---

A very good rule is to make overloaded operators behave intuitively, like the build-in ones.

- `a + b` - returns temporary object holding the result
- `a += b` - modifies `a`

Because of this, assignment-like operators should be implemented as member functions.

```c++
class integer
{
public:
    integer(int x = 0) : x(x) { }
    
    integer& operator+=(integer rhs); // < no const here >

private:
    int x;
};

integer& integer::operator+=(integer rhs)
{
    x += rhs.x;
    return *this;
}
```

The member function is intended to modify left operand, so it's not const-qualified.

What about that weird return type and return statement? Shouldn't the function return `void`?

Of course, it can have `void` return type and don't return anything but there is a reason why it is implemented this way. Sometimes you can see something like this:

```c++
a = b = c = d = 1;
// parsed as
a = (b = (c = (d = 1))); // reminder: assignments work right-to-left
```

Such expressions would not work if the assignment operator did not return anything.

A more common example:

```c++
std::cout << a << b << c;
```

This technique is named **operator chaining**. By returning a reference to the current object, another operator can be applied to the expression. It's rarely used with assignment operators though.

Remainder: `this` is a pointer. In order to return a reference it must be dereferenced, hence `return *this`.

All other assignment-like operators are written analogically:

```c++
// inside class definition
integer& operator-=(integer rhs);
integer& operator*=(integer rhs);
integer& operator/=(integer rhs);
integer& operator%=(integer rhs);

// outside, in a source file
integer& integer::operator-=(integer rhs)
{
    x -= rhs.x;
    return *this;
}

integer& integer::operator*=(integer rhs)
{
    x *= rhs.x;
    return *this;
}

integer& integer::operator/=(integer rhs)
{
    x /= rhs.x;
    return *this;
}

integer& integer::operator%=(integer rhs)
{
    x %= rhs.x;
    return *this;
}
```
