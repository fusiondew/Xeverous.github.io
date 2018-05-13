---
layout: article
---

Our journey starts from math. I assume you know what a *function* term means in math. In programming it's very similar.

**A function is a reusable piece of code which may have input parameters and output some value** It's a mapping from input to output.

Let's use a very simple quadratic function:

$$f(x) = x^2$$

This is how it looks like in C and C++ (written using multiplication to avoid more complex stuff):

```c++
int f(int x)
{
    return x * x;
}
```

There are multiple noticeable things here:

- `int` is used to indicate return type (on the left) and argument type (inside parentheses); `int` means *integer* - this function works with whole numbers
- the function is named `f` (other names are also possible)
- the function takes 1 argument named `x` which is an `int`eger
- the function *returns* `x` multiplied by `x`

So how this function is used? It's surprisingly very similar:

$$
x = 5 \\
y = f(x)
$$

```c++
int x = 5;
int y = f(x);
```

The difference is that since we are using strongly typed language both `x` and `y` have to be given types - the compiler need to know we are working on numbers. The other thing you may have noticed is that statements end in `;`. This is a very normal thing is tons of programming languages - just like human language sentences end in `.` the programming sentences end in `;`.

#### Question: Why ; and not .?

Part of the reason is history and the other thing is that `.` has other purposes (eg writing fractional numbers: `3.14`).

### function parts

```c++
//(1) (2)   (3)  
int square(int x)
{ // <- (4)
    int result = x * x;
    return result;
}
```

- (1) (`int`) - function return type. Indicates what type of result the function *returns*. Functions which do not return any meaningful value can be declared to have `void` return type.

- (2) (`square`) - the name of the function
- (3) (`(int x)`) - function arguments and their types
- (4) (everything between `{` and `}`) - function body. This groups multiple statements

Functions form a reusable pieces of code. Function `square` can be called as many times as wanted without the need to write it's body again.

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