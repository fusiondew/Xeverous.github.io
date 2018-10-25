---
layout: article
---

There are 5 basic arithmetic operators: `+ - * / %`. All can be used on integer types and all except `%` can be used on floating-point types.

Note that while `a + b` is written the same way regardless whether they are integers or floating-point types, the resulting machine code is different - calculations on floating-point types use much different (more complicated) instructions.

If operands are not of the same type, implicit convertion (if possible) is performed, if not it's a compiler error. More about implicit and explicit convertions later - for now make sure that for any expression both `a` and `b` are of the same type.

## binary plus and minus

`a + b` works as expected both with integers and floating-point types.

All integral calculations are performed on an `int` or larger type. If any of operands is smaller (`char` or `short`) it's first *promoted* to a larger type.

Floating-point calculations may have higher accuracy than their types. For example, on x86 and x86_64 `double` occupies 8 bytes (64 bits) but the relevant processor part uses 80-bit registers when doing the math.

## unary plus and minus

`-a` flips the sign of an integer or foating-point number.

```c++
#include <iostream>

int main()
{
    int x = 10;
    std::cout << "x = " << x << "\n";
    x = -x; // unary minus
    std::cout << "x = " << x << "\n";

    double d = 3.14;
    std::cout << "d = " << d << "\n";
    d = -d; // unary minus
    std::cout << "d = " << d << "\n";
}
```

```
x = 10
x = -10
d = 3.14
d = -3.14
```

`+a` for integers and floating-point numbers doesn't do anything. It exists for consistency with unary minus, but because operators can be overloaded someone might find a use for them.

`+a` can be used to force promotion from `char` to `int` if it's desirable - this works because C++ mandates that all calculations are performed on `int` or larger type.

```c++
#include <iostream>

int main()
{
    char a = 65;
    std::cout << "a = " <<  a << "\n"; // print as character
    std::cout << "a = " << +a << "\n"; // print as integer
}
```

```
a = A
a = 65
```

## multiplication

`a * b` works as expected but if you multiply too large numbers and the result does not fit an *overflow* will happen. Explained later in this chapter.

## division

While machine instructions for all arithmetic operators are different depending on argument types, division has also different behaviour.

**Floating-point division** behaves intuitively, but there are few important aspects:

- `a / 0.0` depending on the sign of `a`  will result in positive or negative infinity
- `(a / b) * b` may not yield back exactly `a` - floating-point calculations have limited accuracy

**Integer division** has different aspects:

- there are no fractions: `7 / 2` is `3`, not `3.5` (result is always rounded down)
- division by `0` is undefined behaviour (integers do not support special values like infinity or NaN)

```c++
#include <iostream>

int main()
{
    int a = 13;
    int b = 3;
    std::cout << "integer division: " << a / b << "\n";
    double x = 13.0;
    double y = 3.0;
    std::cout << "floating-point division: " << x / y << "\n";
}
```

```
integer division: 4
floating-point division: 4.33333
```

TODO important note

<div class="note warning">
Floating-point division by 0 results in infinities but dividing integers by 0 is undefined behaviour.
</div>

## modulus

`%` obtains the rest that results in integer division. `%` works only with integers.


```c++
#include <iostream>

int main()
{
    int dividend = 100;
    int divisor = 7;

    int quotient = dividend / divisor;
    std::cout << "quotient: " << quotient << "\n";
    int remainder = dividend % divisor;
    std::cout << "remainder: " << remainder << "\n";

    std::cout << "remainder + divisor * quotient: " << remainder + divisor * quotient << "\n"; 
}
```

```
quotient: 14
remainder: 2
remainder + divisor * quotient: 100
```

TODO check if LaTeX below renders correctly.

In other words, $100 / 7 = 14$ and $100\space\%\space7 = 2$ so $2 + 14 * 7 = 100$.

## short versions

All of operators above can be shortened when combined with assignments

TODO pre/code for table below

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>full expression</th>
                <th>short version</th>
                <th>description</th>
            </tr>
            <tr>
                <td>a = a + b</td>
                <td>a += b</td>
                <td>increase a by b</td>
            </tr>
            <tr>
                <td>a = a - b</td>
                <td>a -= b</td>
                <td>decrease a by b</td>
            </tr>
            <tr>
                <td>a = a * b</td>
                <td>a *= b</td>
                <td>multiply a by b</td>
            </tr>
            <tr>
                <td>a = a / b</td>
                <td>a /= b</td>
                <td>divide a by b</td>
            </tr>
            <tr>
                <td>a = a % b</td>
                <td>a %= b</td>
                <td>modulo a by b</td>
            </tr>
        </tbody>
    </table>
</div>
