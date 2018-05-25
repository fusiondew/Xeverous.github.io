---
layout: article
---

In previous lessons, you have learned how to create and use fixed size arrays. Now it's time to see how they work under the hood!

## continuous storage

Arrays are stored in consecutive memory blocks.

```
                    v 0x7ffd8ddc0538                v 0x7ffd8ddc0540
--+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+--
  |     arr[0]    |     arr[1]    |     arr[2]    |     arr[3]    |     arr[    
--+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+--
    ^ 0x7ffd8ddc0534                ^ 0x7ffd8ddc053c                ^ 0x7ffd8ddc0544
```

We can use pointers to move across them.

## array start

You can set a pointer to point to an array.

```c++
int arr[10];
int* ptr = arr; // set the pointer to (the start) of this array
```

TODO &arr\[0\]

## pointer arithmetics

We can iterate over an array using pointers.

```c++
#include <iostream>

int main()
{
    const int arr_size = 10;
    int arr[arr_size];

    // make the array hold { 0, 10, 20, 30, ... }
    for (int i = 0; i < arr_size; ++i)
        arr[i] = i * 10;

    // conventional array print
    for (int i = 0; i < arr_size; ++i)
        std::cout << arr[i] << " ";

    std::cout << "\n";
    const int* ptr = arr;

    // print using a pointer
    for (int i = 0; i < arr_size; ++i)
        std::cout << *(ptr + i) << " ";
}
```

It works because we add the value of `i` to the array start address and then dereference it. `i` in the first step is `0` - this is the core reason why arrays of N elements use \[0, N-1\] indexing (not \[1, N\]) - such indexing matched underlying math which is performed on memory addresses to access the values.

The most important thing here is that `sizeof(int)` is likely not `1` (it's `4` on most systems), but still expression `ptr + 1` moves it by 4 bytes, not 1. We can check it by printing the pointer values:

```c++
#include <iostream>

int main()
{
    const int arr_size = 10;
    int arr[arr_size];

    // make the array hold { 0, 10, 20, 30, ... }
    for (int i = 0; i < arr_size; ++i)
        arr[i] = i * 10;

    const int* ptr = arr;
    for (int i = 0; i < arr_size; ++i)
    {
        std::cout << "address: " << ptr + i << " value: " << *(ptr + i) << "\n";
    }
}
```

~~~
address: 0x7ffebd80ff20 value: 0
address: 0x7ffebd80ff24 value: 10
address: 0x7ffebd80ff28 value: 20
address: 0x7ffebd80ff2c value: 30
address: 0x7ffebd80ff30 value: 40
address: 0x7ffebd80ff34 value: 50
address: 0x7ffebd80ff38 value: 60
address: 0x7ffebd80ff3c value: 70
address: 0x7ffebd80ff40 value: 80
address: 0x7ffebd80ff44 value: 90
~~~

The pointer values increase by `4`, even though the `i` increases by `1` in the loop.

Now test it with some different type:

```c++
#include <iostream>

int main()
{
    const int arr_size = 10;
    long long arr[arr_size];

    // make the array hold { 0, 10, 20, 30, ... }
    for (int i = 0; i < arr_size; ++i)
        arr[i] = i * 10ll; // 10 is long long for absolute correctness

    const long long* ptr = arr;
    for (int i = 0; i < arr_size; ++i)
    {
        std::cout << "address: " << ptr + i << " value: " << *(ptr + i) << "\n";
    }
}
```

```
address: 0x7fff68a43bb0 value: 0
address: 0x7fff68a43bb8 value: 10
address: 0x7fff68a43bc0 value: 20
address: 0x7fff68a43bc8 value: 30
address: 0x7fff68a43bd0 value: 40
address: 0x7fff68a43bd8 value: 50
address: 0x7fff68a43be0 value: 60
address: 0x7fff68a43be8 value: 70
address: 0x7fff68a43bf0 value: 80
address: 0x7fff68a43bf8 value: 90
```

This program was obviously run in a different memory location but it's not the concern here. Notice that this time the addresses increase by 8.

The both examples showcase the fundamental rule of **pointer arithmetics** - adding an integer to a pointer can move it forward multiple bytes - specifically `sizeof(pointed type)` bytes.

In the first example it was `4` because it is equal to `sizeof(int)`.

In the second example it was `8` because it is equal to `sizeof(long long)`.

Note: you may get different results on different systems. These examples were run on 64-bit PC on which `int` occupies 4 bytes (32 bits) and long long occupies 8 bytes (64 bits).

TODO def block

<div class="note success">
#### pointer aritchmetics

Adding (or subtracting) an integer to (or from) a pointer moves it forward (or backward) `sizeof(pointed type)` bytes.

- Adding `x` to `int*` will add to it's address `x * sizeof(int)`.
- Adding `x` to `long*` will add to it's address `x * sizeof(long)`.
- Adding `x` to `long long*` will add to it's address `x * sizeof(long long)`.
</div>

Pointer arithmetic rules make it easy to move across the arrays - by adding `i` to a pointer, you know it will move `i` elements forward and you don't have to care how many bytes in memory each element occupies.

## subscript on pointers

The subscript operator (`[]`) actually works on pointers. When you do `arr[i]` in fact the `arr` is first (implicitly) converted to a pointer, then the operator is applied on it.

```c++
#include <iostream>

int main()
{
    const int arr_size = 10;
    int arr[arr_size];

    // make the array hold { 0, 10, 20, 30, ... }
    for (int i = 0; i < arr_size; ++i)
        arr[i] = i * 10;

    const int* ptr = arr;

    // print using pointer arithmetics
    for (int i = 0; i < arr_size; ++i)
        std::cout << *(ptr + i) << " ";

    std::cout << "\n";

    // print using subscript operator
    for (int i = 0; i < arr_size; ++i)
        std::cout << ptr[i] << " ";
}
```

So in reality the `ptr[i]` syntax is just a short version of `*(ptr + i)`. The subscript also works on arrays because they can be implicitly converted to the starting address.

You can also do the dereferencing on the array:

```c++
    for (int i = 0; i < arr_size; ++i)
        std::cout << *(arr + i) << " ";
```

#### Question: So what's the difference between an array and a pointer?

Technically, they are different types. This may seem hard to observe but note that statements such as `int* ptr = arr` are performing implicit convertions (here from `int[10]` to `int*`).

The other difference is that an array knows it's size. In the example above, `arr` is of type `int[10]` but `ptr` is of type `int*`. The array type knows where it starts in memory and how many elements it has, the pointer knows only the start place in memory.

`sizeof(arr)` gives the size (in bytes) of the memory occupied by all elements of the array (size of the entire block).

`sizeof(ptr)` gives the size of the pointer in memory (4 bytes on 32-bit systems, 8 bytes on 64-bit systems).

