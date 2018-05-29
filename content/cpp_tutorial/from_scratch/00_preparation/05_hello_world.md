---
layout: article
---

Enough math for now, this time a minimal working program - the so called ["Hello World"](https://en.wikipedia.org/wiki/"Hello,_World!"_program)

```c++
#include <iostream>
 
int main()
{
	std::cout << "hello, world";
	return 0;
}
```

This is a minimal program that should print the "hello, world" on the terminal. It is commonly used as a sanity check (in any programming language) to verify that all tools are setup correctly and the build succeeds.

<div class="note info">
#### Info
<i class="fas fa-info-circle"></i>
Tutorials how to configure various IDEs are in other category on this website.
</div>

There are few problems you may encounter (if you didn't, skip this):

## possible problems

#### IDE complains that it can not find the compiler

**Windows**

This problem usually appears on Windows where after installing (or just unpacking) a compiler it's not automatically added to `PATH` environmental variable.

Copy the path of your compiler binary directory and append it to the `PATH` in Control Panel -> environmental variables (this is pretty deeply hidden option, search the net for screens if you can't find it)

The path should be a set of directories leading to the one where the compiler executable resides. If your compiler is `C:\MinGW\bin\g++.exe` (the bin directory for various GCC ports is usually full of executables and some dlls) the path should be `C:\MinGW\bin`. MinGW-w64 may have longer paths (my is `C:\mingw-w64\i686-7.2.0-posix-dwarf-rt_v5-rev1\mingw32\bin`).

- If the variable `PATH` does not exists in the list, just add it (name `PATH` and the value is the actual path)
- if `PATH` already exists, append your path to it after semicolon: `C:\something1;C:\something2;C:\compiler\bin`

After setting up, you should be able to call the compiler from the command line (from any directory):

```shell
C:\Users\admin>g++ --version
g++ (i686-posix-dwarf-rev1, Built by MinGW-W64 project) 7.2.0
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

If it does not work you probably need to restart Windows in order to apply `PATH` change.

**Unix**

Note: some distributions may come with GCC already, but it may have only C components installed or have an old version of C++ compiler. Check the version, just like in the example above.

Binaries are usually searched in `/usr/bin` and a couple other distribution-specific places.

If your compiler is installed in a different place, you can try to create a symlink `/usr/bin/gcc` which points to the actual compiler executable (note: this is needed to be done also for other executables, eg `make`).

If not, I trust if you have managed to install a custom compiler on your distribution, you are also be able to fix this problem.

#### IDE complains it can not find `make` (or something else) in `PATH`

This problem similar to the one above - this time the `make` program could not be found.

Go to your compiler installation directory and check that `make` actually exists. It's common that you will find something like `mingw-make32.exe` or `i686-w64-mingw32-make.exe`. It is because various GCC distributions prefix some executables with architecture name in case someone wanted to have a multi-acrhitecture toolchain installed in 1 place. I hardly doubt you want to compile now for something other than x86 (i686) / x86_64 (these are the architecture names of standard 32-bit and 64-bit PC).

If this is the case - simply copy the executable and give the copy a correct name (`make.exe` or `make` on Unix systems).

You might also find more exectables with prefixed names - in case of problems do the same.

Test that it works by calling make from command line:

TODO make --version

#### Visual Studio complains it can not find something related to `stdafx.h` or throws `fatal error C1010: unexpected end of file while looking for precompiled header directive`

This is one of the reasons why I don't like this IDE - it sometimes inserts some code or non-standard features. `stdafx.h` is for precompiled headers (explained later, or for now: [SO link](https://stackoverflow.com/questions/4726155/)) and it requires additional changes in the source code which make the code non-portable.

It is possible to disable this feature or change it in a such way that no code should be modified.

If you have choosen any type of application, you may also try to create an empty C++ project - VS should not generate then anything additional in the solution.

**It works, but the window disappears instantly or doesn't show up but the IDE informs that execution succeded.**

This is a correct behaviour, since the only task for the program was to print the text and close. It's actually a feature in some IDEs that they stop the program when it finishes so the window does not disappear.

You can workaround this by inserting additional line which will wait for a key press:

```c++
#include <iostream>
 
int main()
{
	std::cout << "hello, world";
	std::cin.get();
	return 0;
}
```

You can also search the options in the IDE or find solutions on the internet.

At worst case scenario just prepend

```c++
#include "stdafx.h"
```

to EVERY program you build (on the first line, before any other includes).

#### Build is finished but the program can not be launched

**Windows**

Check your antivirus. It might have blocked the executable because compilers spawn them out of nowhere.

**Unix**

Check that the executable is actually an executable. Go to it's directory and verify that it has `x` flag on by using `ls -l`. If not, add the flag by `chmod +x executable_name`.

#### (Windows) Some dll is missing when launching the program

Likely `libstdc++-6.dll` but might be something else. This means that your program is using parts of C++ standard library but does not know where they are.

Option 1.

Use static linking of C++ standard library - it's content will be put inside your executable and thus it will not require a standalone dll (the `.exe` file will be bigger instead) [SO link](https://stackoverflow.com/questions/26103966/how-can-i-statically-link-standard-library-to-my-c-program).

- If you are using any IDE with GCC (any OS), add `-static-libstdc++` to the linker commands (Note: linker, not compiler)
- If you are using Visual Studio change linker option `/MD` to `/MT` (might also be available through some menu)

Option 2.

Copy C++ standard library dlls to the directory where your executable is or to the root directory of your project (dlls should be inside compiler installation, eg `C:\MinGW\bin\libstdc++-6.dll`).

#### (Windows) Strange x86 / x86_64 error when launching the executable

You have a 32-bit computer but build the project for 64-bit. Your processor architecture can not run this instruction set.

- GCC / Clang - Add `-m32` to compiler and linker flags
- MSVC - open project properties and the linker settings

#### My problem is not listed here

If you have any error message (from compiler or IDE), copy it and search the internet. I have yet to find an error which was not already in Google.

If you have a configuration problem, try to condense it in a couple of words and search the net.

If you have a reddit account, you can also ask on [/r/cpp_questions](https://www.reddit.com/r/cpp_questions/).
