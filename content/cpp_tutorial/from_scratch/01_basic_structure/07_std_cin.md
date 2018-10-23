---
layout: article
---

`std::cin` is an **i**nput **stream** (a globally accessible object of type `std::istream`). It can be used to extract data from system's **c**haracter **in**put stream. For most systems, this simply means you can read data from the keyboard terminal.

`std::cin` uses operator `>>` (it reads to variables, `<<` is used for output). It can read to various data types.

Example:

```c++
#include <iostream>

int main()
{
    std::cout << "Enter a number: ";
    int x;
    std::cin >> x;
    std::cout << "You have entered: " << x;
}
```

You can chain reads too. Just like with `<<` operands are processed from left to right.

```c++
#include <iostream>

int main()
{
    std::cout << "Enter 2 numbers\n";
    int x;
    int y;
    std::cin >> x >> y; // x is read first, then y
    std::cout << "x = " << x << "\n";
    std::cout << "y = " << y << "\n";
}
```

TODO check these programs

Because `std::cin` uses formatted input, it may fail. Try to input something that is not a number in the examples above.

#### Question: Can I ask for input and output on the same code line?

No. You will need 2 different statements. Technically it is possible, but many standard streams are divided into input and output which makes it impossible (most streams perform operations in one direction).

### exercise

Nothing this time. You need to learn data types first and some other stuff in order to create interactive (user input dependent) programs.

Later, there will be a detailed terminal input/output guide.
