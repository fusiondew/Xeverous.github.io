---
layout: article
---

`sizeof` is an operator which is a keyword. It returns the size (in bytes) of the argument.

```c++
#include <iostream>

int main()
{
    std::cout << "size of bool       : " << sizeof(bool)        << "\n";
    std::cout << "size of int        : " << sizeof(int)         << "\n";
    std::cout << "size of unsigned   : " << sizeof(unsigned)    << "\n";
    std::cout << "size of long       : " << sizeof(long)        << "\n";
    std::cout << "size of long long  : " << sizeof(long long)   << "\n";
    std::cout << "size of char       : " << sizeof(char)        << "\n";
    std::cout << "size of char16_t   : " << sizeof(char16_t)    << "\n";
    std::cout << "size of char32_t   : " << sizeof(char32_t)    << "\n";
    std::cout << "size of wchar_t    : " << sizeof(wchar_t)     << "\n";
    std::cout << "size of float      : " << sizeof(float)       << "\n";
    std::cout << "size of double     : " << sizeof(double)      << "\n";
    std::cout << "size of long double: " << sizeof(long double) << "\n";
}
```

Results for standard 64-bit Unix system:

~~~
size of bool       : 1
size of int        : 4
size of unsigned   : 4
size of long       : 8
size of long long  : 8
size of char       : 1
size of char16_t   : 2
size of char32_t   : 4
size of wchar_t    : 4
size of float      : 4
size of double     : 8
size of long double: 16
~~~

Parentheses are not necessary:

```c++
std::cout << "size of int: " << sizeof int << "\n";
```

but still recommended (to avoid problems in more complex expressions).

This operator can also take objects:

```c++
int x;
std::cout << "size of x: " << sizeof(x) << "\n";
```

- `sizeof` can not be applied to type `void`, *bit-fields* and functions
- `sizeof` can not be applied to *incomplete types* (because they do not provide all information)
- `sizeof(char)`, `sizeof(unsigned char)` and `sizeof(signed char)` is always `1`
- `sizeof` anything is never smaller than `1`

## size type

The type of value returned by `sizeof` operator is not `int` but `std::size_t` (size type). It is an alias to the widest possible unsigned integer type on the given platform (usually `unsigned long long`).

## size of structures

Size of structures is not necessarily a sum of sizes of each element.

**Padding** - for performance reasons, compilers insert unused space between variables, for example:

```c++
// assuming sizeof(int) == 4

struct foo
{
    int x;  // 4 bytes
    char c; // 1 byte
            // hidden 3 unused bytes
    int y;  // 4 bytes
};

// sizeof(foo) == 12 (3 x 4), not 9 (4 + 1 + 4)
```

Padding increases memory usage but simplifies layout: both integers are separated by the size of an integer. Structures without such padding would complicate memory read and write instructions. Moving by a multiple of size of element simplifies instructions.

## applications

`sizeof` is not used very often but comes handy where there are low-level memory operations and platform-independent code is needed.
