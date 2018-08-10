---
layout: article
---

Just like there are pointers to variables, there are also pointers to functions.

Their syntax is similar to function declaration but uses an asterisk before parenthesised name.

TODO finish article

TODO test code

**Calculator example**

```c++
#include <iostream>

void add(int x, int x)
{
    std::cout << "x + y = " << x + y << "\n";
}

void subtract(int x, int x)
{
    std::cout << "x - y = " << x - y << "\n";
}

void multiply(int x, int x)
{
    std::cout << "x * y = " << x * y << "\n";
}

void divide(int x, int x)
{
    if (y == 0)
    {
        std::cout << "Can not divide by zero!\n";
        return;
    }

    std::cout << "x / y = " << x / y << "\n";
}

void modulo(int x, int x)
{
    std::cout << "x % y = " << x % y << "\n";
}

int main()
{
    std::cout << "Console calculator\n";
    std::cout << "Select an operation:\n"
        "1. addition\n"
        "2. subtraction\n"
        "3. multiplication\n"
        "4. division\n"
        "5. modulus\n";

    int choice;
    std::cin >> choice;

    constexpr int max_options = 5;

    if (choice <= 0 || choice > max_options)
    {
        std::cout << "Wrong choice.\n";
        return 1;
    }

    // array of function pointers
    void (*functions[max_options])(int, int) = {
        &add, &subtract, &multiply, &divide, &modulo
    };

    // choosen function
    void (*func_ptr)(int, int) = functions[choice];

    int x;
    int y;
    std::cout << "Enter x: ";
    std::cin >> x;
    std::cout << "Enter y: ";
    std::cin >> y;

    (*func_ptr)(x, y); // dereference pointer and call function
}
```
