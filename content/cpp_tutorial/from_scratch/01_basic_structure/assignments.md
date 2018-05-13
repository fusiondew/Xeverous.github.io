---
layout: article
---

Before a variable can be used, it must be *defined*. The definition is fairly simple: `type name;`

```c++
int x; // create variable named "x" which is of type int
```

After the variable is *defined*, you can use it's name to refer to it's memory and perform operations:

```c++
x = 5; // assign value 5 to "x"
```

Obviously it is possible to define and give initial value at the same statement:

```c++
int x = 5;
```

which forms an **initialization**. Initializations is a definition + inital value at the same statement.

For now, it doesn't matter whether you do both in 1 initializaition statement or split them to definition + assignment, but it will make a difference in the future. Assignment always uses `=` operator, but initialization may use (and often requires) a different syntax.

Other possible initializations:

```c++
int x(5);
int x{5};
```

Of course stay with `=` since it's much more intuitive for numbers. Different syntax will be used only when it has an impactful difference. Other initializations will be explained later.

<div class="note info">
#### Info
<i class="fas fa-info-circle"></i>
**Initialization** can only happen at the moment of **definition**. If it's not done in the first statement, it's an **assignment** (even if it uses `=` in both cases).
</div>


### uninitialized variables

C and C++ does not require to set any initial value (unless we use some advanced features). If you do not set anything, the value stored in variable's memory will be unknown - typically some garbage bits which were left after previous program that used the same memory location.

```c++
int x;
std::cout << "x = " << x;
```

It is unknown what the program above will print. It might be 0 but also some huge number - happens when we reuse other program's memory which had different purpose. Each program execution may print different value of `x`. There might be or not some pattern in the outputs of the program - depends on how your system handles memory.

<div class="note pro-tip">
#### Pro-Tip
<i class="fas fa-star-exclamation"></i>
Always initialize variables. Prefer direct initialization over definition + assignment.
</div>

A good compiler should give a warning when an uninitialized variable is used:

```c++
main.cpp: In function 'int main()':
main.cpp:6:18: warning: 'x' is used uninitialized in this function [-Wuninitialized]
     std::cout << x;
                  ^
```

### overwriting

It's possible to reuse the value of the given variable to set it's new value

```c++
int x = 5;
x = x * 2; // assign to x value equal to 2 times current value of x
std::cout << x; // prints "10", no doubt
```

This is normal and works as expected. Language defines that assignments are made from right to left so the right side expression is eavluated first before it's saved in `x`.
