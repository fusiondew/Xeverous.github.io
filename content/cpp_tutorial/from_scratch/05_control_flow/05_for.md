---
layout: article
---

In all previous loops the were 2 visible aspects:

- loop body (what is repeated)
- loop stop condition

There is a special construct that is intended to use these 2 on the same line, together with initialization which is performed only once, before the loop starts

## the for loop

The syntax is as follows:

```
for (initialization; condition; step)
{
    loop_body
}
```

Which works as:

```
initialization;

while (condition)
{
    loop_body
    step
}
```

Initialization comes handy as often you will need a new variable to control the loop (eg what user is writing) but you may not get the point of the step part - why would someone want to split part of the loop body and put it somewhere else?

The key is the purpose of the step. It's intended to modify the loop control, something that can affect the condition. In almost all `for` loops, intialization, condition and step all use the same variable. This variable is commonly named `i` (from index or iteration) and it's name is a very strong convention. The body of the loop should not change `i`.

See an example to grasp the concept - the same program, printing numbers from 0 to 9 written using different types of loops.

```c++
#include <iostream>

int main()
{
    int i = 0;

    while (i < 10)
    {
        std::cout << i << " ";
        ++i;
        // the 2 lines above could be merged to std::cout << i++ << " ";
    }
}
```

```c++
#include <iostream>

int main()
{
    for (int i = 0; i < 10; ++i) // well-packed on one line
        std::cout << i << " ";
}
```

The specific advantage of a `for` loop is that the stop condition is closely related to the step. All instructions use `i`, but the body of the loop do not interfere with the exit. In contrast, in `while` loops usually the body was doing something with `n` (or `x`, depends how you name it) that affected when the loop will stop.

<div class="note info">
#### for loops
<i class="fas fa-info-circle"></i>
For loops are best suited if you know ahead what's the exit condition and how many times you want to repeat the instruction. The loop body should not modify `i`.
</div>

## start from 0, not 1

This is an important part. For most people the most intuitive way would be

```c++
for (int i = 1; i <= 9; ++i)
```

and it would work. The thing is, with computers, they count from 0. I intentianally used 0 as the start as soon, in the arrays lessons it will be necessary to start from 0 to iterate correctly over all elements.

The same applies for stop condition - it should use `<`, not `<=`.

With computers, when you have a squence of 10 elements, they will have numbers 0, 1, 2, 3, 4, 5, 6, 7, 8, 9. There is no "10" element, because counting starts from 0. More generally, when you have a sequence of $N$ elements, the first one has index $0$ and the last one has index $N - 1$.

Real example: a byte can hold 256 distinct values, which are from 0 (`0000 0000`) to 255 (`1111 1111`).

So the cannonical `for` loop is always written like this:

```c++
for (int i = 0; i < N; ++i) // iterates in range [0, N-1]
```


## nested for loops

An even better example is to showcase nested loops. Think how would you attempt to write such table:

```
0 1 2 3 4 5 6 7 8 9 
10 11 12 13 14 15 16 17 18 19 
20 21 22 23 24 25 26 27 28 29 
30 31 32 33 34 35 36 37 38 39 
40 41 42 43 44 45 46 47 48 49 
50 51 52 53 54 55 56 57 58 59 
60 61 62 63 64 65 66 67 68 69 
70 71 72 73 74 75 76 77 78 79 
80 81 82 83 84 85 86 87 88 89 
90 91 92 93 94 95 96 97 98 99 
```

```c++
#include <iostream>

int main()
{
    for (int j = 0; j < 10; ++j)
    {
        for (int i = 0; i < 10; ++i)
        {    
            std::cout << j * 10 + i << " ";
        }

        std::cout << "\n";
    }
}
```

How it works:

- the `j` variable is controlling lines (from 0 to 9)
- the `i` variable is controlling numbers from 0 to 9 on the given line
- the value is formed from multiplication - eg line 5 (`j == 5`), number (`i == 3`) is equal to `j * 10 + i` which is 53
- the linebreak is printed after each line - note that if you place the line break in the inner loop the output would make a new line for each number, not a row

**loop counter naming**

It all started with `i`. By the convention, for nested loops next alphabet letters are used: `j`, `k`, ....

However, if you are working with graphics or sort of 2D/3D math, `x`, `y`, `z` names can be used - they will be easier to understand in the calculations.

### triangular output

`for` loops are great for square table-like output if they are nested but with smart use of conditionals, they can be made to print like this:

```
1 
1 2 
1 2 3 
1 2 3 4 
1 2 3 4 5 
```

```c++
#include <iostream>

int main()
{
    for (int j = 1; j <= 5; ++j)
    {
        for (int i = 1; i <= j; ++i) // note the comparison between i and j
        {    
            std::cout << i << " ";
        }

        std::cout << "\n";
    }
}
```

In this case, the inner loop counter `i` is compared with `j` which is different during each outer iteration. This causes consecutive inner loops to look like:

```c++
for (int i = 1; i <= 1; ++i)
for (int i = 1; i <= 2; ++i)
for (int i = 1; i <= 3; ++i)
for (int i = 1; i <= 4; ++i)
for (int i = 1; i <= 5; ++i)
```

In other words, the length of the inner loop increases after each outer loop. Inner loop sizes are, in order: 1, 2, 3, 4, 5. In this example I intentionally ignored the "start from 0 and use <" rule because the inner loop sizes would be 0, 1, 2, 3, 4 which means that the first line would be empty.

## doing something N times

There is a simple trick to do something N times if the control variable is not needed - going down in a `while` loop.

```c++
for (int i = 0; i < n; ++i)
```

can be also done as

```c++
while (n--)
```

The loop counter decreases each iteration as long as it is not 0 (`0` converted to `bool` evaluates to `false`), essentially invoking the body `n` times. With this trick `n` in the loop body is rarely used - usually the body of the loop is always the same - focus is on the number of repeats, not the body chaning depending on the `n`.

## exercise

Count the sum of all natural numbers up to 99 (using a for-loop). Note that in this case starting from 0 or 1 doesn't matter, 0 will not add any value to the sum. For extra effort instead of 99 ask the user for the upper bound.

In other words, count $\sum\limits_{i = 0}^{n}$.

You may also know that there is faster formula to do this, which does not require loops, namely $S_{n} = \frac{n(a_{1} + a_{n})}{2}$. Good compilers can actually optimize the solution and use this formula!

TODO solution code
