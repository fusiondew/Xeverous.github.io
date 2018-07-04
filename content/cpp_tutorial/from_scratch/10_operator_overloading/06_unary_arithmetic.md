---
layout: article
---

Here we overload **unary** `+` and `-`.

These operators have no strong convention whether they should be member functions or not. Some types in standard library implement it as non-member (`std::complex`) and some as member (`std::chrono::duration`).

Member function implementation (const because it does not affect current object in any way):

```c++
// inside class
integer operator-() const;

// outside
integer integer::operator-() const
{
    return integer(-x);
}
```

Non-member function implementation:

```c++
// inside class
friend integer operator-(const integer& rhs);

// outside
integer operator-(const integer& rhs)
{
    return integer(-rhs.x); // . has higher priority than -, it's parsed as (-(rhs.x))
}
```

## unary +

Doesn't offer any significant functionality but exists for consistency with -. Might be used for custom types if they have three states (negative, neutral, positive) or some [DSL](https://en.wikipedia.org/wiki/Domain-specific_language).

The built-in unary + does not change values in any way but since C++ states that all integer calculations are performed on at least (in regards to size) `int` type, applying unary +/- to `char`s promotes them to integers.

```c++
#include <iostream>

int main()
{
    std::cout << 'a' << "\n";  // prints a (value treated as character)
    std::cout << +'a' << "\n"; // prints 97 (underlying ASCII value)
}
```
