---
layout: article
---

I assume you know what a *function* term means in math (a mapping from input to output). In programming it's very similar.

TODO def

**A function is a reusable piece of code which may have input parameters and output a value** It's a mapping from input to output.

In this chapter you will mostly learn about **first-order** **stateless** **free** functions.

- **first-order** - this is hard to explain, you will understand this term better when contrasted with **higher-order** functions. First-order functions have no complications.
- **stateless** - just like in math, a stateless function output depends only on it's input. This means that if you input the same argument again, you should always get the same result. Functions do not have state - they do not save anything (unless we use global variables but that's already bad)
- **free** - functions have no further complications. Will be later contrasted with **methods** which are functions that are tied to specific class or hierarchy of classes

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

- `int` is used to indicate return type (on the left) and argument type (inside parentheses); `int` means *integer* - this function works with whole numbers
- the function is named `f` (other names are also possible)
- the function takes 1 argument named `x` which is an `int`eger
- the function *returns* `x` multiplied by `x`

So how this function is used? It's surprisingly very similar to math:

TODO check render

$$
x = 5 \\
y = f(x)
$$

```c++
int x = 5;
int y = f(x);
```

The difference is that since we are using strongly typed language both `x` and `y` have to be given types - the compiler need to know we are working on numbers. As usual, each statement ends with `;`.

## function parts

```c++
//(1) (2)   (3)  
int square(int x)
{ // <- (4)
    int result = x * x;
    return result;
}
```

- (1) - `int` - function return type. Indicates what type of result the function *returns*.
- (2) - `square` - the name of the function
- (3) - `(int x)` - function arguments and their types
- (4) - everything between `{` and `}` - function body. This groups multiple statements

Functions form a reusable pieces of code. Function `square` can be called as many times as wanted without the need to write it's body again.

### return type

Indicates what's the type of the function result. Functions return a result (exactly once) when they reach `return` statement (works similar to `break`).

It's possible not to return anything (return of type `void` - then no return statment is required) and return multiple data in the form of an object (requires knowledge of classes).

The `return` statement can appear multiple times - functions may have multiple execution paths. Any return statement terminates the function.

### name

Just a name that will be used to call the function. Names do not have any restrictions on length - in math functions often have short names, but in programming more descriptive ones are preferred.

### arguments

Functions can take 0+ arguments as their input (any type). In practice, the reasonable amount of arguments is 0 - 6, where 6 is already quite rare. More than this would suggest a need for a refactor.

syntax

```c++
(type1 arg1, type2 arg2, type3 arg3) // and so on...
```

Note that in the case of 0 arguments, `()` still has to be written.

### body

A group of statements. Free function bodies form their own local scope, which is able to access at most global objects. This may seem limiting but it's the core idea and advantage of functions - they do not mess with other code - the output of a stateless free function should depend only on the input

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
    // * is required in C++ - there is no implicit multiplication
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

The function above has no defined return statements for all execution paths. In the case of `x == 0` the flow reaches end of the function without returning - this is **undefined behaviour**. Compilers should warn if they see there is a way through `if`s/`switch`es that does not end in a return statement.

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

## using functions

Functions are simply called by their name and arguments.

```c++
// simples function call
func1(arg1, arg2, arg3)

// nested calls + assignment of the result
int x = func1(arg1, arg2, func2(arg3, arg4));
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
    std::cout << f(x) << "\n";
    std::cout << f(13) << "\n";
    std::cout << f(f(f(3))) << "\n"; 
}
```

## exercise

Write and execute following functions:

$$
f1(x, y, p) = 
\begin{cases}
-x & \text{if } p\\
xy & \text{if not } p \text{ and } x \ne 0\\
y^3 & \text{if not } p \text{ and } x = 0
\end{cases}
$$

Hint: in the above function, `p` should be a parameter of type `bool`. Remember that `^` is not a power operator - at least now you have to write multiplications.

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

Hint: write a helper function retuning absolute value. Note: you might get a name conflict if `abs()` from C happens to be available - use a different name. This is not a bug, but a consequence of implementation-defined header contents (more about it later).

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
        return y * y * y;

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
    return absolute(a) == absolute(b);
}
~~~

</p>
</details>
