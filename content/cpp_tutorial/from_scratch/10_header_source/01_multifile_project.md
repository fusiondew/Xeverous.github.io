---
layout: article
---

## multifile project

Our first multifile project is going to be rather simple but it's purpose is to demonstrate and learn about splitting code.

We will define a function in a separate source file and call it from the main source file which will have to include it's declaration.

Prepare following files and their contents:

**func.hpp**

```c++
int func(int a, int b);
```

**func.cpp**

```c++
#include "func.hpp"

int func(int a, int b)
{
    return a + b;
}
```

**main.cpp**

```c++
#include "func.hpp"
#include <iostream>

int main()
{
    std::cout << "sum from externally defined function: " << func(2, 3) << "\n";
}
```

The project should build successfully and output the result of the function.

If your IDE automatically generated some `#ifndef` `#define` `#endif` code you can leave it as is - this is the topic of *header guards* lesson which is further in this chapter. If it causes any trouble you can remove it now.

In case you got any build errors, scroll down as I present common build errors below. I also added steps you need to do to cause a working project to trigger them. Understanding these errors will help you in the future.

## explanation of the project

A simpler approach would seem to have only 2 files:

**func.cpp**

```c++
int func(int a, int b)
{
    return a + b;
}
```

**main.cpp**

```c++
#include <iostream>

int main()
{
    std::cout << "sum from externally defined function: " << func(2, 3) << "\n";
}
```

The problem is that with such structure main source file would fail to compile - it would not know what is `func()`.

It would be a very classical error about unknown entity:

```c++
main.cpp: In function 'int main()':
main.cpp:5:62: error: 'func' was not declared in this scope
     std::cout << "sum from externally defined function: " << func(2, 3) << "\n";
                                                              ^~~~
```

We need to make main source file aware of the function. This fixes the problem:

**main.cpp**

```c++
#include <iostream>

int func(int a, int b); // added declaration

int main()
{
    std::cout << "sum from externally defined function: " << func(2, 3) << "\n";
}
```

However, while it works it's not a good solution for the following reasons:

- Modifying the function may alter it's signature. This would require to modify it's declaration. If there are multiple source files using this function, we would need to fix declaration in each source file.
- If we have multiple functions defined in a different source file, we would need to copy declaration of each function that is used somewhere else.

Combine these 2 problems and the project becomes unmaintainable - some simple change like adding/removing function argument in it's definition requires to edit all other source files in the project.

## the purpose of headers

To solve this problem, we use a header file. The header contains function declaration. Any source file that wants to use the function needs to just include it's header.

If there is a need to modify the function, we need to only fix it's header. Since any source file that needs it includes it, the change automatically propagates and there is no need for further edits. Instead of editing each source file in the project, we edit only source of the function and it's header.

**main.cpp**

```c++
#include "func.hpp" // included header - any change will automatically propagate
#include <iostream>

int main()
{
    std::cout << "sum from externally defined function: " << func(2, 3) << "\n";
}
```

### headers for self-checks

There is one more thing to explain:

**func.cpp**

```c++
#include "func.hpp" // is this really needed?

int func(int a, int b)
{
    return a + b;
}
```

In fact, it's not. We do not need a declaration to write a definition. 

ODR remainder: every definition is also a declaration. TODO remainder block

But including a header here has it's benefits.

ODR remainder: every declaration must be the same. TODO remainder block

If there is some discrepancy between the declaration in the header and the definition in the source, it will be catched by the compiler. Let's imagine that the function was mistakenly declared as `void func(int a, int b)`. This would result in:

```c++
TODO paste compiler error
```

Of course it will not catch all problems (some incompatible declarations would create a separate overload instead) but it's better than nothing. Still, the project would fail to build but at the linking stage, not compilation. The sooner we trigger build errors the better as every further build step tends to produce harder to understand errors.

Right now including own declaration is just a good practice towards better error messages but later, a lot of more advanced C++ features will require to always include relevant header because for example, class member function definitions require class definitions first.

<div class="note pro-tip" markdown="block">

Always include relevant header for each source file. By convention, files should be named the same with only a difference in the extension (here: **func.hpp** and **func.cpp**).
</div>

<div class="note pro-tip">
Don't ever include any source file. Only headers are intended for inclusion.
</div>

## single-file-purpose code

There are rare cases where some functions are intended to be used only within their source file. Then you can skip making a header. To further express such intent, put such function in an anonymous namespace:

```c++
namespace {
    int func(int a, int b)
    {
        return a + b;
    }
}

// use of func() allowed only in this file 
```

Anonymous namespaces do not add any named scope but they block reuse from other files. There is no thing that could be written in front of `::` to call such functions.

This technique works for any definition: variables, classes, functions and more.
