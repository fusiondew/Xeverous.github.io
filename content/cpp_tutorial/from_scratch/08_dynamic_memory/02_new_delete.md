---
layout: article
---

The first C++ abstractions that make allocation easier are operators `new` and `delete`.

Similarly to C functions, they work in pairs. They do not solve all problems with allocation but make it somewhat more convenient.

## syntax

TODO make it HTML

```
::(optional) new (placement_params)(optional) (type) initializer(optional)
::(optional) new (placement_params)(optional) type initializer(optional)
```

short comparison example:

```c++
int n = /* ... */;

int* p1 = static_cast<int*>(std::malloc(n * sizeof(int))); // cast is necessary because malloc returns void*
std::free(p1); // no cast here because int* can be implicitly converted to void*

int* p2 = new int[n]; // no sizeof, no casting (type safety), initialization
delete[] p2;
```

## full description

- `::` is allowed as a way to force global lookup. In such situation, overloaded new would be ignored and standard one would be used.

- `placement_params` - placement-new is something different - it does not allocate but constructs objects in-place instead. Also here, some additional information can be put to customize allocation (alignment, no-throw tag, placement pointer)

New-expression has important difference - if allocation fails, istead of returning a null pointer it throws an exception. Since exceptions were not yet covered, examples use placement parameter `std::nothrow` which causes new to behave like `malloc()` (in case of allocation failure null pointer is returned).

- `type` - should be obvious. Can be put in parentheses for readability and to solve parsing problems (nested pointers and functions pointers would create some ambiguities).

If a plain type is created such as `int`, it has to be deleted with `delete`. If an array type is created such as `int[n]`, it has to be deleted with `delete[]`.

`malloc()` + `free()` pairs should not be mixed with `new` + `delete` pairs or `new[]` + `delete[]` pairs.

- `initializer` - the initial value for each object. If not provided, objects are default-constructed (for integers it means they will be zero).

## advantages over C functions

- new-expression allocates memory for N objects of given type, not bytes - no need for calculating size
- new-expression is type-safe - no void pointers, no casting
- new-expression initializes data - `malloc()` is usually followed by an initializing loop, there is `calloc()` but it offers only zero-initialization while new-expression allows any initial value
- new-expression is actually an operator and can be overloaded - this provides convenience when implementing custom allocations

## full example

TODO test

```c++
#include <iostream>
#include <new> // needed for std::nothrow

int main()
{
    int n;
    std::cout << "How many numbers would you like to type? ";
    std::cin >> n;
    int* ptr = new (std::nothrow) int[n];

    if (ptr == nullptr)
    {
        std::cout << "Error: memory could not be allocated";
    }
    else
    {
        for (int i = 0; i < n; ++i)
        {
            std::cout << "Enter number: ";
            std::cin >> ptr[i];
        }

        std::cout << "You have entered: ";
    
        for (int i = 0; i < n; ++i)
            cout << ptr[i] << ", ";
    
        delete[] ptr;
    }
}
```

## problems with new

New expression solves these problems:

- initialization of allocated memory
- type safety

New-expression still shares some dangers with C allocation functions:

- it's easy to forget to detele (memory leak)
- it's easy to delete twice (undefined behaviour)
- `delete[]` can be mistakenly written as `delete` causing undefined behaviour


Allocating with `malloc()` and freeing with `delete` or allocating with `new` and freeing with `free()` is undefined behaviour - allocation methods should not be mixed.

Nonetheless, new is still an improvement over C allocation functions (it brings type safety and some customizations) but it's not the end - there are far better abstractions. These abstractions require to understand classes.
