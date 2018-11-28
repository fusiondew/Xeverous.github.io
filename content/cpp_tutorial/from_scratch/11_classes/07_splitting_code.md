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

## circular dependencies

Sometimes class definitions might form a parsing loop.

**foo.hpp**

```c++
#pragma once
#include "bar.hpp"

class foo
{
public:
    // [...]

private:
    bar& ref;
};
```

**bar.hpp**

```c++
#pragma once
#include "foo.hpp"

class bar
{
public:
    // [...]

private:
    foo& ref;
};
```

Here we have 2 classes where each holds a reference to an object of another. It's unlikely you will encounter such trivial situation in real code, but I used a minimal code example for clarity.

So what's the problem?

- Compiler reads **foo.hpp**
  - read included **bar.hpp**
    - read included **foo.hpp**
    - include guards make file empty
  - continue reading **bar.hpp**
  - enter class bar definition
  - error: `foo&` uses class foo before it has been declared

Because there is a name dependency loop, compiler can not finish parsing one class without parsing another and vice versa.

The solution is simple: *declare* classes instead of *defining* them:

**foo.hpp**

```c++
#pragma once

class bar; // forward declaration

class foo
{
public:
    // [...]

private:
    bar& ref; // ok, 'bar' entity is known
};
```

**bar.hpp**

```c++
#pragma once

class foo; // forward declaration

class bar
{
public:
    // [...]

private:
    foo& ref; // ok 'foo' entity is known
};
```

Note that forward declaring a class only introduces it's name. You can use `foo&` but something like `foo::x` is not valid until a definition is made.

## infinite space

This is just impossible:

```c++
struct bar;

struct foo
{
    bar b;
};

struct bar
{
    foo f;
};
```

Can you imagine memory layout of this? *foo contains bar which contains foo which contains bar which cont...*

<div class="note info">
You can not use values of forward declared types. Only references and pointers to them.
</div>

This is because when compiler parses a class, it also determines it's memory layout (depending on the size and amount of it's fields). You can not use values of forward declared types because they have (yet) unknown size. References and pointers are valid because they are just addresses and on every hardware all addresses occupy a fixed amount of bytes.

## summary

Source code that forms machine code is put into source files. Source code that is necessary to be visible for other files (type definitions which specify memory layout, templates which always require full context) is put into header files.

header:

- class definitions
- enumeration definitions
- (member) function declarations
- global/static object declarations
- templates

source:

- (member) function definitions
- global/static object definitions

Everything that can be put into headers can also be put into source files, it just won't be available for inclusion.

From now on, code examples will be split into parts which allow easy header/source separation. Some features like `static` members might be unclear at the first sight so their code snippets will have extra comments informing to which file put what code.
