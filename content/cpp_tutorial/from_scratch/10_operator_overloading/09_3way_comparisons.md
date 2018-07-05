---
layout: article
---

<div class="note info">
This lesson describes feature added in C++20
</div>

## defaulted comparisons

Since C++20 it's possible to default comparison just like ctor/dtors.

```c++
struct package
{
    int floor;
    int shelf;
    int position;
    double weight;

    // note the return type
    auto operator<=>(const package& rhs) const = default;
};
```

New operator `<=>` represents 3-way comparison and behaves similarly to string compare function.

It has it's own language rules and can be safely declared as member function.

Compiler automatically generates all other comparison operators. By default all members of the type are compared in order of their appearance.

`<=>` operator can also be used directly: `if ((a <=> b) < 0)`. The return type of `<=>` can only be compared with literal `0` or specific relational terms.

## custom comparisons

When default semantics are not suitable (order/amount of compared members), `<=>` operator can be defined with specific return type and custom implementation.

### ordering

These should be obvious (applicable any objects of the same type):

- `x < x` is always `false` (irreflexivity).
- if `x < y` is `true` then `y < x` is `false` (asymmetry).
- if `x < y` and `y < z` then `x < z` (transitivity).
- either `x < y` or `x > y` or `x == y`

The above rules form **strong ordering**.

A type that implements strong ordering should compare all of it's members - otherwise substitutability can be compromised (operator `==` returns `true` but some member variables can be different). If this is the case then it's **weak ordering**. If some values can not be compared (for various reasons) then it's **partial ordering**.

#### mathematical example

Given a set of numbers:

$$
S = \{ 1, 3, -7, 5, 10, -13, 8 \}
$$

we can sort it using various methods that implement different ordering guarantees:

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>sorting function</th>
                <th>result</th>
                <th>term</th>
            </tr>
            <tr>
                <td>$f(x) => x$</td>
                <td></td>
                <td>strong ordering</td>
            </tr>
                <td>$g(x) => abs(x)$</td>
                <td></td>
                <td>weak ordering</td>
            </tr>
            <tr>
                <td>$h(x) => \sqrt{x}$</td>
                <td></td>
                <td>partial ordering</td>
            </tr>
        </tbody>
    </table>
</div>
