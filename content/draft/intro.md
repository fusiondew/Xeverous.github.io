---
layout: article
---

The main function does not need to be declared.

The other thing you may have noticed is that statements end in `;`. This is a very normal thing is tons of programming languages - just like human language sentences end in `.` the programming sentences end in `;`.

#### Question: Why ; and not .?

Part of the reason is history and the other thing is that `.` has other purposes (eg writing fractional numbers: `3.14`).


### main function

**Every executable C++ program must have a main function** (you can build non-executable libraries but that's not the scope of this tutorial). The main function is the start of any program. When main function returns (ends) the program execution is finished.

The main function has 2 variants:

```c++
int main()
int main(int argc, char** argv)
```

The second variant allows to parse command line arguments (eg when you call programs with parameters such as `program --help`). More about it in a different tutorial - you will not need this for now and understanding it requires understanding pointers which are yet to be explained.

The main function returns an `int`eger. This is the exit code - status whether your program finished succesfully. Value `0` is treated as success and any other value represents failure. There are no hard conventions here, multiple programs use different style and error numbers. No system-error is produced if the execution is unsuccesful - these appear only in case of crashes.

Smallest valid program:

```c++
int main()
{
    return 0;
}
```

It does nothing, ends immediately upon start indicating successfull execution.

C++ allows to skip return statement in main function, if you skip it, `return 0;` is assumed. Therefore, the more minimal C++ program is:

```c++
int main()
{
}
```

Of course blank characters can be different (or skipped), at most packed case entire program is

```c++
int main(){}
```

### exercise

Replace the hello word program with miminal main function. The program should build correctly but don't do anything.