---
layout: article
---

Just like with everything, we can go deeper...

![ponter to pointer meme](https://memegenerator.net/img/instances/43653001/yo-dawg-i-heard-you-like-pointers-so-i-put-a-pointer-in-a-pointer-so-you-can-dereference-a-pointer-w.jpg)

```c++
const int x = 1;                         //                                                    const int
const int* const p1 = &x;                //                                   const pointer to const int
const int* const* const p2 = &p1;        //                  const pointer to const pointer to const int
const int* const* const* const p3 = &p2; // const pointer to const pointer to const pointer to const int
// and so on...

// dereference to integer:
*p1;
**p2;
***p3;
```

All address-of and dereference rules still apply, just at more levels.

Nested pointers are still the same at machine instruction level - all holds just addresses. Streams treat all pointers the same way (except character pointers).

Multilevel pointers are not really used. The highest one ever needed would be 2 (pointer to pointer to thing) which can represent "pointer to array" which can be "array of arrays".

However, multi-dimentional arrays still decay to first-level pointer. `int[Z][Y][X]` is still one block of memory of length `X * Y * Z`.

Multidimenional arrays which use multiple separate memory blocks require *dynamic allocation* which will be covered later.

For now, just the example of printing program arguments which are supplied to the program as an array of C strings.

```c++
#include <iostream>

// the second form of main function, this one accepts command line arguments
int main(int argc, char** argv)
{
    std::cout << "argument count: " << argc << "\n";
    std::cout << "argument values:\n";

    for (int i = 0; i < argc; ++i)
        std::cout << i << ": " << argv[i] << "\n"; // dereference on char** yields char*
}
```

~~~
$ ./program arg1 arg2 "a r g 3" arg4
argument count: 5
argument values:
0: ./program
1: arg1
2: arg2
3: a r g 3
4: arg4
~~~
