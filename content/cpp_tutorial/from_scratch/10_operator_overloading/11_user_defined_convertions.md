---
layout: article
---

It's possible to create custom convertions by overloading the cast operator.

The cast operator uses a type name in place of the operator and has no specified return type - it's similar to constructors. It can be thought as returning by value an object of different type.

```c++
#include <iostream>

class fraction
{
private:
    // greatest common divisor - used to reduce denominators
    int gcd(int a, int b) { return b == 0 ? a : gcd(b, a % b); }

    int n;
    int d;

public:
    fraction(int n, int d = 1) : n(n / gcd(n, d)), d(d / gcd(n, d)) { }

    int num() const { return n; }
    int den() const { return d; }

    fraction& operator*=(const fraction& rhs)
    {
        int new_n = n * rhs.n / gcd(n * rhs.n, d * rhs.d);
        d = d * rhs.d / gcd(n * rhs.n, d * rhs.d);
        n = new_n;
        return *this;
    }

    // user-defined convertion
    explicit operator double() const
    {
        return static_cast<double>(n) / d;
    }
};
// non-member operator* reuses member operator*=
// - lhs by copy to avoid temporary object
// - return works because operator*= returns fraction& and then it's copied
// fraction operator*(const fraction& lhs, const fraction& rhs)
// {
//     fraction temp(lhs);
//     temp *= rhs;
//     return temp;
// }
fraction operator*(fraction lhs, const fraction& rhs)
{
    return lhs *= rhs;
}

std::ostream& operator<<(std::ostream& out, const fraction& f)
{
   return out << f.num() << '/' << f.den();
}

int main()
{
    fraction f1(3, 8);
    fraction f2(1, 2);
    fraction f3(10, 2);

    fraction f4 = f1 * f2;
    fraction f5 = f2 * f3;
    fraction f6 = 2 * f1; // uses implicit construction (note that ctor has default argument)

    std::cout << f1 << " * " << f2 << " = " << f4 << '\n'
              << f2 << " * " << f3 << " = " << f5 << '\n'
              <<  2 << " * " << f1 << " = " << f6 << '\n';

    std::cout << "as floating-point:\n"
              << static_cast<double>(f4) << '\n'
              << static_cast<double>(f5) << '\n'
              << static_cast<double>(f6) << '\n';
}
```

~~~
3/8 * 1/2 = 3/16
1/2 * 5/1 = 5/2
2 * 3/8 = 3/4
as floating-point:
0.1875
2.5
0.75
~~~

It's recommended to make user-defined convertions explicit.

```c++
// without explicit - potentially accidental mistake
double d = f4;

// with explicit - required cast
double d = static_cast<double>(f4);
```

Additionally, implicit convertions can result in ambiguities in copy-initialization and reference initialiation because both converting constructor and user-defined convertion are 2 implicit convertions.

```c++
struct to {
    to() = default;
    to(const struct from&) {} // converting constructor
};

struct from {
    /* explicit */ operator to() const { return to(); } // implicit conversion function
};

// 'to' can be made in 2 ways:
// ctor taking 'from'
// convertion of 'from' to 'to'

int main()
{
    from f;
    to t1(f); // direct-initialization: calls the constructor
    // if converting constructor is not available, implicit copy constructor
    // will be selected, and conversion function will be called to prepare its argument

    to t2 = f; // copy-initialization: ambiguous
    // if conversion function is from a non-const type
    // it will be selected instead of the ctor in this case

    to t3 = static_cast<to>(f); // direct-initialization: calls the constructor

    const to& t4 = f; // reference-initialization: ambiguous
}

// making convertion function explicit would remove ambiguities
```

<div class="note pro-tip">
When providing user-defined convertions, make them explicit.
</div>

## in the standard library

Streams overload `operator bool()` to be able to be tested for valid flags inside conditional expressions.

```c++
while (std::cin >> arr[i]) // << and >> returns reference for chaining
// but we can also use the stream object to convert it to bool
while (std::getline(std::cin, str)) // getline returns stream reference, then the stream is converted to bool
```

Many other types overload the same operator for easier checking:

```c++
std::optional<int> opt = func();
if (opt) // opt is not empty
{
    // ...
}
```

<div class="note info">

Control flow statemets will still work without casts to `bool` even when user-defined convertions are explicit.
</div>

## `operator!`

Classes which overload convertion to `bool` should also overload `operator!`, giving it reverse result of the convertion.

With both convertion and negation operator, objects can conveniently be used in any boolean context.

```c++
if (opt)  // uses operator bool()
if (!opt) // uses operator!()
```

<div class="note pro-tip">

When overloading convertion to `bool`, also overload `!`.
</div>
