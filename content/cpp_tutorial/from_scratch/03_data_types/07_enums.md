---
layout: article
---

Enumerations are a convenience feature to ease use of integer constants. This is an example of user-defined type.

## unscoped enumerations

```c++
#include <iostream>

enum color { red, green, blue };

int main()
{
    color x = red;
    color y = green;
    std::cout << "x = " << x << "\n";
    std::cout << "y = " << y << "\n";
    std::cout << "blue = " << blue << "\n";
}
```

~~~
x = 0
y = 1
blue = 2
~~~

`color` is an enumeration and `red`, `green`, `blue` are enumerators.

Enums are stored as integers in memory. Value of the first one is `0` and each next one is assigned next integer.

Values may be specified explicitly:

```c++
enum my_enum
{
    a,         //  0
    b,         //  1
    c,         //  2
    d = 5,     //  5
    e,         //  6
    f,         //  7
    g = e + 6, // 12
    h,         // 13
    i          // 14
};
```

Since C++11 it's possible to explicitly specify *underlying type*. Enumerators will then occupy the same amount of bytes as their underlying type.

```c++
// stored on 1-byte
enum e1 : char { a, b, c, d };
// possible error: on given architecture char is not capable to hold value 200
enum e2 : unsigned char { a, b, c = 200 };
// error: float is not an integral type
enum e3 : float { a, b, c, d };
```

## problems

Unscoped enumerations are a quite old feature (appeared already in C) and have few problems:

- they are *unscoped* (no bounds on definition scope) - this means that enumerators of different types may clash names

```c++
enum color { red, green, blue };
enum light { red, yellow, green }; // error: red and green redefined
```

- they allow to violate type safety

```c++
light l = green;
if (l == yellow) // no error but comparing values from different enums
```

```c++
color c = 10; // only 0, 1, 2 are covered - this can cause bugs
```

## scoped enumerations

To address these problems, C++11 added *scoped enumerations*. Actually that was the point where *unscoped* and *scoped* names were added to distinguish old and new enumerations. For backwards compatibility old enums are left unmodified and to use newer (safer) enums definition additionally uses keyword `class`:

```c++
enum class color { red, green, blue };
enum class light { red, yellow, green }; // no name conflicts


color c1 = red; // error: 'red' not defined
color c2 = color::red; // OK
color c3 = 1; // error: can not assign value of type 'int' to value of type 'color'
color c4 = static_cast<color>(1); // OK: explicit type convertion

if (c4 == yellow) // error: 'yellow' not defined
if (c4 == light::yellow) // error: comparison of values of different types (color/light)
```

<div class="note pro-tip">
Use only scoped enumerations.
</div>

<div class="note info" markdown="block">

Scoped enumeration definitions may also use `enum struct` instead of `enum class` (both have exactly the same meaning) but there is a strong convention to use the `class` keyword.
</div>

<div class="note info">
Scoped enumerations are user-defined types but are not classes.
</div>
