---
layout: article
---

Recall information from the previous chapter:

- one definition rule
- compilation vs linkage
- header inclusion
- header guards

This lesson will show how a typical C++ class is split.

## naive explanation

You might encounter a naive explanation that in general, definitions are put into source files and declarations are put into header files.

While it's mostly true, it does not reflect all details how a C++ program is build. **Type definitions (enumerations and classes) are put into headers.** This is because types themselves do not form executable code but describe memory layout of data which is necessary for functions to correctly perform read/write operations.

## example project with classes

Sample project demonstrating correctly splitted C++ code.

**rectangle.hpp**

```c++
#pragma once

class rectangle
{
// typical C++ convention is to list functions first, variables later
// people who browse headers mostly search for documentation and function signatures
public:
    void set_values(int a, int b);
    int get_area() const;
    bool is_square() const { return width == height; } // see notes

private:
    int width;
    int height;
};
```

**rectangle.cpp**

```c++
#include "rectangle.hpp" // no longer a self-check, this header is required to use 'rectangle::'

void rectangle::set_values(int a, int b)
{
    width = a;
    height = b;
}

int rectangle::get_area() const
{
    return width * height;
}
```

One of member functions is defined inside the class. This is not a problem because **member functions defined inside class are implicitly `inline`**. It's reasonable to do it for small getters as they usually occupy 1 line. Placing them in source files seems quite verbose.

The general convention is to make a header + source pair for each class. Some projects feature a lot of code - then they put multiple class definitions to one header and all function bodies to one relevant source file.

## summary

Source code that forms machine code is put into source files. Source code that is necessary to be visible for other files (type definitions which specify memory layout, templates which always require full context) is put into header files.

From now on, code examples will be split into parts which allow easy header/source separation. Some features like `static` members might be unclear at the first sight so their code snippets will have extra comments informing to which file put what code.
