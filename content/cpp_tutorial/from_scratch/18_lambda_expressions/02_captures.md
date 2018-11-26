---
layout: article
---

## deduced return type

Specifying return type in lambdas is optional. You can ommit it if it can be deduced from the return statement.

```c++
auto my_lambda = [](int x)
{
    return x * x + x; // return type deduced to int
};
```

There are few simple (and probably obvious) rules:

- The deduction follows the rules of template argument deduction (templates are explained later, but most of deduction rules are intuitive). Because lambdas behave as if they return type was `auto` by default they return by value (it's not possible to make lambda return a reference without explicitly stating it).

- If there are multiple return statements, they must all deduce to the same type.

```c++
[](bool condition)
{
    if (condition)
        return 3;     // deduces return type int
    else
        return 3.14f; // error: deduces return type float, which is different from int
}
```

- If there is no return statement or if the argument of the return statement is a void expression, the return type is deduced to `void`

```c++
void func();

[]() { } // no return statement - return type deduced to void
[]() { return func(); } // func() returns void, return type deduced to void
```

- Virtual functions cannot use return type deduction
- Once a return statement has been seen in a function, the return type deduced from that statement can be used in the rest of the function, including in other return statements.

These 2 rules only apply to templated and `auto`'d functions. Lambda expressions can not be virtual or call themselves (although one lambda can call another).

- Deduction is not allowed for braced-init-list

```c++
[]()
{
    return { 1, 2, 3 }; // error: deduction not allowed for braced list
}
```

## optional parameter list

Writing parameter list is optional if the lambda takes no arguments. But if you want to specify return type, parameter list must be written.

```c++
[]() -> int { return 42; } // valid
[]()        { return 42; } // also valid
[]          { return 42; } // also valid
[]   -> int { return 42; } // error: expected '{' before '->' token
```

I have seen many people writing `()` anyway even if it was not needed. Perhaps it's rarely used feature because rarely there is an opportunity for parameterless lambda. I also tend to write `()` after `[]` without thinking how many parameters will be needed. I'm not sure whether skipping `()` is just a cosmetic decision or it has actually some deeper (proably future-related) purpose.

#### Question: Is `[]{}` the shortest possible lambda?

Yes. There is no upper limit on longest possible one. We can make some fun stuff with nested lambdas:

```c++
[]{}(); // empty lambda, instantly called - nothing happens
[](){ /* place something here */ }();
[](){[](){[](){[](){[](){[](){}();}();}();}();}();}(); // empty lambda inside lambda inside ...
```

## capturing

Time for the most interesting part of lambdas - the capture.

**Lambda expressions can capture outer scope objects.**

Brief example:

```c++
#include <iostream>

int main()
{
    int a = 0;
    int b = 1;

    auto change = [&](int x)
    {
        a += x;
        b *= x;
    };

    auto print = [&]
    {
        std::cout << "a = " << a << "\nb = " << b << "\n\n";
    };

    print();
    change(1);
    print();
    change(-2);
    print();
    change(-3);
    print();
}
```

<details>
<summary>output</summary>
<p markdown="block">

~~~
a = 0
b = 1

a = 1
b = 1

a = -1
b = -2

a = -4
b = 6
~~~
</p>
</details>

With the power of `[&]`, lambdas can access and modify outer scope objects. There are other captures too.

### capture - description

- `[]` captures nothing

You can not use uncaptured variables:

```c++
int main()
{
    int x = 5;
    auto lambda = []() { x += 2; }; // error: 'x' is not captured
}
```

- `[&]` captures by reference all automatic variables used in the body of the lambda and (if exists) enclosing class object

```c++
#include <iostream>

struct foo
{
    void other_func() {}

    void print()
    {
        auto lambda = [&]()
        {
            std::cout << "I'm at " << this << '\n'; // valid use, this inside a non-static member function
            other_func(); // valid, member functions need this (implicit this->other_func()) and this is captured
        };

        lambda();
    }
};

int main()
{
    foo().print(); // prints some address

    int x = 42;

    auto lambda = [&]()
    {
        x += x; // ok, x is captured by reference
        std::cout << "I'm at " << this << '\n'; // error: 'this' was not captured for this lambda function (not inside an object)
    }
}
```

- `[=]` captures all automatic **variables** used in the body of the lambda **by copy** and (if exists) **current object by reference**

Go back to the first example from this article and change `print` to capture by copy. `change()` will still work, but `print()` will always output that `a` and `b` is `0` and `1`. This is because values of `a` and `b` were saved at the moment the lambda was created. **Lambda capture by copy is not the same as function parameter passed by value.** The values are copied only once - subsequent calls of the lambda will input newer copies.

- `[this]` captures the current object by reference

Note that both `[&]` and `[=]` capture the current object (if it exists) by reference. `[this]` is not very different, but it captures only the current object - nothing else.

- `[*this]` (since C++17) captures current object by value

Things that can always be used (and modified), even without any capture (`[]`):

- non-local variables (aka globals)
- static variables (both static global and static class members)
- `thread_local` variables
- reference that has been initialized with a constant expression

Things that are read only:

- variable that has `const` non-`volatile` integral or enumeration type and has been initialized with a constant expression
- varables that are `constexpr` and trivially copy constructible

Things that can not be captured:

- structured bindings
- `thread_local` variables (but they can be used without capture)

## mixed captures

It's possible to mix different captures if the subsequent captures are different. Multiple variables can be captured by their name.

`[a, &b]` - capture `a` by copy and `b` by reference. Note: it is not `=a`, but just `a`.

`[&, i]` - capture everything by reference, but `i` by copy

`[=, &i]` - capture everything by copy, but `i` by reference

Some obvious rules:

- Captures may not repeat.
- If the capture-default is `&`, subsequent simple captures must not begin with `&`
- If the capture-default is `=`, subsequent simple captures must
    - begin with `&` OR
    - (since C++17) be `*this` OR
    - (since C++20) be `this`

```c++
[i, i]  // error - i repeated
[i, &i] // error - i repeated
[&, &i] // error - repeated & capture
[=, i]  // error - no &, *this or this
[this, *this] // error - this repeated

[&, this]  // ok - the same as [&]
[=, *this] // before C++17 - error: invalid syntax; after C++17 - ok
[=, this]  // before C++20 - error: this when = is default; after C++20 - ok, same as [=]
```

Changes in rules over `this` were made for better code clarity. **It's recommended to always explicitly capture `this` if you want to use the enclosing class object.**
