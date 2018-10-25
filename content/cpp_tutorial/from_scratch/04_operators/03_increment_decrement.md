---
layout: article
---

Instructions such as `a += 1` can be shortened even further - changing value by 1 is a common operation in programming. It has received it's own special operators: unary `++` and unary `--`.

The other ways to write `c = c + 1` or `c += 1` is to write `++c` or `c++`.

TODO trivia/history box

The `++` and `--` operators appeared already in early C. A new, more advanced language was forming but had no widely recognizable name ("C with classes" was too long, "new C" was't precise). The current name is credited to Rick Mascitti who in 1983 came up with the idea to use C++ as a symbolic improvement over C.

## post-increment

The post-increment operator performs assignment but returns old value - the result is visible at the next statement.

```c++
#include <iostream>

int main()
{
    int x = 10;
    std::cout << x++ << "\n"; // performs assignment, but returns old value
    std::cout << x << "\n";
}
```

```
10
11
```

## pre-increment

The addition is performed instantly. The result is visible at the same statement.

```c++
#include <iostream>

int main()
{
    int x = 10;
    std::cout << ++x << "\n";
    std::cout << x << "\n";
}
```

```
11
11
```

## decrement

Operator `--` works exactly the same way, it just subtracts 1 instead of adding.

## recommendation

Anywhere where a simple +/- 1 is needed, prefer pre- increment/decrement - they happen instantly - the hidden delay can cause misleading code or problems in understanding actions order.

Don't use multiple increments on the same line:

```c++
int i = 10;
int j = i++ + ++i + i++;
```

`j` has unspecified value because compiler is requested to change value of `i` multiple times in one statement.

## exercise

Test various pre/post increments/decrements if you have any doubts. Later, in functions chapter a more in-depth explanation will be given as these operators can also be implemented as functions - you will see actual underlying code.
