---
layout: article
---

Most common operators from math such as $+\space-\space*\space/$ work intuitively as expected. However, C++ offers much more than these.

This article briefly goes over most important parts of operators. You don't have to remember all examples, just understand the concepts.

The full reference table, with all operators, their precedence and arity is at the end of this chapter.

## arity

One of key aspects of operators is their **arity**. This states how many objects they operate on

<div class="table-responsive">
    <table class="table table-bordered table-dark">
        <tbody>
            <tr>
                <th>arity name</th>
                <th>arguments</th>
                <th>example</th>
            </tr>
            <tr>
                <td>nullary</td>
                <td>0</td>
                <td>()</td>
            </tr>
            <tr class="even">
                <td>unary</td>
                <td>1</td>
                <td>!a</td>
            </tr>
            <tr>
                <td>binary</td>
                <td>2</td>
                <td>a + b</td>
            </tr>
            <tr>
                <td>ternary</td>
                <td>3</td>
                <td>a ? b : c</td>
            </tr>
        </tbody>
    </table>
</div>

You don't have now to understand exactly what `!a` or `a ? b : c` does, but you should remember the names.

Note: some operators may have multiple arities. For example `a - b` uses binary minus which is a subtraction, but `-a` uses unary minus which flips the sign of an integer.

## evaluation order

Most operators evaluate from left to right. This means that $a + b + c$ is processed as $(a + b) + c$, not $a + (b + c)$. Of course for addition it doesn't matter, but there are operators for which it will.

Assignment operators (`=`, `+=`, `<<=` and similar construts) evaluate from right to left: `a = b` first reads `b`, then saves it to `a`. This means that $a = b = c$ is processed as $a = (b = c)$.

## precedence

Some operators have higher priority than others. Obviously $a + b * c$ is processed as $a + (b * c)$ but C++ offers more than 40 (or 60+ depending how it's counted) operators so things can get complicated once multiple very different operators are used in one expression.

<div class="note pro-tip">
#### Intuitive code
<i class="fas fa-star-exclamation"></i>
No one remembers precedence order of all possible operators. Code should be easy to read and understand, therefore it's highly recommended to wrap complex subepressions in parentheses

```
 a +   b * c  % d   ^  e & f
(a + ((b * c) % d)) ^ (e & f)
```

Long or very complex expressions should be split into multiple statements, giving each intermediate value meaningful name.
</div>

If multiple operators with the same precedence are used within the same statement, they are processed from left to right.

## overloading

C++ allows to define custom types (classes) and then overload operators for them giving unique behaviour.

In fact, you have already seen an example of this: `std::cout << "text"` uses overloaded opertor `<<` - the default behaviour is to perform bit shifts, not output text.

Defining operator overloads for custom types requires far more knowledge than at this chapter - for now, just remember that this is possible.

## style

It's intuitive for unary operators to have higher priority than binary operators: `a + !b` is processed as `a + (!b)`. While whitespace characters doesn't matter in this case, it's highly recommended to write spaces around binary operators but stick unary operators to their arguments.

```c++
// bad
a+!b +c
a + ! b + c
a +! b+c
// good
a + !b + c
```
