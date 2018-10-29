---
layout: article
---

Sometimes you may want to pass a variable number of arguments. There is a such possibility by using an ellipsis in argument declaration.

The most well-known function to do such thing is `printf` from C standard library.

```c
int printf(const char* fmt, ...);
```

Function takes the string representing the format and a variable amount of arguments that will be used to perform the print.

```c
int x = 10;
float y = 100;
printf("%d %f", x, y); // %d %f %s etc are various formatting options
```

## accessing variadic arguments

Since the number of arguments is not known at compile-time, obtaining them is not so straightforward. **MACROS** are used to access arguments, they all start with `va_` (**v**ariadic **a**rguments).

```c++
typedef /* unspecified */ va_list; // use to create a named object of va_list type
void va_start(va_list ap, parm_n); // read arguments into ap after parameter name parm_n
T va_arg(va_list ap, T); // get next value interpreted as type T from ap
void va_copy(va_list dest, va_list src); // copy variadic arguments
void va_end(va_list ap); // clean up variadic argument list (always required)
```

Short example:

```c++
#include <iostream>
#include <cstdarg>

int add_nums(int count, ...)
{
    int result = 0;
    va_list args;
    va_start(args, count);

    for (int i = 0; i < count; ++i)
        result += va_arg(args, int);

    va_end(args);
    return result;
}

int main()
{
    std::cout << add_nums(4, 25, 25, 50, 50) << '\n';
}
```

## why variadic functions are bad

The purpose of this lesson is not to teach you how to use variadic arguments - they are not a good style. The entire feature is over 30 years old (1987) and at the time of it's creation it's problems were not as apparent as today. Now it's clear that it's a terrible feature and should not ever be used.

Concrete reasons:

- **obscure macros**
- **lowercase macros**
- **type-unaware macros**
- **macros**
- bug-prone access to arguments (macros need to be in certain order)
- bug-prone calls - if more than needed arguments are specified, they are ignored; if less than needed - undefined behaviour
- variadic arguments have the same or worse performance than their alternatives
- variadic arguments undergo implicit convertions
- variadic argument types are restricted (only certain types can be used)
- **variadic arguments can violate type system** - this can easily lead to undefined behaviour
- the behavior of the `va_start` macro is undefined if the last parameter before the ellipsis has reference type, or has type that is not compatible with the type that results from default argument promotions

### better alternatives

- arrays
- `std::initializer_list` - lightweight object holding multiple arguments of common type - explained later
- variadic templates - achieve compile-time well-defined behaviour with strict type safety, they are free of all variadic argument flaws - explained in template tutorial. This is basically the same feature but done the modern C++ way with full type safety

## working with arrays

Very strong convention: **always pass array length**. A pointer alone does not bring enough information - **never assume array length**.

```c++
void print(const int* arr, int length) // 2 arguments, in this order
//         ^^^^^^^^^^^^^^ some people prefer to write const int arr[] instead
{
    std::cout << "printing " << length << " elements:\n";

    for (int i = 0; i < length; ++i)
        std::cout << arr[i] << ", ";

    std::cout << "\n";
}
```

Still, such functions does not take the full power of C++ and are usually written only in C. Soon you will later learn about `std::array` and `std::vector` classes.

```c++
// actual C++
void print(const std::vector<int>& vec)
{
    std::cout << "printing " << vec.size() << " elements:\n";

    for (int x : vec)
        std::cout << x << ", ";

    std::cout << "\n";
}
```

## summary

Scream when you see someone using variadic function arguments. They should learn how to use better alternatives.

```c++
void print(const char* fmt, ...); // prone to undefined behaviour

template <typename... Ts>
void print(Ts&&... ts); // strict type safety
```

## exercise

Write 2 functions: one that will print and one that will double each element of integer array. Start with the code below.

```c++
#include <iostream>

int main()
{
    constexpr int sz1 = 5;
    int arr1[sz1] = { 1, 2, 3, 4, 5 };

    double_array_values(arr1, sz1);
    print_array(arr1, sz1);

    constexpr int sz2 = 10;
    int arr2[sz2] = { -1, 20, -3, 44, 0, 5 };
    arr2[sz2 - 1] = 100;

    double_array_values(arr2, sz2);
    print_array(arr2, sz2);
}
```

<details>
    <summary>solution</summary>
    <p markdown="block">

```c++
void double_array_values(int* arr, int sz)
{
    for (int i = 0; i < sz; ++i)
        arr[i] *= 2;
}

void print_array(const int* arr, int sz)
{
    for (int i = 0; i < sz; ++i)
        std::cout << arr[i] << " ";

    std::cout << "\n";
}
```
</p>
</details>
