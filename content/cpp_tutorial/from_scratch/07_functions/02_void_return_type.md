---
layout: article
---

Sometimes you don't need to perform any calculation, just wrap a reusable piece of code. This usually causes function not to need any return statement.

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
