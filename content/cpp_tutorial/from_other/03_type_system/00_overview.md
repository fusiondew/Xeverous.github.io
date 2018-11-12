---
layout: article
---

## abstractions

C++ does a lot of abstractions over raw pointers and other typical C code. Some facts may be surprising.

- type of `"abc"` is not a string

It is `const char[4]` (4th byte occupied by hidden null-terminator) that very often decays to `const char*` losing array size information.

To solve type safety problems with stack-allocated arrays, use `std::array`.

```c++
int c_array[4];
std::array<int, 4> cpp_array; // guuaranteed same performance

  c_array = { 1, 2, 3, 4 }; // invalid code
cpp_array = { 1, 2, 3, 4 }; // ok, std::array overloads operator=

// C approach
// macros are used to solve boilerplate problems
#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
for (int i = 0; i < ARRAY_SIZE(c_array); ++i)

// C++ approach
for (int i = 0; i < cpp_array.size(); ++i)
// std::array also supports for-each loops
for (int x : cpp_array)

// C: pointer arithmetics
std::sort(c_array, c_array + ARRAY_SIZE(c_array));
// C++: iterators
std::sort(cpp_array.begin(), cpp_array.end());
```

## strict aliasing

C++ assumes **strict aliasing**.

TODO paste definition

It is important to note strict aliasing as it can be viewed as one of aggressive optimizations - compiler optimizes the program **trusting** that no code violates this rule. If any code does violate it, it might not be possible to detect it.