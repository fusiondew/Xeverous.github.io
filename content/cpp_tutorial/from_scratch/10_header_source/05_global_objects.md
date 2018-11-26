---
layout: article
---

So far I have presented how to define a function in a separate source file. The process of defining a global variable is very similar.

For function, we provided definition in source file and declaration in header file. How are variables declared without definitions?

## variable declarations

If we try to put `int x;` into a header file, we will get build errors once multiple source files include that header. The problem is that such statement is also a definition.

First thing that might come to your mind is to use `inline` - in fact, this is a valid solution but supported only since C++17.

There is a different keyword that specifies that given statement is only a declaration:

```c++
extern int x; // defined externally, here just a declaration
```

Now if you try to build such project, you will get a different error - this time not duplicated definition but missing definition.

The correct way is to declare using `extern` in a header file and define without this keyword in any choosen source file.

## example project

**global.hpp**

```c++
#pragma once

extern int x;
```

**global.cpp**

```c++
#include "global.hpp"

int x = 1; // initializers must be at the point of definition
```

**functions.hpp**

```c++
#pragma once
#include <iostream> // see notes

void print_x();
void assign_x(int val);
```

**functions.cpp**

```c++
#include "functions.hpp"
#include "global.hpp"
#include <iostream>

void print_x()
{
    std::cout << "x is now: " << ::x << "\n"; // see notes on ::
}

void assign_x(int val)
{
    ::x = val;
}
```

**main.cpp**

```c++
#include "functions.hpp"
#include "global.hpp"
#include <iostream>

int main()
{
    print_x();
    assign_x(2);
    print_x();
    std::cout << "x is now: " << ++::x << "\n";
}
```

## recommendations

### accessing global objects

`::x` was used to explicitly state that it's a global object. There is no namespace name before scope resolution operator - such syntax makes sure that a globally visible entity it used. It's used for clarity - global variables are bad and it's better to clearly express that we want to access one.

### include redundancy

**main.cpp** includes **iostream** even though it's already provided by **functions.hpp**. This is good because if at any point you realize that **iostream** is not actually needed by functions' header such removal would not break the build.

You should always include headers if you use any stuff from them. Do not rely on other headers including headers you need because if at any point dependencies of your dependencies change, you will get build errors. In other words, think of headers as necessary and not rely on what they include themselves.

### include order

There are no requirements for specific order of include directives (we just list dependencies and if they have their own dependencies header guards make redundant includes empty) but there are some benefits for inside-out order - mostly hitting any build errors sooner and preventing code from accidental relying on dependencies of dependencies.

Therefore, I advice to list headers in the following order:

- associated header file with the same name (if it's a source file) - see first inclusion in **functions.cpp**
- any header closely related to the code (usually headers from your own project)
- any external library headers if needed in this file
- any standard library headers if needed in this file
