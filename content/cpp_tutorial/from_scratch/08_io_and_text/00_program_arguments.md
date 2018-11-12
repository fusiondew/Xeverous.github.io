You might have already seen a somewhat different main function:

```c++
int main(int argc, char** argv)
int main(int argc, char* argv[]) // same as above
```

This is the way program arguments are received. It is an array of null-terminated strings.

## printing arguments

If we dereference `char**`, we get `char*` which is a C-string.

`argc` is **arg**ument **c**ount and `argv` are **arg**ument **v**alues.

```c++
#include <iostream>

int main(int argc, char** argv)
{
    std::cout << "argument count: " << argc << "\n";
    std::cout << "argument values:\n";

    for (int i = 0; i < argc; ++i)
        std::cout << i << ": " << argv[i] << "\n"; // dereference on char** yields char*
}
```

~~~
$ ./program --arg1 --arg2 "a r g 3" -a
argument count: 5
argument values:
0: ./program
1: --arg1
2: --arg2
3: a r g 3
4: -a
~~~

## parsing arguments

C++ standard library does not cover argument parsing. I suggest to use any external library instead - many have an API that is easy to understand and allow automatic generation of `--help` and other commands.

Unix systems provide `getopt()` and `getopt_long()` but that's a very C-ish interface and it limits application to these systems.

## other notes

- `argc >= 0` always.
- Almost always the first argument is the program name. Note that this not a reliable way of determining program's running directory as it can be launched from other ones (with longer path) or through a symlink or internal system call.
- `arv[argc]` is guuaranteed to be a pointer to character `\0` (null terminator), essentially making it an empty C-string. Note that this empty string is an element 1 past array end.
- Names `argc` and `argv` are not fixed. You can use anything else but why would you break a convention that has been used for multiple decades?
