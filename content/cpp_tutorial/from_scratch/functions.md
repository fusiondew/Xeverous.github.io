---
layout: article
---

Our journey starts from math. I assume you know what a *function* term means in math. In programming it's very similar.

**A function is a reusable piece of code which may have input parameters and output some value** It's a mapping from input to output.

Let's use a very simple quadratic function:

TODO make it LaTeX

```
f(x) = x^2
```

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

So how this function is used? It's surprisingly very similar:

TODO LaTeX

```
x = 5
y = f(x)
```

```c++
int x = 5;
int y = f(x);
```

The difference is that since we are using strongly typed language both `x` and `y` have to be given types - the compiler need to know we are working on numbers. The other thing you may have noticed is that statements end in `;`. This is a very normal thing is tons of programming languages - just like human language sentences end in `.` the programming sentences end in `;`.

#### Question: Why ; and not .?

Part of the reason is history and the other thing is that `.` has other purposes (eg writing fractional numbers: `3.14`).