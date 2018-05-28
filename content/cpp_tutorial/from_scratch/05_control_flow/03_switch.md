---
layout: article
---

There is another way to write else-if blocks: `switch`.

## syntax

```c++
switch (variable)
switch (init-statement; variable) // since C++17
```

Then, multiple `case`s may follow. Each case must use a constant expression (some data available at compile time)

```c++
// all cases must use a different value
case constant_expression1:
    // ...
case constant_expression2:
    // ...
case constant_expression3:
    // ...
```

The execution starts at the first macthed `case`, but unlike in `if`s it does not exclude other branches - everything below first match is executed. This is called **fallthrough** and may be sometimes desirable.

```c++
#include <iostream>

int main()
{
    std::cout << "enter a number: ";
    int x;
    std::cin >> x;

    switch (x)
    {
        case 3:
            std::cout << "you entered 3 or a higher number\n";
        case 2:
            std::cout << "you entered 2 or a higher number\n";
        case 1:
            std::cout << "you entered 1 or a higher number\n";
        case 0:
            std::cout << "you entered 0 or a higher number\n";
    }
}
```

For example, if you enter `2` to the program above, it will print

```
you entered 2 or a higher number
you entered 1 or a higher number
you entered 0 or a higher number
```

The case `2` is matched and the execution begins there. All subsequent cases are also executed - they are not checked if they match - the flow simply goes further.

TODO better example?

## break

You can input a `break` statement to stop the execution

```c++
    // for 1, prints "12345"
    // for 2, prints  "2345"
    // for 3, prints   "345"
    // for 4 and 5, prints "45"
    // for 6, prints "6"
    // for anything else, does nothing
    switch (2)
    {
        case 1: std::cout << "1";
        case 2: std::cout << "2";
        case 3: std::cout << "3";
        case 4:
        case 5: std::cout << "45";
                break;             // execution of subsequent statements is terminated
        case 6: std::cout << "6";
    }
```

If you add `break` to every statement the `swich` behaves the same way as `else-if` blocks.

```c++
#include <iostream>

int main()
{
    std::cout << "enter a number: ";
    int x;
    std::cin >> x;

    switch (x)
    {
        case 3:
            std::cout << "you entered 3\n";
            break;
        case 2:
            std::cout << "you entered 2\n";
            break;
        case 1:
            std::cout << "you entered 1\n";
            break;
        case 0:
            std::cout << "you entered 0\n";
            break;
    }
}
```

## default

You can add `default` case which will be executed only if no other cases were matched. This is equivalent to last `else` (with no following condition) in an `else-if` block.

```c++
#include <iostream>

int main()
{
    std::cout << "enter a number: ";
    int x;
    std::cin >> x;

    switch (x)
    {
        case 3:
            std::cout << "you entered 3\n";
            break;
        case 2:
            std::cout << "you entered 2\n";
            break;
        case 1:
            std::cout << "you entered 1\n";
            break;
        case 0:
            std::cout << "you entered 0\n";
            break;
        default:
            std::cout << "you entered something different\n";
            break;
    }
}
```

## scoping

It's worth to note that while `if`s always introdues an inner scope (so that objects inside `if` have limited lifetime, even if there is no `{}`) the `switch` does not - all `case`s share the same scope. This can sometimes create problems - it's recommended to brace larger cases and the `switch` block.

```c++
switch (x)
{
    case 1:
        int x = 0; // initialization
        std::cout << x << '\n';
        break;
    default:
        // compilation error: jump to default would enter the scope of 'x'
        // without initializing it
        std::cout << "default\n";
        break;
}
```

```c++
switch (x)
{
    case 1:
    {
        int x = 0; // initialization
        std::cout << x << '\n';
        break;
    } // x dies here
    default: // no problems
    {
        std::cout << "default\n";
        break;
    }
}
```

## missing default

Many compilers issue a warning when a switch has no default case - usually it means that the programmer forgot to do something when no case is matched. If you do want to do nothing if no case is matched, just put a `default` with a `break`.

```c++
switch (x)
{
    case 0:
        // ...
    // more cases...
    default:
        break;
}
```

In such scenario it's better to explicitly state that you want to do nothing than make others reading your code question if you have forgot to handle unmatched case.

## summary

Switch comes from C and features a quite unique behaviour - it jumps to the first match (if such exists) and executes all instructions untill switch ends or a break is encountered

- there can be a default case
- all cases must use a constant expression
- you can only test for equality

Because of these, switch in C++ is used mostly as an alternative, shorter version of else-if blocks, most often for enumerations. The possibility of accidental fallthrough can be a good source of bugs, most compilers warn if any case has no break. If a fallthrough is intentional, document it with a comment (smart compilers will understand comments like `// fallthrough`) or an attribute (attributes are explained later).

TODO some tests?
