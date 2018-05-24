---
layout: article
---

## the x, x2, x3 problem

You may already have similar problem in the code - you declare multiple variables, with very similar names. Arrays are to solve it. They group multiple variables of the same type under one name - just make a choice how many of them do you need.

```c++
// bad - duplicated names
int x;
int x2;
int x3;

// good - all in one place
int x_array[3];
```

<div class="note pro-tip">
#### array names

Because arrays hold multiple values at once, it's recommended to use plural forms. `int number[10]` might cause problems in understanding what it represents but `int numbers[10]`  speaks for itself.
</div>

## syntax

This is unfortunately a bad aspect, coming from C - the syntax is a bit weird - the array size is placed next to the name, not to the type.

```c++
// this is how C did it
int arr[10];
// this is how Java, C# and many other strongly typed languages do it
int[10] arr;
```

It's natural to think that `arr` is of type `int[10]` which means that it's an array of 10 integers. The original syntax from C was left in C++ as-is due to backwards compability. The good part is that you will not use the above syntax a lot - in few chapters later you will learn about `std::array` and why `std::array<int, 10> arr` is much better than `int arr[10]`.

Just remember the above fact, plain arrays will not be used a lot because there are better alternatives which use more advanced language features.

## initialization

The intialization syntax is pretty intuitive:

```c++
int arr[5] = { 2, 5, 6, -1, -4 }; 
int arr[5]   { 2, 5, 6, -1, -4 }; // since C++11 you can drop =, but I would not recommend it
```

Note that the brace list can be used **only for initialization**.

```c++
int arr[5];
arr = { 2, 5, 6, -1, -4 }; // will not compile
```

## default initialization

```c++
int arr[5]; // contents are unknown, likely garbage values (uninitialized memory)
int arr[5] = { }; // all values are default-constructed - for integers it means all elements are 0
int arr[5] = { 10, 20, 30 }; // first 3 elements are 10, 20, 30 rest is 0
int arr[5] = { 10, 20, 30, 40, 50, 60 } // error: too many elements
```

## automatic size deduction

It's possible to ommit the size, it will be deduced automatically.

```c++
int arr[] = { 1, 2, 3 }; // array size deduced to 3
```

You can not make arrays of size 0:

```c++
int arr[] = { }; // error: zero-size array
```

You can query the array size by the `sizeof` operator

```c
// such code is commonly seen in C language
int arr[] = { 1, 2, 3 };
int arr_size = sizeof(arr) / sizeof(arr[0]);
```

The trick above uses the fact that the size of an array is equal to it's total memory divided by the size of a single element. Element with index 0 is choosen because every array has at least 1 element.

For example, if an integer occupies 4 bytes in memory, `sizeof(arr) / sizeof(arr[0])` is `12 / 4` which is `3`.

This sizeof trick is commonly seen in C language, some libraries also have a macro for this:

```c
#define ARRAY_SIZE(x) (sizeof(x) / sizeof(x[0]))
int arr[] = { 1, 2, 3 };
int arr_size = ARRAY_SIZE(arr);
```

Previously it was stated that using macros for something different than platform-specific code or include guards is bad. This is still true. All of the above code samples are still just C, which C++ imported for backwards compability. The actual, modern C++ arrays are `std::array` - but if you understand how C arrays work, you will better understand the array class from C++ standard library.

## element access

`arr[N]` where `N` should be a valid integral index (in range \[0, array_size - 1\]). If you input wrong index you will hit a memory location which may not be owned by your program - at best an instant crash, at worst a hidden bug where you read unknown values.

TODO note definition

<div class="note success">
`[]` is called **subscript operator**.
</div>

## iteration

The best way to do something with each element of an array is to write a loop. A `for` loop.

```c++
#include <iostream>

int main()
{
    const int array_size = 5;
    int arr[array_size] = { 1, 2, 3, 4, 5 };

    std::cout << "array before modification: ";

    for (int i = 0; i < array_size; ++i)
        std::cout << arr[i] << " ";

    std::cout << "\n";

    for (int i = 0; i < array_size; ++i)
        arr[i] = arr[i] * 2;

    std::cout << "array after modification: ";

    for (int i = 0; i < array_size; ++i)
        std::cout << arr[i] << " ";

    std::cout << "\n";
}
```

It should be now obvious how useful `for` loop are - they fit very well with arrays

```c++
int arr[arr_size] = { /* ... */ };
for (int i = 0; i < array_size; ++i)
    // do something with arr[i]
```

Remember that the loops have to start at 0 and iterate as long as `i < array_size`. `arr[array_size]` is 1 past the end - if you change `<` to `<=` it will crash.

In the example above, arrays have size `5` and so the loops use `i < 5`. Element `arr[5]` doesn't exist - the loop executes only `[0]`, `[1]`, `[2]`, `[3]` and `[4]`.

## printing array address

You may have tried inputting entire array into 1 print statement.

```c++
int arr[3] = { 3, 1, 4 };
std::cout << arr << "\n"; // no subscript
```

Works but prints something like `0x7fff9ce500a0`. This is not a bug - arrays are closely related to pointers and in this case `arr` was treated like a pointer - the printed value is the memory address of the array. You will learn about this in a couple of lessons.

## variable length arrays

It might be tempting to do something like

```c++
int size; // not const!
std::cin >> size;
int arr[size] = { };
```

This is not a valid C++. Array size, must be a compile-time constant. It is because the array contents are allocated on the stack and the compiler must know the size of memory to allocate - otherwise further instructions fechted in the processor could be skipped and/or started at the wrong place.

The code above *may* compile. Non-constant array size was a feature in C89, but it has been made optional in C99 - it is too dangerous to risk the stack corruption.

<div class="note info">
#### VLAs (variable length arrays)

Dynamic array size was a feature in C89 to potentially boost performance. It was found to be risky due to possible stack corruption and made an optional feature in C99.

Dynamic array size was never a valid code in any C++ standard. If you manage to build such code, you are using compiler-specific non-standard extentions.
</div>

## exercise

- Check what your compiler does for non-constant array size. It should either not compile or output a warning about non-standard-conformant code.
- Write a program asking the user to input values into an array. Then perform any operation on each element and print the array.

TODO solution
