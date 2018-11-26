---
layout: article
---


## undefined reference

There is a chance that you might attempt to build a project without all source files.

Delete **func.cpp** or comment out all code inside it. Read the error you get. It should be something like this:

```c++
TODO paste undefined reference error
```

The compilation step succeded - **main.cpp** had all necessary information to build - `std::cout` and `func()` were both declared.

**Compilation:**

~~~
func.hpp
    - declares: int func(int, int)
iostream
    - declares: std::cout
main.cpp
    - requires declaration: func
    - requires declaration: std::cout

main.cpp + func.hpp + iostream => main.o [OK]
    func      - found in func.hpp
    std::cout - found in iostream
~~~

The problem is recognized by the linker when it attempts to merge object code to form an executable.

**Linking:**

~~~
main.o
    - defines: int main()
    - requires definition: std::cout
    - requires definition: int func(int, int)
C++ standard library object file
libstdc++.so (this is the name is used by GCC)
    - defines: std::cout
target: executable (we build a runnable program, not a library so we need an entry point)
    - requires definition: int main() OR int main(int, char**)

(program.exe name may vary depending on OS and project settings)
main.o + libstdc++.so => program.exe [error]
    std::cout          - found in stdlibc++.so
    int main()         - found in main.o
    int func(int, int) - not found [missing definition]
~~~

The linker finds out that some code references the function but none of object files provide it's definition. Executable can not be build because machine code for a function is missing. Thus, the *undefined reference* error.

Such error usually means the following:

- missing code for some function (or any other missing definition)
- one of source files is not in the build and the IDE does not call compiler on it

## multiple reference

Now, let's imagine a reverse situation. Through some edits you accidentally ended with 2 definitions of the same entity.

Copy **func.cpp** as **func2.cpp** and add it to the project.

**Compilation:**

~~~
func.hpp
    - declares: int func(int, int)
iostream
    - declares: std::cout
main.cpp
    - requires declaration: func
    - requires declaration: std::cout
func.cpp
    - requires declaration*: func
func2.cpp
    - requires declaration*: func

main.cpp + func.hpp + iostream => main.o [OK]
    func      - found in func.hpp
    std::cout - found in iostream
func.cpp + func.hpp            => func.o [OK]
    func      - found in func.hpp
func2.cpp + func.hpp           => func2.o [OK]
    func      - found in func.hpp
~~~

\* - these 2 are not actually required in the example, but let's assume we used more advanced C++ features which made header inclusion necessary.

**Linking:**

~~~
main.o
    - defines: int main()
    - requires definition: std::cout
    - requires definition: int func(int, int)
func.o
    - defines: int func(int, int)
func2.o
    - defines: int func(int, int)
libstdc++.so
    - defines: std::cout
target: executable
    - requires definition: int main() OR int main(int, char**)

main.o + func.o + func2.o + libstdc++.so => program.exe [error]
    std::cout          - found in stdlibc++.so
    int main()         - found in main.o
    int func(int, int) - found in func.o
    int func(int, int) - found in func2.o [unexpected duplicate]
~~~

The error this time is very similar but instead of missing definition we have a duplicated definition. This is a violation of ODR.

You might think why is this a problem. What if definitions are not the same? The linker has no idea which definition is intended.

Even in the case where both definitions are identical, it's not a good thing just to discard one definition and go further. While there is everything needed to form an executable, such situation indicates there is a configuration or code problem. For safety, build tools consider such situation as an error.
