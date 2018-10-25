---
layout: article
---

Most common operators from math such as $+\space-\space*\space/$ work intuitively as expected. However, C++ offers much more than these.

This article briefly goes over most important parts of operators. You don't have to remember all examples, just understand the concepts.

The full reference table, with all operators, their precedence and arity is at the end of this chapter.

## arity

One of key aspects of operators is their **arity**. This states how many objects they operate on

TODO pre/code for table below

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>arity name</th>
                <th>arguments</th>
                <th>examples</th>
            </tr>
            <tr>
                <td>nullary</td>
                <td>0</td>
                <td>throw</td>
            </tr>
            <tr class="even">
                <td>unary</td>
                <td>1</td>
                <td>!a, ~a, &amp;a</td>
            </tr>
            <tr>
                <td>binary</td>
                <td>2</td>
                <td>a + b, a * b, a % b</td>
            </tr>
            <tr>
                <td>ternary</td>
                <td>3</td>
                <td>a ? b : c</td>
            </tr>
        </tbody>
    </table>
</div>

You don't have now to understand exactly what `!a` or `a ? b : c` does, but you should remember arity names.

**Note:** some operators may use multiple characters, eg `a && b`, `a->b`.

**Note:** some operators use the same characters but have different arity:

- `c = b - a` uses binary operator which performs subtraction
- `c = -a` uses unary operator which performs negation

## construction

Note the difference between an operator and a character. *Operator* is an abstract term. An operator does not have to be represented by a 1 concrete character (although a lot are).

The simplest operators come from math and are written by 1 character: `+`, `-`, `*`, `/`, `=`, `<`, `>`

A lot of operators in C++ language are written by a combination of 2 (or more) characters: `&&`, `++`, `--`, `>>`, `<<`, `<=>`, `->*`.

Some operators are keywords: `sizeof`, `alignof`, `new`, `delete`, `static_cast`, `dynamic_cast`

This means there is a difference between writing `+ +` vs `++` or `& &` vs `&&`. First two are 2 separate operators `+` and `&`, second are 1 operator `++` and 1 operator `&&`.

`?:` operator characters are not written next to each other but between operands: `a ? b : c`.

`[]` operator is used this way: `a[b]`.

## evaluation order

Most operators evaluate from left to right. This means that $a + b + c$ is processed as $(a + b) + c$, not $a + (b + c)$. Of course it doesn't matter for addition, but there are operators for which it does: `a / b / c`.

Assignment operators (`=`, `+=`, `<<=` and similar construts) evaluate from right to left: `a = b` first reads `b`, then saves it to `a`. This means that $a = b = c$ is processed as $a = (b = c)$ (read c, save it to b, read b, save it to a).

## precedence

Some operators have higher priority than others. Obviously $a + b * c$ is processed as $a + (b * c)$ but C++ offers more than 40 (or 60+ depending how it's counted) operators so things can get complicated once multiple very different operators are used in one expression.

<div class="note pro-tip">
No one remembers precedence order of all possible operators. Code should be easy to read and understand, therefore it's highly recommended to wrap complex subexpressions in parentheses

```c++
 a +   b * c  % d   ^  e & f  // unclear order unless reader remembers all rules perfectly
(a + ((b * c) % d)) ^ (e & f) // complex, but easy to see the order
```

Long or very complex expressions should be split into multiple statements, giving each intermediate value meaningful name.
</div>

## overloading

C++ allows to define custom types (classes) and then overload operators for them giving unique behaviour.

In fact, you have already seen an example of this: `std::cout << "text"` uses overloaded opertor `<<` - the default behaviour is to perform bit shifts, not output text. Another example would be defining a custom class representing a matrix and then overloading `*` so that it can perform matrix multiplication.

Defining operator overloads for custom types requires far more knowledge than at this chapter - for now, just remember that this is possible.

## spacing

It's intuitive for unary operators to have higher priority than binary operators: `a + !b` is processed as `a + (!b)`. While whitespace characters doesn't matter in this case, it's highly recommended to write spaces around binary operators but stick unary operators to their arguments.

```c++
// bad
a+!b +c [d] <<e
a + ! b + c[ d]<< e
a +! b+c [ d ] << e
// good
a + !b + c[d] << e
```

In other words, if an operator applies to only 1 object (unary), don't put spaces as in `!b`. If it applies to 2 (or more) objects (binary, ternary), write spaces on both sides of the operator as in `b + c`.
