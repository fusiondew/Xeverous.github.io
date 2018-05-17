---
layout: article
---

Instructions such as `a += 1` can be shortened even further - changing value by 1 is a common operation in programming. It has received it's own special operators - unary `++` and unary `--`.

The other way to write `c = c + 1` or `c += 1` is to write `c++`.

TODO trivia/history box

The `++` and `--` operators exist since they first appeared in C language. A new, more advanced language was forming but had no widely recognizable name ("C with classes" was too long, "new C" was't precise). The current name is credited to Rick Mascitti who in 1983 came up with the idea to use C++ as a symbolic improvement over C.

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

