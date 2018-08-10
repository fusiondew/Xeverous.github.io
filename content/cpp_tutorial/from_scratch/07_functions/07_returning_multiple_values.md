---
layout: article
---

Sometimes you may want to return multiple values from a function.

```c++
??? div_and_mod(int x, int y)
{
    return x / y, x % y; // this will evaluate both but ignore first
}
```

It's not possible because functions by definition always return 1 value or `void`.

There are multiple workarounds though.

### return compound object

Simply use a custom type made from multiple variables.

```c++
struct div_t
{
    int quot;
    int rem;
};

div_t div(int x, int y)
{
    return { x / y, x % y };
}
```

There are few types in standard library specifically for this and similar purposes (most notably `std::pair` and `std::tuple`).

There is also [a function exactly like the one above](https://en.cppreference.com/w/cpp/numeric/math/div). TODO link img

### out parameters

Out-parameters are non-const references that are used as an output rather than input. In normal scenario functions just read arguments. With out parameters the flow is reversed - variables are given to the function and the function writes to them.

```c++
//              in parameter      out parameter
bool save_log(const char* path, int& saved_lines);

// example use
int log_lines = 0;
if (save_log("/usr/games/my_game/log.txt", log_lines))
{
    // successful save - we can assume some value was written to the out parameter
}
else
{
    // save failed, log_lines was likely untouched and stays at 0
}
```

Out parameters have multiple conventions:

- If the function returns `bool`, it informs whether the operation succeeded. If it did not succeed, out parameter may not be written and stay uninitialized
- Out parameter should be the last argument
- There should be at most 1 out parameter. More is very bug-prone
- Prefer returning to out parameter - in other words, `error_code func(/*...*/)` is better than `void func(/*...*/, error_code& ec)`

**out parameters in C**

C does not have references, it uses pointers to be able to write to the given parameters. If the argument is already a pointer, this causes the function to use second level pointers. Functions in C++ standard library which were imported from C can be easily recognized by second-level pointers.

```c++
// C function converting "string to long"
//          input string     out parameter   input base
long strtol(const char* str, char** str_end, int base);
```

The function above reads the character sequence starting at `str`, interprets it according to the `base` (eg 10 for decimal, 2 for binary) and sets `str_end` to the place where reading stopped - either end of string was reached or invalid (not a digit) character was found.

Because the function needs to output 2 things (integer representation and where it has finished) it uses an output parameter. Because it needs to save a character address (`char*`) it uses a pointer to a character pointer.

Obviously such functions are not preferred in C++, C++ provides multiple better alternatives.

Note: useful functions such as parsing character sequence to an integer are presented in relevant tutorial. TODO

## rationale and recommendation

C language does not have *return value optimization* which causes functions returning structures to be ineffective. Every C++ function that takes a pointer as out parameter is an import from C for backwards compatibility.

C++ does have such optimization and that's the preferred way. Define types holding multiple values and return objects. Later, you will learn about classes which add huge amount of features to structures.
