---
layout: article
---

For static duration, thread duration and automatic duration variables, the size of the allocation must be a compile time constant. Compiler must know at compile time what's the size of the object to correctly handle memory. This is why arrays must have a compile-time size.

Even if it's known how much memory is needed, large arrays such as `int[1000000]` may crash. Automatic/static/thread allocation is fast and generally very efficient but the stack is limited - 1 to 8 MB on most dektop systems.

**Dynamic memory allocation** allows few very unique things:
- access to the heap memory (basically the entire RAM)
- ability to allocate and deallocate at any time
- ability to allocate memory blocks of any length

## dynamic memory - C functions

Very basic abstraction, but probably the easiest to understand.

There are 2 core functions:

```c
#include <stdlib.h> // in C++ <cstlib>, functions inside namespace std

void* malloc(size_t size); // memory allocation (size in bytes)
void free(void* ptr);      // memory deallocation
```

`malloc()` allocates `size` bytes of free memory and returns a pointer to the first cell. **Dynamically allocated memory is always a one, continuous block.** If the allocation fails (not enough memory in the system) function returns a null pointer.

Because there is a requirement to always allocate 1 continuous block, allocation may fail even if there is enough free memory in the system - the sum of free regions may be larger than the asked for but there might not exist a block that is sufficiently large.

Allocated memory has no predefined use. You basically can write/read whatever you want in the entire block.

When the memory is no longer needed, the pointer received from `malloc()` should be passed to `free()` so that the operating system can reclaim that block and reuse it for itself or other programs that ask for dynamic memory.

TODO def block

If the program allocates memory but does not free it it's a **memory leak**. If a program does not stop growing it's memory consumption at some point no more memory will be available in the system - usually causing itself (and other programs) to crash.

<div class="note info">
Dynamically allocated memory is not initialized. It's contents are unknown.
</div>

### example

Allocate N integers and then release memory.

```c++
int n = /* something run-time dependent */;

void* const ptr = std::malloc(n * sizeof(int)); // allocate memory for n integers

if (ptr == nullptr)
{
    std::cout << "allocation failed\n";
}
else
{
    std::cout << "allocation succeeded";

    int* p = static_cast<int*>(ptr);
    for (int i = 0; i < n; ++i)
    {
        // use p[i] - note that contents are not initialized
    }

    std::free(p);
}
```

### additional allocation functions

```c
void* aligned_alloc(size_t alignment, size_t size);
void* calloc(size_t num, size_t size);
void* realloc(void* ptr, size_t new_size);
```

`aligned_alloc()` works similar to `malloc()` with the difference that the allocated memory is aligned (it's address is a multiple of `alignment`). Allowed alignment values are system-dependent (POSIX allows `sizeof(void*)` multiplied by powers of 2). This is useful for allocations aiming to use cache more effectively.

`calloc()` works similar to `malloc()` but it zero-initializes the allocated memory. Weird thing is that `malloc()` takes one argument (size in bytes) but `calloc()` takes 2 arguments (number of elements, size in bytes of each element).

`realloc()` reallocates memory to a larger/smaller block. Useful when the program wants to increase the capacity or free some memory but not all of it.

## What is inside `malloc()`

Magic. More precisely, internal operating system implementation of the memory allocation. 

The OS owns all memory - it has no access checks and can access all data freely (no access violations!). OS kernel can dereference any pointer - there is nothing beneath that would prevent it from doing so.

To safely run programs requiring various amount of memory, each program has to ask for it. When a program calls system's memory allocation functions, system searches it's heap index (called *free list*) for a block that could be assigned. Various allocation algorithms exist with different trade-offs - some take more time to process but result in smaller memory fragmentation (amount of very small free blocks), some store more metadata (amount of free blocks, their size, preference, cached regions, etc) which of course requires some memory for the allocation itself. This is why allocating X memory takes actually more than X - the system has to store information about allocations.

The algorithm used to implement memory allocation has a huge impact on system performance - allocation functions can be called several thousands each second!

An example memory allocation implementation is available as [jemalloc](http://jemalloc.net). It's used by Android and FreeBSD.

If you build own operating system in C or C++, you have to write own memory allocation functions.

## problems with C dynamic allocation functions

- `malloc()` returns `void*` - **no type safety**
- It's easy to miscalculate required memory (it's in bytes) - most common mistake is forgetting to multiply by the size of the type
- It's very easy to allocate and then forget to free which results is memory leaks
- If the pointer given by `malloc()` is lost (by overwriting it or going out of scope), it can no longer be passed to `free()` and therefore the program has a memory leak
- Freed memory can no longer be accessed - calling `free()` twice with the same pointer is undefined behaviour.
- Freed memory can no longer be accessed - pointers passed to `free()` become dangling pointers

Generally, `malloc()` approach is very bug-prone and has no type checking.

## C++ dynamic memory allocation abstractions

C++ offers much more advanced abstractions to avoid these problems. Dynamic memory is a quite large topic and as the tutorial goes further more abstractions will be presented.

The most basic one - functions from C presented above require understanding of pointers. Top-level C++ abstractions require understanding classes and templates - this is why dynamic memory is not fully covered in this chapter.

Abstractions (highest ones first):

- containers, smart pointers
- allocators
- new/delete (next lesson)
- `malloc()`, `free()` and relared functions (current lesson)
