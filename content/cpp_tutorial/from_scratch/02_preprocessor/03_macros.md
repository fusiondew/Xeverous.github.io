---
layout: article
---

Another type of preprocessor directives are text-replacing **macros**.

The macro is substituted to it's text (if any). The macro must be matched exactly (if the text matches only part of the macro name it is not considered a match).

```c++
#define identifier text
```

Whenever *identifier* is used within the code, it will be replaced by *text*.

**Example**

```c++
#include <iostream>
#define MY_MACRO "my text from a macro"

int main()
{
    std::cout << MY_MACRO << "\n";
#undef MY_MACRO
    // std::cout << MY_MACRO << "\n"; // will not compile - MY_MACRO is unknown identifier
}
```

## other text replacing macros

```c++
#define identifier(parameters) optional_replacement_list
#define identifier(parameters, ...) optional_replacement_list
#define identifier(...) optional_replacement_list

// replacement list may contain
// #parameter which expands to "parameter" (text is quoted)
// parameter_a##parameter_b which expands to parameter_aparameter_b (text is concatenated)
// __VA_ARGS__ which expands to arguments separated by ,
```

**multiple parameters**

```c++
#include <iostream>
#define PRINT(arg1, arg2, arg3) std::cout << arg1 << arg2 << arg3

int main()
{
    int x = 10;
    double d = 3.14;
    PRINT(x, " ", d); // equivalent to std::cout << x << " " << d;
}
```

**\# operator**

Expands the parameter into a quoted text

```c++
#include <iostream>
#define TO_STRING(x) #x

int main()
{
    // same as std::cout << "abc" << "xyz" << "\n";
    std::cout << TO_STRING(abc) << TO_STRING(xyz) << "\n";
}
```

**\#\# operator**

Merges two (or more) arguments without any space between

```c++
#include <iostream>
#define TOGETHER(a, b, c) a ## b ## c // you can also write a##b##c

int main()
{
    int my_variable = 100;
    std::cout << TOGETHER(my_, var, iable) << "\n";
}
```

**nested macros**

```c++
#include <iostream>
#define TO_STRING(x) #x
#define TOGETHER(a, b, c) TO_STRING(a ## b ## c)
#define PRINT(arg1, arg2, arg3) \
    std::cout << arg1 << arg2 << arg3 // '\' at the line end splits line
#define MY_MACRO "a macro"

int main()
{
    PRINT(TO_STRING(a string), TOGETHER(that, comes, from), MY_MACRO);
}
```

**variadic macros**

```c++
#include <iostream>
#define PRINT(...) std::cout << "printing " << #__VA_ARGS__ << '\n'

#define MACRO(x, y) #x << ' ' << #y << ' ' << MACRO2(x, y)
#define MUL
#ifdef MUL
#define MACRO2(x, y) (x * y)
#else
#define MACRO2(x, y) (x + y)
#endif

int main()
{
    PRINT(abc, 123, def, 456);
    std::cout << MACRO(2, 3) << '\n';
}
```

## predefined macros

There are multiple pre-defined macros which can be used by other preprocessor directives.

*This list is not complete*

- `__cplusplus` - expands to the year and month of used C++ standard
- `__STDC_HOSTED__` - expands to `1` if the program is running under an operating system, `0` if the program is the operating system
- `__STDCPP_THREADS__` - expands to `1` if the program can have multiple threads

There are also some macros which are very special - their value is not constant.

*This list is not complete*

- `__FILE__` - name of the file in which this is used
- `__LINE__` - line number on which this macro is used
- `__DATE__` - date at which file was processed in the format Mmm dd yyyy

**example**

```c++
#include <iostream>

int main()
{
    std::cout << "Used C++ standard (yyyymm): " << __cplusplus << '\n';
    std::cout << "This file is named: " << __FILE__ << '\n';
    std::cout << "This text is on line " << __LINE__ << '\n';
#ifdef __STDCPP_THREADS__
    std::cout << "This program can have multiple threads.\n";
#else
    std::cout << "This program can not have multiple threads.\n";
#endif
}
```

<details>
<summary>possible output</summary>
<p>

~~~
Used C++ standard (yyyymm): 201703
This file is named: main.cpp
This text is on line 7
This program can have multiple threads
~~~
</p>
</details>


## rationale and recommendation


**Macros are bad:**

- macros don't understand semantics

```c++
#define DIV(x, y) (x / y)
DIV(10, 2 + 3) // becomes (10 / 2 + 3) which is 8 instead of 2
```

- macros don't understand C++ syntax

```c++
#define TO_STRING(arg) #arg
TO_STRING(std::map<int, int>) // error: 2 arguments 'std::map<int' and 'int>'
TO_STRING((std::map<int, int>)) // ok: argument `std::map<int, int>`
```

- Macroed code is hard to read - you don't see th actual code that gets feed to the compiler

```c++
// normal code...
TEST(x, y, z); // what happens here?
// normal code...
```

- Macros can sabotage unrelated code

```c++
#define begin 0
#include <array> // tons of errors inside about std::array::0()

for (auto it = vec.begin(); it != vec.end(); ++it) // syntax error: vec.0()
    *it += 2;
```

Text-replacing macros can be used as shortcuts to avoid repetitive code. The problem with them is that the entire "find and replace" system is a very primitive solution from 1980s (where programming was not as much advanced as today) and can lead to many surprising results. You can not control macros to reduce their scope - for this reason there is a very strong convention that macros should be written using `UPPERCASE_NAME_STYLE`. Nothing else should use this style to avoid any potential name clashes.

Macros are popular in C but C++ is far more complicated and has many more language features which are strictly superior to macros. It's adviced to never use text-replacing macros unless there is no other way to achieve something.

**legitimate uses for text-replacing macros**

- testing/debugging (eg print statements use `__FILE__` and `__LINE__`)
- logging (avoids repetitive code)
- convoluted memory operations which can not be simplified (eg code that binds different programming languages)

## summary

- `#include`s are a preprocessor directive but not a macro
- macros may be just defined (purely for `#ifdef` directives) or defined to replace text
- text-replacing macros are evil because they operate on text and do not understand the code which can lead to hidden bugs or surprising results

There will be no text-replacing macros used in the entire tutorial.
