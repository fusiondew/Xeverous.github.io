---
layout: article
---

Before any function is used, it must be known what it is - for example to check if argument types match or their amount.

Functions can be split into 2 parts:

- declaration - contains the return type, argument specification and name
- definition - containts all that declaration has + the function's body

It is possible to declare a function and define it's body later:

```c++
#include <iostream>

void greet(); // note: declarations must end with ;

int main()
{
    greet(); // ok, function declared
}

void greet()
{
    std::cout << "hello, world\n";
}
```

Function declaration does not need parameter names, only types.

```c++
#include <iostream>

void func(int, int); // ok, no body so names are not needed

int main()
{
    func(3, 4);
}

void func(int x, int y)
{
    std::cout << x << " * " << y << " = " << x * y << "\n";
}
```

It's still recommended to always write names - in the current examples `x`, `y` don't carry any information but once you start writing more complex functions you will need more descriptive names - otherwise it will not be clear what's the purpose of each parameter.

## advantages of declarations

Obviously, you no longer need to place the function before the main function. It's body can be anywhere, as long as it's declared before it's used. The body of the function can be placed even in a different source file!

Sometimes declarations are necessary - the simplest example are 2 functions that call each other.

```c++
void foo(int x)
{
    if (x == 0)
        return;

    std::cout << "foo: " << x << "\n";
    bar(x - 1); // needs at least declaration of bar
}

void bar(int x)
{
    if (x == 0)
        return;

    std::cout << "bar: " << x << "\n";
    foo(x - 1); // needs at least declaration of foo
}
```

If `foo()` is first, then at least `bar()` must be declared. If `bar()` would be first, at least `foo()` must be declared.

Also, both functions use character output so we also have to include standard I/O stream library before both.

```c++
#include <iostream>

void bar(int x);

void foo(int x)
{
    if (x == 0)
        return;

    std::cout << "foo: " << x << "\n";
    bar(x - 1); // needs at least declaration of bar
}

void bar(int x)
{
    if (x == 0)
        return;

    std::cout << "bar: " << x << "\n";
    foo(x - 1); // needs at least declaration of foo
}

int main()
{
    foo(5);
    std::cout << "\n";
    foo(4);
    std::cout << "\n";
    bar(3);
    std::cout << "\n";
}
```

<details>
<summary>output</summary>
<p>
<pre><code>
foo: 5
bar: 4
foo: 3
bar: 2
foo: 1

foo: 4
bar: 3
foo: 2
bar: 1

bar: 3
foo: 2
bar: 1
</code></pre>
</p>
</details>

## exercise

- Swap the order of the functions and place `bar()` first. Declare what's needed.

<details>
<summary>solution</summary>
<p markdown="block">

~~~c++
#include <iostream>

void foo(int x);

void bar(int x)
{
    if (x == 0)
        return;

    std::cout << "bar: " << x << "\n";
    foo(x - 1);
}

void foo(int x)
{
    if (x == 0)
        return;

    std::cout << "foo: " << x << "\n";
    bar(x - 1);
}

int main()
{
    foo(5);
    std::cout << "\n";
    foo(4);
    std::cout << "\n";
    bar(3);
    std::cout << "\n";
}
~~~

</p>
</details>

- What happens if a negative number is given?

<details>
<summary>answer</summary>
<p>0 can not be catched and in effect the program never finishes - all subsequent calls decrease number even more.</p>
</details>

- What happens if the premature return statement is removed from one of functions?

<details>
<summary>answer</summary>
<p>
Program works normally if the function that had it's return statement removed got an odd number (or the other one an even number). Eg removed return statement from `foo()` but it has got argument 5 - 0 will be catched inside `bar()`.

If it has got an even number, 0 in that function, making it call the other one with -1 - all future calls will just go deeper with no way to stop it.

You can make the program work back by chaning `if (x == 0)` to `if (x <= 0)`.
<p>
</details>

- What happens if the premature return statement is removed from both functions?

<details>
<summary>answer</summary>
<p>
Program runs indefinitely, there is no way to end - `foo()` will always call one more `bar()` and `bar()` will always call one more `foo()`.
<p>
</details>
