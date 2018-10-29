---
layout: article
---

In previous lesson you saw that it's possible to create a buggy program that never finishes - there were 2 functions calling each other. In some cases, it would never end (in reality it ends with a crash once the processor stack limit is reached - you might need to wait really long for it though).

There is also a special case of such calling - recursion.

## recursion

> To understand recursion, you must first understand recursion.

This popular joke is kinda self explanatory - recursion happens when something is referring to itself.

### factorial

The simplest example is factorial:

$$
x! = \prod_{k = 1}^{x} k = 1 * 2 * 3 * ... * (x - 2) * (x - 1) * x
$$

which can also be defined using recursion:

$$
x! =
\begin{cases}
1 & : x = 0\\
x * (x - 1)! & : x > 0
\end{cases}
$$

Notice how $!$ appears both on the left and the right side? The factorial function is calling itself.

$$
4! = 4 * 3! = 4 * 3 * 2! = 4 * 3 * 2 * 1! = 4 * 3 * 2 * 1 * 0! = 4 * 3 * 2 * 1 = 24
$$

```c++
int factorial(int x)
{
    if (x <= 0)
        return 1;
    else
        return x * factorial(x - 1);
}
```

The factorial function domain are non-negative integers, but there is no way to prevent negative numbers from being passed in - in this case I just used `<=` to return `1` to avoid **infinite recursion**.

<div class="note info">
Recursive functions do not need forward declarations.
</div>

```c++
#include <iostream>

int factorial(int x)
{
    if (x <= 0)
        return 1;
    else
        return x * factorial(x - 1);
}

void info(int x)
{
    std::cout << x << "! = " << factorial(x) << "\n";
}

int main()
{
    info(0);
    info(1);
    info(2);
    info(3);
    info(10);
    info(15);
}
```

Note: too big inputs may cause factorial result to be out of integer range. You will likely get overflowed inetegers (big negative numbers). You can extend the range by using `long long` but factorials grow very fast - above 10, each step means multiplication by more than 10, so each increase means 1 more digit in the result. $20!$ has 19 decimal digits, $100!$ has more than 150.

## Fibonacci sequence

You might have heard already about it - each consecutive number is a sum of 2 previous numbers.

$$
1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ... 
$$

Because each next number (besides first 2) is a sum of 2 previous ones, Fibonacci sequence can also be defined by recursion:

$$
fib(n) =
\begin{cases}
1 & : n = 1\\
1 & : n = 2\\
fib(n - 2) + fib(n - 1) & : n > 2
\end{cases}
$$

In this case 2 base values needs to be given because there is a need for 2 previous values.

```c++
#include <iostream>

int fib(int n)
{
    if (n <= 2)
        return 1;
    else
        return fib(n - 2) + fib(n - 1);
}

int main()
{
    std::cout << "Fibonacci sequence:\n";

    for (int i = 1; i < 15; ++i)
        std::cout << fib(i) << ", ";

    std::cout << "...";
}
```

Sometimes you may see Fibonacci sequence indexed from 0, where the first value is also 0 - this does not change any n-th result but it's more consistent with storing results in arrays and how computers count in general.

$$
fib(n) =
\begin{cases}
0 & : n = 0\\
1 & : n = 1\\
fib(n - 2) + fib(n - 1) & : n > 1
\end{cases}
$$

## recursion vs iteration

All of recursive functions can also be written in iterative form. The iterative form is very often faster because calling a function recursively requires some overhead for each call (pushing return address onto the stack). A good iterative implementation can optimize out redundant calculations - for example $fib(5) = fib(4) + fib(3) = fib(3) + fib(2) + fib(2) + fib(1)$ will need to call $fib(2)$ 3 times and $fib(1)$ 2 times. Since recursion does not save the result anywhere, it's being lost and recomputed every time - iterative form can save some time on storing 2 previous results.

```c++
#include <iostream>

int factorial(int x)
{
    int result = 1;

    for (int i = 2; i <= x; ++i)
        result *= i;

    return result;
}

int fibonacci(int n)
{
    int a = 0;
    int b = 1;

    for (int i = 0; i < n; ++i)
    {
        int temp = b;
        b = a + b;
        a = temp;
    }

    return a;
}

int main()
{
    for (int i = 0; i < 10; ++i)
        std::cout << factorial(i) << "\n";

    for (int i = 0; i < 10; ++i)
        std::cout << fibonacci(i) << "\n";
}
```

Still, in some situations recursive functions perform better (for example in graph search algorithms).

Note that in the program above a lot of computation is still redundant - each call to factorial and fibonacci starts the loop again - if the results for consecutive `i`s were saved (in an array) each next step would just need 1 computation, not the redo from the beginning.

## recursive main

The C++ standard explicitly forbids to call main function. You can not make the program call it's start, although in reality compilers have no problems with such code.

## summary

- recursive function is a function that calls itself
- recursive functions do not require forward declarations
- recursive functions must have some stop condition, otherwise they will never finish
- usually iterative versions of recursive functions are faster
