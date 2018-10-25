---
layout: article
---

Comparisons should be very intuitive:

TODO pre/code for table below

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>expression</th>
                <th>mathematical meaning</th>
                <th>description</th>
            </tr>
            <tr>
                <td>a == b</td>
                <td>$a = b$</td>
                <td>equal</td>
            </tr>
            <tr>
                <td>a != b</td>
                <td>$a \ne b$</td>
                <td>not equal</td>
            </tr>
            <tr>
                <td>a < b</td>
                <td>$a \lt b$</td>
                <td>less than</td>
            </tr>
            <tr>
                <td>a > b</td>
                <td>$a \gt b$</td>
                <td>greater than</td>
            </tr>
            <tr>
                <td>a >= b</td>
                <td>$a \geq b$</td>
                <td>greater or equal</td>
            </tr>
            <tr>
                <td>a <= b</td>
                <td>$a \leq b$</td>
                <td>less or equal</td>
            </tr>
        </tbody>
    </table>
</div>

All of these expressions result in a value of type `bool`.

## floating-point comparisons

They work, but floating-point numbers are rarely equal due to their limited accuracy.

```c++
#include <iostream>

int main()
{
    double x = 0.1;
    double y = 0.2;

    if (x + y == 0.3)
        std::cout << "equal\n";
    else
        std::cout << "not equal\n";
}
```

~~~
not equal
~~~

Floating-point numbers are very rarely compared for equality. If such comparison is desired, computation result is usually checked whether it falls in certain range. The minimum supported difference between two values is named *epsilon*.

Unfortunately the error margin is dependent on the calculations and it grows after each operation. Solutions like `result >= 0.3 - epsilon or result <= 0.3 + epsilon` are not correct either.

There is a [fully correct floating-point range comparison example](https://en.cppreference.com/w/cpp/types/numeric_limits/epsilon) but it's far to complicated to explain at this point.

Just remember: do not expect floating-point values to be equal.
