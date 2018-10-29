---
layout: article
---

You probably know what a *function* term means in math (a mapping from input to output). In programming it's very similar.

TODO def

**A function is a reusable piece of code which may have input parameters and output a value** It's a mapping from input to output.

In this chapter you will mostly learn about **first-order** **stateless** **free** functions.

- **first-order** - this is hard to explain, you will understand this term better when contrasted with **higher-order** functions. First-order functions have no complications.
- **stateless** - just like in math, a stateless function output depends only on it's input. This means that if you input the same argument again, you should always get the same result. Functions do not have state - they do not save anything (unless we use global variables but that's already bad)
- **free** - functions have no further complications. Will be later contrasted with **methods** which are functions that are tied to and can only work on objects of specific class or hierarchy of classes

## syntax

Let's use a very simple quadratic function:

$$f(x) = x^2$$

This is how it looks like in C and C++ (written using multiplication to avoid more complex stuff):

```c++
int f(int x)
{
    return x * x;
}
```

There are multiple noticeable things here:

- first `int` is used to indicate **return type** - what is the result of this function
- the function is **name**d `f`; in math functions often have short names, but in programming more descriptive ones are preferred
- the function takes 1 **argument** named `x` which is an `int`eger
- `{` and `}` form **function body**; braces are mandatory even if the body is just 1 statement
- the function uses a **`return` statement** to output it's result

So how this function is used? It's surprisingly very similar to math:

$$
x = 5 \\
y = f(x)
$$

```c++
int x = 5;
int y = f(x);
```

The difference is that since we are using strongly typed language both `x` and `y` have to be given types - the compiler need to know we are working on numbers. As usual, each statement ends with `;`.

## examples

Simplest math functions

$$
abs(x) = |x| =
\begin{cases}
-x & : x < 0\\
 x & : x \ge 0
\end{cases}
$$

```c++
int abs(int x)
{
    if (x < 0)
        return -x;
    else
        return x;
}
```

$$f(x) = x^2 - x$$

```c++
int f(int x)
{
    return x * x - x;
}
```

$$g(x, a, b) = (x + a)(x + b)$$

```c++
int g(int x, int a, int b)
{
    // * is required - there is no implicit multiplication
    // (x + a)(x + b) would only create syntax ambiguities
    return (x + a) * (x + b);
}
```

$$h(x, y, z) = g(-abs(x), f(y), f(z)) - f(x)$$

```c++
int h(int x, int y, int z)
{
    return g(-abs(x), f(y), f(z)) - f(x);
}
```

This function does not return anything, so it's return type is `void`. It just wraps a reusable piece of code.

```c++
void greet()
{
    std::cout << "hello, world\n";
}
```

Void functions do not need any return statement, but they may have one to end prematurely.

```c++
void print(int x)
{
    if (x < 0)
        return;

    std::cout << "x = " << x << "\n";
}
```

The function above does not print anything if the argument is negative.

## missing return

Every function that is declared to return something different than `void` should have a return statement. It's possible to compile a non-void function without a return statement, but a such program will likely not work. Watch out for compiler warnings about missing return statements.

Some functions may have a return statement but still give a warning:

```c++
int func(int x)
{
    if (x < 0)
        return x * x;
    else if (x > 0)
        return 2 * x;
}
```

The function above has no defined return statements for all execution paths. In the case of `x == 0` the flow reaches end of the function without returning - this is **undefined behaviour**. Compilers warn if they see there is a way through `if`s/`switch`es that does not end in a return statement - they just check whether all possible paths hit a return statement.

The solution is simple - and it works for any case - place a return at the end, out of any control flow:

```c++
int func(int x, int y)
{
    if (x < 0)
    {
        if (y + 3 > x)
        {
            switch (y)
                case 0: return x;
                case 1: return y; // ...
                case 2: // ...
                // more complex logic, but no default case
        }
    }
    else if (x > 0)
    {
        if (y == 0)
            // ...
    }

    // at worst case flow reaches here
    // function always returns, even if it omits all if-else blocks
    return x + y;
}
```

## full example

Since it must be known inside the main function what other functions are, they need to be placed before the main function. If `f()` wanted to call any other function, it would need to have them above too.

```c++
#include <iostream>

int f(int x)
{
    return x * x - x;
}

int main()
{
    int x = 5;
    int y = f(x);
    std::cout << f(y) << "\n";
    std::cout << f(13) << "\n";
    std::cout << f(f(f(3))) << "\n"; 
}
```

## C++ standard library functions

- Simplest mathematical functions are provided by `<cmath>` and `<cstdlib>` - [see reference](https://en.cppreference.com/w/cpp/numeric/math) for their list
- [Special mathematical functions](https://en.cppreference.com/w/cpp/numeric/special_math) are available since C++17

## recommendations

- **Name:** describe clearly performed action. Prefer verbs to nouns. Too long name is better than too short.
- **Arguments amount:** there is no hard requirement, but generally the more arguments the more complex (to write and use) function becomes. Functions taking 5+ arguments should be very rare.
- **Body length:** There is no hard requirement. Various sources recommend max 10/25/50/100 lines or "1 screen of code". If you feel a function is too long split it into multiple smaller ones.

## exercise

Write following functions:

$$
f1(x, y, p) = 
\begin{cases}
-x & \text{if } p\\
xy & \text{if not } p \text{ and } x \ne 0\\
y^3 & \text{if not } p \text{ and } x = 0
\end{cases}
$$

`p` should be a parameter of type `bool`. Remember that `^` is bitwise XOR, not a power operator - use multiplication or `std::pow()` from `<cmath>`.

$$
f2(a, b) = 
\begin{cases}
\frac{a + b}{b} & \text{if } b \ne 0\\
\frac{a - b}{a} & \text{if } a \ne 0\\
0 & \text{otherwise}
\end{cases}
$$

Test for `b` first.

$$
f3(a, b) = 
\begin{cases}
\text{true} & \text{if } |a| == |b|\\
\text{false} & \text{otherwise}
\end{cases}
$$

Hint: use a helper function inside - your own or `std::abs()`.

<details>
<summary>
solution (your code might be slightly different)
</summary>
<p markdown="block">

~~~ c++
int f1(int x, int y, bool p)
{
    if (p)
        return -x;

    if (x == 0) // test for x first, because it's easier to read x == 0 than x != 0
        return y * y * y; // or return std::pow(y, 3)

    return x * y; // could also be a part of else block
}

int f2(int a, int b)
{
    if (b != 0)
        return (a + b) / b;

    if (a != 0)
        return (a - b) / a;

    return 0;
}

int absolute(int x)
{
    if (x < 0)
        return -x;
    else
        return x;
}

bool f3(int a, int b)
{
    return absolute(a) == absolute(b); // or return std::abs(a) == std::abs(b)
}
~~~

</p>
</details>
