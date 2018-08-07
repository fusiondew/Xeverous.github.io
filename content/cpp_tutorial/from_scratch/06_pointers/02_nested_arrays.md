---
layout: article
---

Many constructs of programming languages can be nested and arrays are no different.

```c++
// an array of 5 integers
int arr[5] = ...

// an array of 5 arrays of 10 integers
int arr[5][10] = {
    {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9 },
    {  0, 10, 20, 30, 40, 50, 60, 70, 80, 90 },
    {  0, -1, -2, -3, -4, -5, -6, -7, -8, -9 },
    { 10,  9,  8,  7,  6,  5,  4,  3,  2,  1 },
    { -2, -3,  8, 16, -9, 30, 23, 56, -7,  4 } // note - no , here
};
```

Note the order of dimensions:

```c++
int arr[Y][X]
//         ^ the inner size
//      ^ the outer size
```

## printing

To print nested arrays you need ... nested loops. Should be self-explanatory.

```c++
for (int y = 0; y < 5; ++y) // note the order: the outer dimension has size 5
{
    for (int x = 0; x < 10; ++x)
    {
        std::cout << arr[y][x] << " "; // watch out - do not swap y with x
    }

    std::cout << "\n";
}
```

TODO note definition

<div class="note success">

Array dimensions start from the most outer to the most inner: `int arr[Z][Y][X]`. X is in the loop at the biggest depth, Z on the outside.

```c++
for (int z = 0; z < size_z; ++z)
    for (int y = 0; y < size_y; ++y)
        for (int x = 0; x < size_x; ++x)
            // use arr[z][y][x]
```
</div>

<div class="note warning">

A lot of crashes can happen due to wrongly written loops. Make sure you iterate correcty (from outside to inside).

Sometimes you may accidentally do a double negative - swap both X and Y both in loop order and in subscript.

```c++
for (int x = 0; x < size_x; ++x)
    for (int y = 0; y < size_y; ++y) // swapped loops order - y should be outside
        std::cout << arr[x][y] // swapped access
```

This works due to a "double negative" effect but it has degraded performance - memory is not accessed sequentially.
</div>

## size deduction

Only the most outer size can be ommited

```c++
// valid
int arr[][3] = {
    { 1, 2, 3 },
    { 2, 4, 6 },
    /* ... more possible arrays of 3 */
    { 100, 200, 300 } // no ,
};

// this is only the outer size
int arr_size = sizeof(arr) / sizeof(arr[0]); // note that arr[0] is not an integer but array of 3 integers

// invalid
int arr[][] = { /* ... */ };
int arr[3][] = { /* ... */ };
int arr[3][][] = { /* ... */ };
int arr[3][][3] = { /* ... */ };
```

This gets very messy. Later, you will learn about C++ classes which solve this problem.
