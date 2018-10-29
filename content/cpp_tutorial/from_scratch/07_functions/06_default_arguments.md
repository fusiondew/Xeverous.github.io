---
layout: article
---

Sometimes you may encounter a situation where a certain function is very often called with the same argument.

```c++
void print_nums(int x)
{
    for (int i = 0; i < x; ++i)
        std::cout << i << " ";
}


// If we assume that `print_nums` is very often called with `10`, we can write a
// convenience overload that will just call the main version with preset argument:
void print_nums()
{
    print_nums(10);
}
```

However, there is a simpler way to do this:

```c++
void print_nums(int x = 10)
{
    for (int i = 0; i < x; ++i)
        std::cout << i << " ";
}
```

Now the argument `x` is optional. It has a default value which will be used unless specified.

```c++
print_nums();   // uses 10
print_nums(20); // uses 20
```

## rules

- it is possible to have multiple default arguments

```c++
void print_nums_in_range(int first = 0, int last = 10);
```

- if any arguments are defaulted, they must be the rightmost arguments

```c++
void func1(int a,     int b,     int c = 10); // ok
void func2(int a,     int b = 5, int c = 10); // ok
void func3(int a = 0, int b = 5, int c = 10); // ok
void func4(int a = 0, int b,     int c);      // invalid
void func5(int a = 0, int b = 5, int c);      // invalid
void func6(int a = 0, int b,     int c = 10); // invalid
```

This should be obvious as when you are calling a function only the rightmost arguments can be ommited.

## more complex rules

**You do not have to remember these rules. They are borderline cases of the language and the code that relies on them is a bad code. Listed only for reference.**

<details>
<summary>corner-case rules</summary>
<p markdown="block">

- If a function is **redeclared in the same scope**, default arguments can be added.

```c++
void f(int x, int y);
void f(int x, int y = 10); // ok, adds default argument

void h()
{
    void f(int x = 0, int y); // error: not in the same scope
}

void f(int x = 0, int y); // ok, adds default argument (specifying y again would be an error)
```

<div class="note pro-tip">
Write function declaration only once, with everything needed. Don't redeclare to add/fix something - change first declaration instead.
</div>

- If an `inline` function is declared in different translation units, the accumulated sets of default arguments must be the same at the end of each translation unit.

- If a `friend` declaration specifies a default, it must be a friend function definition, and no other declarations of this function are allowed in the translation unit.

- The using-declaration carries over the set of known default arguments, and if more arguments are added later to the function's namespace, those defaults are also visible anywhere the using-declaration is visible.

```c++
namespace N
{
    void f(int, int = 1);
}

using N::f;
void g()
{
    f(7); // calls f(7, 1);
    f();  // error, need 1 or 2 arguments
}

namespace N
{
    void f(int = 2, int);
}

void h()
{
    f();  // calls f(2, 1);
}
```

- The names used in the default arguments are looked up, checked for accessibility, and bound at the point of declaration, but are executed at the point of the function call.

```c++
int a = 1;
int f(int);
int g(int x = f(a)); // lookup for f finds ::f, lookup for a finds ::a
                     // the value of ::a, which is 1 at this point, is not used
void h()
{
    a = 2;  // changes the value of ::a

    {
        int a = 3;
        g();       // calls f(2), then calls g() with the result
    }
}
```

- Local variables are not allowed in default arguments unless used in unevaluated context

```c++
void f()
{
    int n = 1;
    extern void g(int x = n); // error: local variable cannot be a default
    extern void h(int x = sizeof n); // OK as of CWG 2082 (C++14)
}
```

- \[...\] more rules regarding pointers, classes and lambdas (ommited because explained later). Full information: https://en.cppreference.com/w/cpp/language/default_arguments

</p>
</details>

## advantages of default arguments

- Less code - better than wrappers like the one in the beginning of this lesson. Easier to maintain than putting a value at every call.
- Refactoring. Not so rare scenario: some function needs to have additional functionality due to different/new requirements. All the code that is already using the function works, adding a new argument with default value will not break it - in new use cases, you will be able to specify new argument and all of existing uses can rely on default argument
- Extensibility. You can add new argument with defaulted value and it will not break the code, only add a possibility to specify it.

Last 2 are common practices when writing libraries. They extend the functionality while not breaking compatibility of existing code.
