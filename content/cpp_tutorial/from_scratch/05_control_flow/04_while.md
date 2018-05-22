---
layout: article
---

The second most used type of control flow instructions are loops.

TODO Def block

A loop is a repetitive execution of one (or more) statements as long as certain condition is satisfied.

## while

```c++
#include <iostream>

int main()
{
    std::cout << "Enter a number: ";
    int x;
    std::cin >> x;

    while (x % 2 == 0)
    {
        std::cout << "dividing " << x << "\n";
        x = x / 2; // can also be x /= 2
    }

    std::cout << "The final, odd value is " << x << ".\n";
}
```

Before each attempt, the condition `x % 2 == 0` is checked. If it's false the loop ends and execution continues after `}`. As with `if`, if there is only a single statement braces can be ommited.

Test this program with big, even numbers.

## do while

An alternative loop is formed using `do` and `while` keywords. The only difference is that the condition is checked after the loop body, which means that it's guaranteed to execute at least once.

```c++
#include <iostream>

int main()
{
    int x;
    do
    {
        std::cout << "Enter a non-negative number: ";
        std::cin >> x;
    } while (x < 0);
    //             ^ spot the semicolon
}
```

Note: **the do-while loop ends with a semicolon**.

<div class="note info">
#### do-while usage
<i class="fas fa-info-circle"></i>
Do-while loops are rarely used. Almost always the condition is needed to be checked before loop statements. Do-while loops may be hard to read if they span multiple lines - you can always refactor these by changing order of statements.
</div>

TODO example do-while -> while refactor.

## exercise

Write a program, similar to these above that will ask the user for a number (integer). Print the half of the number if it's even, print the number unmodified it it's odd. Continue asking the user for more numbers untill 0 is entered.

You may also add a special case if the entered number is negative.

TODO spoiler with example solution
