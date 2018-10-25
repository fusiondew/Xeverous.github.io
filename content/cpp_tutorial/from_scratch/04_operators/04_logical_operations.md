---
layout: article
---

Logical operations are the simplest possible operations that can be performed on a single bit. These operations are referred to *boolean algebra* which was studied by George Boole and first introduced in his book in 1847 - a century before computers existed.

Boolean algebra allows only 2 values: **false** and **true**. It can also be viewed as a single bit (0 or 1).

## basic operations

- AND (conjunction) (logical product) - result is true only **if both** operands are true
- OR (disjunction/alternation) (logical sum) - result is true **if at least one** of operands is true
- NOT (negation) - flips the value of operand

AND and OR are binary operators. NOT is unary.

**Truth tables** for basic boolean operations:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>x</th>
                <th>y</th>
                <th>x AND y</th>
                <th>x OR y</th>
            </tr>
            <tr>
                <td>0</td>
                <td>0</td>
                <td>0</td>
                <td>0</td>
            </tr>
            <tr>
                <td>0</td>
                <td>1</td>
                <td>0</td>
                <td>1</td>
            </tr>
            <tr>
                <td>1</td>
                <td>0</td>
                <td>0</td>
                <td>1</td>
            </tr>
            <tr>
                <td>1</td>
                <td>1</td>
                <td>1</td>
                <td>1</td>
            </tr>
        </tbody>
    </table>
</div>

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>x</th>
                <th>NOT x</th>
            </tr>
            <tr>
                <td>0</td>
                <td>1</td>
            </tr>
            <tr>
                <td>1</td>
                <td>0</td>
            </tr>
        </tbody>
    </table>
</div>

AND can also be viewed as $min(x, y)$ operation and OR as $max(x, y)$.

In C and C++:

- AND is represented by `&&`
- OR is represented by `||`
- NOT is represented by `!`

```c++
#include <iostream>

int main()
{
    bool a = true;
    bool b = true;
    bool c = a && b;  // true AND true = true
    bool d = a || b;  // true OR  true = true
    bool e = !a && b; // NOT true AND true = false AND true = false
    bool f = !a || b; // NOT true OR  true = false OR  true = true
    std::cout << std::boolalpha;
    std::cout << "true  AND true = " << c << std::endl;
    std::cout << "true  OR  true = " << d << std::endl;
    std::cout << "false OR  true = " << e << std::endl;
    std::cout << "false AND true = " << f << std::endl;
}
```

~~~
true
true
true
false
~~~

## secondary operations

These operations are composed from basic ones:

- IMPL (implication) - if x is true then the result is the value of y, if x is false the result is always true
- XOR (exclusive OR) - result is true if both operands are different
- NXOR - negated XOR

<br>

- x IMPL y = NOT x OR y
- x XOR y = (x OR y) AND NOT(x AND y)
- x NXOR y = NOT(x XOR y)

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>x</th>
                <th>y</th>
                <th>x IMPL y</th>
                <th>x XOR y</th>
                <th>x NXOR y</th>
            </tr>
            <tr>
                <td>0</td>
                <td>0</td>
                <td>1</td>
                <td>0</td>
                <td>1</td>
            </tr>
            <tr>
                <td>0</td>
                <td>1</td>
                <td>1</td>
                <td>1</td>
                <td>0</td>
            </tr>
            <tr>
                <td>1</td>
                <td>0</td>
                <td>0</td>
                <td>1</td>
                <td>0</td>
            </tr>
            <tr>
                <td>1</td>
                <td>1</td>
                <td>1</td>
                <td>0</td>
                <td>1</td>
            </tr>
        </tbody>
    </table>
</div>

There is no direct support for these operations in the language (they are very rarely needed).
