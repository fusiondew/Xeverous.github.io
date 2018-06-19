---
layout: article
---

Sometimes you may want to return multiple values from a function.

```c++
??? div_and_mod(int x, int y)
{
    return x / y, x % y; // ???
}
```

It's not possible because **functions** by definition (also in math) **always return 1 value** (or `void`).

There are multiple workarounds though

### return compound object

Simply use a custom type made from multiple variables.

```c++
struct result
{
    int div;
    int mod;
}

result div_and_mod(int x, int y)
{
    return { x / y, x % y };
}
```

There are few types in standard library specifically for this and similar purposes (most notably `std::pair`).

### use out parameters

Out-parameters are non-const references that are used as an output rather than input. In normal scenario functions just read arguments. With out parameters the flow is reversed - variables are given to the function and the function writes to them.

```c++
//                                       out parameter
bool save_log(const std::string& path, int& saved_lines);

// example use
int log_lines;
if (save_log("/usr/games/my_game/log.txt", log_lines))
{
    // successful save - we can assume some value was written to the out parameter
}
else
{
    // save failed, log_lines was likely untouched and stays uninitialized
}
```

Out parameters have multiple conventions:

- If the function returns `bool`, it informs whether the operation succeeded. If it did not succeed, out parameter may not be written and stay uninitialized
- Out parameter should be the last argument
- There should be at most 1 out parameter. More is very bug-prone
- Prefer returning to out parameter - in other words, `error_code func(/*...*/)` is better than `void func(/*...*/, error_code& ec)`

#### out parameters in C

C does not have references, it uses pointers to be able to write to the given parameters. If the argument is already a pointer, this causes the function to use double pointers. Functions in C++ standard library which were imported from C can be easily recognized if they use out paremeters.

```c++
// C function converting "string to long"
//          input string     out parameter   input base
long strtol(const char* str, char** str_end, int base);
```

The function above reads the character sequence starting at `str`, interprets it according to the `base` (eg 10 for decimal, 2 for binary) and sets `str_end` to the place where reading stopped - either end of string was reached or invalid (not a digit) character was found.

Because the function needs to output 2 things (integer representation and where it has finished) it uses an output parameter. Because it needs to save a character address (`char*`) it uses a pointer to a character pointer.

Obviously such functions are not preferred in C++, C++ provides multiple better alternatives.

Note: useful functions such as parsing character sequence to an integer are presented in relevant tutorial.
