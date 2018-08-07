---
layout: article
---

There are 2 additional keywords that can be used to modify the flow of any loop (`while`, `do while`, `for`) block.

## break

Similarly to the `break` in `switch`, it terminates execution - in the case of loops ending the loop prematurely.

```c++
#include <iostream>

int main()
{
    for (int i = 0; i < 10; ++i)
    { 
        if (i == 8)
            break;

        std::cout << "i = " << i << "\n";
    }
}
```

The program above prints numbers in range \[0, 7\]. At `i == 8` it enters the `break` statement and terminates the loop.

## continue

`continue` does not terminate the loop, but causes it to ignore next statements in the current iteration.

```c++
#include <iostream>

int main()
{
    int n = 10;
    while (n--)
    {
        // any statement here will always be executed

        if (n % 2 == 0)
            continue;

        std::cout << "n = " << n << "\n";
    }
}
```

Even numbers fall into `continue` and do not execute the print.

```
n = 9
n = 7
n = 5
n = 3
n = 1
```

## exiting nested loops

Sometimes it's desirable to exit a nested loop

```c++
for (int y = 0; y < size_y; ++y)
{
    for (int x = 0; x < size_x; ++x)
    {
        if (something_special_happened)
            // double break???
    }
}
```

Unfortunately `break` exits only the current, most inner loop. There is no way to break out of multiple loops at once. Some languages offer something like `break(2)` but C++ does not have it.

**It could be done with `goto` but it's very heavily discouraged.** There are multiple better alternatives:

- add `bool exit = false;` flag, set it to `true` in the inner loop and place `break`s based on checking this flag - quite verbose and hard to read
- put the loop in a function and `return` from the function - good
- put the loop in a lambda and `return` from the lambda - even better
- `throw` an exception - for more complex code skipping - this will work but it's not an appropriate use of exceptions

### example with the flag

```c++
bool exit = false;
for (int y = 0; y < size_y; ++y)
{
    if (exit)
        break;

    for (int x = 0; x < size_x; ++x)
    {
        if (something_special_happened)
        {
            exit = true;
            break;
        }
    }
}
```

### example with return

```c++
for (int y = 0; y < size_y; ++y)
{
    for (int x = 0; x < size_x; ++x)
    {
        if (something_special_happened)
            return /* what is here depends on the function/lambda type */;
    }
}
```

Recommended solution is to use lambdas or functions. Return statements end entire function or lambda expression.
 